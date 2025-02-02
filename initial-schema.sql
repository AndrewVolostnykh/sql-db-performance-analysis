create table if not exists recruiters
(
    id           bigserial
        primary key,
    email        varchar,
    phone_number varchar,
    jira_id      bigint not null
);

create table if not exists skills
(
    id   bigserial
        primary key,
    name varchar,
    code varchar,
    type varchar not null
);

create table if not exists specialties
(
    id   bigserial
        primary key,
    name varchar,
    code varchar
);

create table if not exists cvs
(
    id                bigserial primary key,
    first_name        varchar not null,
    mid_name          varchar,
    last_name         varchar not null,
    description       text,
    recruiter_comment text,
    recruiter_id      bigint  not null references recruiters,
    specialty_id      bigint  not null references specialties,
    is_hired          boolean,
    salary            bigint
);

create table if not exists cv_skills
(
    id             bigserial primary key,
    skill_id       bigint not null references skills,
    cv_id          bigint not null references cvs,
    knowledge_rate integer
        constraint cv_skills_knowledge_rate_check
            check (knowledge_rate > 0)
);

create table if not exists cvs_logs
(
    id                bigserial primary key,
    cv_id             bigint,
    created_at        timestamp,
    deleted_at        timestamp,
    comment_on_create varchar,
    comment_on_delete varchar
);

create index if not exists cvs_logs_created_at_brin_idx
    on cvs_logs using brin (created_at);

create or replace view skill_popularity_view(id, code, average_knowledge_rate, popularity_rate) as
SELECT s.id,
       s.code,
       floor(avg(cs.knowledge_rate)) AS average_knowledge_rate,
       count(cs.*)                   AS popularity_rate
FROM skills s
         LEFT JOIN cv_skills cs ON s.id = cs.skill_id
GROUP BY s.id, cs.id
ORDER BY (count(cs.*)) DESC;

create or replace view recruiter_efficiency_view
            (id, email, number_of_hired, main_recruiter_specialty, average_knowledge_rate, total_processed_cvs) as
SELECT cvs.recruiter_id                         AS id,
       (SELECT recruiters.email
        FROM recruiters
        WHERE recruiters.id = cvs.recruiter_id) AS email,
       sum(
               CASE
                   WHEN cvs.is_hired = true THEN 1
                   ELSE 0
                   END)                         AS number_of_hired,
       spec.code                                AS main_recruiter_specialty,
       floor(avg(cvsk.knowledge_rate))          AS average_knowledge_rate,
       count(cvs.*)                             AS total_processed_cvs
FROM recruiters r
         CROSS JOIN cvs
         JOIN specialties spec ON cvs.specialty_id = spec.id
         JOIN cv_skills cvsk ON cvs.id = cvsk.cv_id
GROUP BY cvs.recruiter_id, spec.code;

create or replace view skills_salary_view
            (id, avg_skill_salary, name, max_skill_salary, hired_applicants, specialty_code) as
SELECT skills.id,
       floor(avg(cvs.salary)) AS avg_skill_salary,
       skills.name,
       max(cvs.salary)        AS max_skill_salary,
       count(cvs.*)           AS hired_applicants,
       spec.code              AS specialty_code
FROM skills
         JOIN cv_skills ON skills.id = cv_skills.skill_id
         JOIN cvs ON cv_skills.cv_id = cvs.id
         JOIN specialties spec ON cvs.specialty_id = spec.id
WHERE cvs.is_hired = true
GROUP BY skills.id, spec.code;

create or replace function test_create_cv(numberofcvs bigint) returns void
    language plpgsql
as
$$
declare first_name_gen varchar;
        last_name_gen varchar;
        email_gen varchar;
        recruiter_id_gen bigint;
        specialty_id_gen bigint;
        created_cv_id bigint;
        skill_id_gen bigint;
        knowledge_rate_gen int;
BEGIN
    for i in 1..numberOfCVs loop

            select (array['andrew', 'john', 'stew', 'veronika', 'joshua'])[floor(random() * 5 + 1)] as first_name
            order by random()
            limit 1 into first_name_gen;

            select (array['smith', 'doan', 'singh', 'boscassi', 'gianelli'])[floor(random() * 5 + 1)] as first_name
            order by random()
            limit 1 into last_name_gen;

            email_gen := first_name_gen || '.' || last_name_gen || '@email.com';

            select id from recruiters order by random() limit 1 into recruiter_id_gen;
            select id from specialties order by random() limit 1 into specialty_id_gen;

            insert into cvs(first_name, last_name, recruiter_id, specialty_id, is_hired, salary)
            values (
                       first_name_gen,
                       last_name_gen,
                       recruiter_id_gen,
                       specialty_id_gen,
                       random() > 0.5,
                       floor(random() * (10000-500 + 1) + 500)
                   )
            returning id into created_cv_id;

            select id from skills order by random() limit 1 into skill_id_gen;
            select (random() * 9 + 1)::int into knowledge_rate_gen;

            insert into cv_skills(skill_id, cv_id, knowledge_rate)
            values (skill_id_gen, created_cv_id, knowledge_rate_gen);
--             perform pg_sleep(2);
        end loop;
end;

$$;

create or replace function cvs_after_insert_log_trigger() returns trigger
    language plpgsql
as
$$
DECLARE
    _salary BIGINT;
    _avg_salary BIGINT;
    _comment VARCHAR;
BEGIN
    select salary from cvs where id = NEW.id INTO _salary;
    select floor(avg(avg_skill_salary))
    from skills_salary_view
    where id = (select skill_id from cv_skills where cv_id = NEW.id limit 1)
    group by name INTO _avg_salary;
    if _salary > _avg_salary then
        _comment = 'HIGH_PRICE';
    else _comment = 'NORMAL_PRICE';
    end if;
    INSERT INTO cvs_logs(cv_id, created_at, deleted_at, comment_on_create) VALUES (NEW.id, now(), null, _comment);
    RETURN NEW;
END;
$$;

create trigger cvs_after_insert_log_trigger
    after insert
    on cvs
    for each row
execute procedure cvs_after_insert_log_trigger();

create or replace function cvs_after_delete_log_trigger() returns trigger
    language plpgsql
as
$$
DECLARE
    _salary BIGINT;
    _avg_salary BIGINT;
    _comment VARCHAR;
BEGIN
    select salary from cvs where id = OLD.id INTO _salary;
    select floor(avg(avg_skill_salary))
    from skills_salary_view
    where id = (select skill_id from cv_skills where cv_id = OLD.id limit 1)
    group by name INTO _avg_salary;
    if _salary > _avg_salary then
        _comment = 'HIGH_PRICE';
    else _comment = 'NORMAL_PRICE';
    end if;
    UPDATE cvs_logs SET deleted_at = now(), comment_on_delete = _comment WHERE cv_id = OLD.id;
    RETURN OLD;
end;
$$;

create trigger cvs_after_delete_log_trigger
    after delete
    on cvs
    for each row
execute procedure cvs_after_delete_log_trigger();

create or replace function randomizedates() returns bigint
    language plpgsql
as
$$
declare
    t_curs bigint;
    _day interval;
    _row cvs_logs%rowtype;
begin
    t_curs := 1;
    for _row in select * from cvs_logs loop
            _day := t_curs || ' day';
            update cvs_logs set created_at = date_add(created_at, _day) where id = _row.id;
            t_curs := t_curs + 1;
        end loop;
    return t_curs;
end;
$$;

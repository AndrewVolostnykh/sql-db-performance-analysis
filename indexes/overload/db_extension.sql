-- create 100 000 entries of CVs
select test_create_cv(100000);

-- test insert

EXPLAIN (ANALYZE, COSTS, VERBOSE, BUFFERS, FORMAT JSON) INSERT INTO cvs (first_name, mid_name, last_name, description, recruiter_comment, recruiter_id, specialty_id)
VALUES (
           'Kyrylo',
           'Viktorovych',
           'Korin',
           'I"m just beginner, but love my profession',
           'Has good basic and mid knowledge, so I would recommend to hire',
           5,
           5
       );

-- add couple indexes on every field
-- most of these indexes in nonsense, but used to
-- show index overload and performance degradation
-- when it is too much indexes
CREATE INDEX cv_first_name_hash_idx ON cvs USING hash(first_name);
CREATE INDEX cv_last_name_hash_idx ON cvs USING hash(last_name);
CREATE INDEX cv_description_name_hash_idx ON cvs USING hash(description);
CREATE INDEX cv_mid_name_hash_idx ON cvs USING hash(mid_name);
CREATE INDEX cv_recruiters_comment_hash_idx ON cvs USING hash(recruiter_comment);
CREATE INDEX cv_recruiter_id_hash_idx ON cvs USING hash(recruiter_id);
CREATE INDEX cv_specialty_id_hash_idx ON cvs USING hash(specialty_id);
CREATE INDEX cv_salary_id_hash_idx ON cvs USING hash(salary);

CREATE INDEX cv_first_name_gin_idx ON cvs USING GIN(to_tsvector('english', first_name));
CREATE INDEX cv_last_name_gin_idx ON cvs USING GIN(to_tsvector('english', last_name));
CREATE INDEX cv_description_name_gin_idx ON cvs USING GIN(to_tsvector('english', description));
CREATE INDEX cv_mid_name_gin_idx ON cvs USING GIN(to_tsvector('english', mid_name));
CREATE INDEX cv_recruiters_comment_gin_idx ON cvs USING GIN(to_tsvector('english', recruiter_comment));

CREATE INDEX cv_first_name_btree_idx ON cvs USING btree(first_name);
CREATE INDEX cv_last_name_btree_idx ON cvs USING btree(last_name);
CREATE INDEX cv_description_name_btree_idx ON cvs USING btree(description);
CREATE INDEX cv_mid_name_btree_idx ON cvs USING btree(mid_name);
CREATE INDEX cv_recruiters_comment_btree_idx ON cvs USING btree(recruiter_comment);
CREATE INDEX cv_recruiter_id_btree_idx ON cvs USING btree(recruiter_id);
CREATE INDEX cv_specialty_id_btree_idx ON cvs USING btree(specialty_id);
CREATE INDEX cv_salary_id_btree_idx ON cvs USING btree(salary);

CREATE INDEX cv_first_name_brin_idx ON cvs USING brin(first_name);
CREATE INDEX cv_last_name_brin_idx ON cvs USING brin(last_name);
CREATE INDEX cv_description_name_brin_idx ON cvs USING brin(description);
CREATE INDEX cv_mid_name_brin_idx ON cvs USING brin(mid_name);
CREATE INDEX cv_recruiters_comment_brin_idx ON cvs USING brin(recruiter_comment);
CREATE INDEX cv_recruiter_id_brin_idx ON cvs USING brin(recruiter_id);
CREATE INDEX cv_specialty_id_brin_idx ON cvs USING brin(specialty_id);
CREATE INDEX cv_salary_id_brin_idx ON cvs USING brin(salary);
INSERT INTO recruiters (email, phone_number, jira_id) VALUES ('recruiter1_email@gmail.com', '+3805050505', 1);
INSERT INTO recruiters (email, phone_number, jira_id) VALUES ('recruiter2_email@gmail.com', '+3806060606', 2);
INSERT INTO recruiters (email, phone_number, jira_id) VALUES ('recruiter3_email@gmail.com', '+3807070707', 3);

INSERT INTO skills (name, code, type) VALUES ('Java', 'JAVA', 'Development');
INSERT INTO skills (name, code, type) VALUES ('Java Script', 'JS', 'Development');
INSERT INTO skills (name, code, type) VALUES ('Agile', 'AGILE', 'Project Management');
INSERT INTO skills (name, code, type) VALUES ('Kanban', 'KANBAN', 'Project Management');
INSERT INTO skills (name, code, type) VALUES ('Selenium', 'AQA_SELENIUM', 'Testing');
INSERT INTO skills (name, code, type) VALUES ('Angular', 'ANGL', 'Development');
INSERT INTO skills (name, code, type) VALUES ('Figma', 'FIGMA', 'Design');

INSERT INTO specialties (name, code) VALUES ('Development', 'DEV');
INSERT INTO specialties (name, code) VALUES ('Project Management', 'PM');
INSERT INTO specialties (name, code) VALUES ('Design', 'DESIGN');
INSERT INTO specialties (name, code) VALUES ('Automation Quality Assurance', 'AQA');

INSERT INTO cvs (first_name, mid_name, last_name, description, recruiter_comment, recruiter_id, specialty_id)
VALUES (
           'Vladyslava',
           'Viktorivna',
           'Prazhmovska',
           'I"m good java developer!',
           'Yeah, she is really cool developer :)',
           4,
           5
       );

INSERT INTO cvs (first_name, mid_name, last_name, description, recruiter_comment, recruiter_id, specialty_id)
VALUES (
           'Andrii',
           'Andriyovych',
           'Volostnykh',
           'Just hire me, and you will see the magic',
           'Dammit, he knows what CQRS is',
           5,
           6
       );

INSERT INTO cvs (first_name, mid_name, last_name, description, recruiter_comment, recruiter_id, specialty_id)
VALUES (
           'Elyar',
           null,
           'bin Muhamed',
           'Figma is my main instrument of doing things',
           'Not bad',
           6,
           7
       );

INSERT INTO cvs (first_name, mid_name, last_name, description, recruiter_comment, recruiter_id, specialty_id)
VALUES (
           'Viktor',
           'Volodymyrovych',
           'Korin',
           'A lot of years, a lot of projects',
           'Good guy, but bold',
           4,
           8
       );

INSERT INTO cvs (first_name, mid_name, last_name, description, recruiter_comment, recruiter_id, specialty_id)
VALUES (
           'Kyrylo',
           'Viktorovych',
           'Korin',
           'I"m just beginner, but love my profession',
           'Has good basic and mid knowledge, so I would recommend to hire',
           5,
           5
       );

INSERT INTO cv_skills (skill_id, cv_id, knowledge_rate) VALUES (8, 10, 10);
INSERT INTO cv_skills (skill_id, cv_id, knowledge_rate) VALUES (9, 11, 10);
INSERT INTO cv_skills (skill_id, cv_id, knowledge_rate) VALUES (10, 12, 10);
INSERT INTO cv_skills (skill_id, cv_id, knowledge_rate) VALUES (11, 13, 10);

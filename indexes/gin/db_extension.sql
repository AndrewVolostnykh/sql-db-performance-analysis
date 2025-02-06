-- create 100 000 entries of CVs
select test_create_cv(100000);

-- add metainformation jsonb field to cvs
ALTER TABLE cvs ADD COLUMN metainformation JSONB;

-- random english levels
update cvs
set metainformation = '{"englishLevel": "B1", "array": [1, 2, 3, 4, 5], "someAnotherField": "random2"}'
where id between 5400 and 6200;

update cvs
set metainformation = '{"englishLevel": "C1", "array": [1, 2, 3, 4, 5], "someAnotherField": "random"}'
where id between 3200 and 5800;

update cvs
set metainformation = '{"englishLevel": "B2", "array": [1, 2, 3, 4, 5], , "someAnotherField": "random3"}'
where id between 200 and 3000;

CREATE EXTENSION IF NOT EXISTS pg_trgm;
CREATE INDEX cv_last_name_like_gin_idx ON cvs USING gin(last_name gin_trgm_ops);
CREATE INDEX cv_metainformation_gin_idx ON cvs USING gin(metainformation);

-- analyze json operator search
EXPLAIN (ANALYZE, COSTS, VERBOSE, BUFFERS, FORMAT JSON) select * From cvs where metainformation @> '{"englishLevel": "B2"}';

-- analyze LIKE operator search
EXPLAIN (ANALYZE, COSTS, VERBOSE, BUFFERS, FORMAT JSON) select * From cvs where last_name like '%cass%'
### Initial DB
- After execution [initial db](../../initial-schema.sql)
called [extension](db_extension.sql) to create 100_000 entries
- Table `cvs` was altered to add new column `metainformation:jsonb`
- Add `pg_trgm` extension to DB

### LIKE Operations

#### Search using `LIKE` before adding indexes
Let's check execution plan: [execution plan](simple_like_search_no_index.png)
After executing search by `lastName` using `LIKE` operator,
we can see Query Planner having a problems with search.
It sequentially scans table in search of entry. Big program is in
filtering 79% of rows to find needed

#### Indexes
We just add `GIN` index on `lastName` using `gin_trgm_ops` 

#### Search using `LIKE` after adding indexes
After adding index we can see situation is much better with execution plan and execution results: [execution plan](simple_like_search_no_index.png)
Execution time is 2 times lower the same about cost,
because DBMS no more need to filter sequentially 79% of rows

### JSONB

#### Search using `jsonb operation` before adding indexes
The same situation we can see with JSONB operations. 
Looking to [execution plan](simple_jsonb_search_no_index.png) we can see that 99% of rows has been filtered,
cost is very high. The complexity of such operations will have linear growth
according to sequential scan of all rows

#### GIN Indexes
Just adding GIN index to `metainformation` field and no more else

#### Search using `jsonb operation` after adding indexes
As we can see in [execution plan](simple_jsonb_search_with_index.png) DBMS for now
have no problems. Execution time 3 times lower than without index and problem with 
filtering no more observable



### Initial DB
After execution [initial db](../../initial-schema.sql)
called [extension](db_extension.sql) to create 100_000 entries

### Insert before adding indexes
Let's perform insert to `cvs` before we add indexes.
At the [query plan](insert_before_indexes.png) we can see it took just 0.078ms. 

### Indexes
After that in [extension](db_extension.sql) prepared and called alot of indexes.
Most of them are nonsense, but good example of excessive adding indexes
to have a good performance when selecting data

### Insert after adding indexes
At execution scripts to add indexes we see [query plan](insert_after_adding_indexes.png)
of insert.
So time increased to 0.979ms (almost 1 sec) because of rebuilding a lot of indexes

### Result
When we are adding indexes to have perfect performance on select,
it seriously affects performance of insert and update.
So in this case, when we need to read data often and fast,
because of a lot of indexes it is required to revise DB architecture.

Good decision could be to split table for 'master/salve', create materialized view,
sharding tables, even using special patterns to split instances of DB for
view and insert.
### Idea

The main idea of this project is an analysis of DB performance.
Here is a looking at different performance cases in different business contexts.
---
### See analysis results:

#### Indexes:

- [BRIN index Analyze](indexes/brin/ANALYZE_RESULT.md)
- [BTREE index Analyze](indexes/btree/ANALYZE_RESULT.md)
- [GIN index Analyze](indexes/gin/ANALYZE_RESULT.md)
- [GIST index Analyze](indexes/gist/ANALYZE_RESULT.md)
- [HASH index Analyze](indexes/hash/ANALYZE_RESULT.md)
- [SP-GIST index Analyze](indexes/spgist/ANALYZE_RESULT.md)
- [Indexes overload](indexes/overload/ANALYZE_RESULT.md)

#### Sharding

- [Vertical sharding](sharding/vertical/ANALYZE_RESULT.md) - split table to several separated
- [Horizontal](sharding/horizontal/ANALYZE_RESULT.md) - split DB to several instances

#### Views

- [Basic View](views/basic/ANALYZE_RESULT.md)
- [Materialized View](views/materialized/ANALYZE_RESULT.md)

## INITIAL DB

As an initial DB implemented in [file](initial-schema.sql)

Contains a couple of tables, domain is company's recruitment,
couple functions and triggers.

Every package of analysis contains extension for database.
It is required to represent real enterprise cases where indexes and
sharding is necessity, not option
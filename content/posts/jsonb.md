---
title: "Jsonb in PostgreSQL"
date: 2023-07-21T10:20:00+01:00
draft: true
toc: false
tags:
  - Modeling
  - PostgreSQL
---

- ease of use
- draw backs
  - limitation on index usage (insufficient for 1-n relation)
  - limitation on constraints/consistency
  - space requirements (type mapping, field names)
  - expensive to update (WAL, TOAST)
  - expensive to update with index
- when to use: advantage outweigh drawbacks
  - medium sized cardinality values
  - no constraints required
  - varying schema
    - conditional foreign keys? (see Albe)
- alternative
  - array and positional encoding instead of field names
  - hstore

[JavaScript Object Notation][wikijson] - also known as JSON - is a quite popular
standard for data serialization.  Introducing the [Jsonb data type][jsonb] had a
big [impact on the adoption][bartunov] of PostgreSQL.  While Jsonb is versatile
and many powerful functions enable meaningful operations and modifications of
data in PostgreSQL, it also has some limitations.  Those should be considered
when we design a data model in PostgreSQL.

If you would need to build a system which offers information about parks in a
city and the individual trees in every park.  We could model the park as a json
object with a list of tree objects.  While this might be the appropriate mapping
from our class model, the database would not be able to ensure that every tree
has only one entry in the table --- we lack the unique constraint on trees.

PostgreSQL supports GIN and GIST indexes for columns of type Jsonb.  Btree
indexes are not supported
Limitations:
- unique constraint, 1-n relation modeling
- filter
- update

[bartunov]: http://www.sai.msu.su/~megera/postgres/talks/jsonb-pgconfnyc-2021.pdf
[wikijson]: https://en.wikipedia.org/wiki/JSON
[jsonb]: https://www.postgresql.org/docs/current/datatype-json.html

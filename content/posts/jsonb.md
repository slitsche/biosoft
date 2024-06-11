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
- the good parts?
  - reduces effort for data modeling when we have to deal with varying input
    data structures
  - is an option to model object hierarchies and varying schema (see conditional
    FK below)
  - enables search on Json input data
  - enables simple delivery of Json as output (conversion); low effort, small
    microservices
- draw backs
  - limitation on index usage (insufficient for 1-n relation)
  - limitation on constraints/consistency
    - universal modeling considered harmful
  - space requirements (type mapping, field names)
    - stringly typed is bad in programming languages.  It's even less useful for
      storage.
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
  - storage vs interface: json as exchange format with DB.
- Challenges:
  - Null encoding

[JavaScript Object Notation][wikijson] - also known as JSON - is a quite popular
standard for data serialization.  Introducing the [Jsonb data type][jsonb] had a
big [impact on the adoption][bartunov] of PostgreSQL.  While Jsonb is versatile
and many powerful functions enable meaningful operations and modifications of
data in PostgreSQL, it also has some limitations.  Those should be considered
when we design a data model in PostgreSQL.

If you would need to build a system which offers information about parks in a
city and the individual trees in every park.  We could model the park as a json
object with a list of tree objects.

TODO: Code example?

While this might be the appropriate mapping
from our class model, the database would not be able to ensure that every tree
has only one entry in the table --- we can not define the unique constraint on
trees.  We have fewer options to declare constraints on our data model.

This data model using Jsonb has also consequences on the read path.
PostgreSQL supports GIN and GIST indexes for columns of type Jsonb.  Btree
indexes are not supported
Limitations:
- unique constraint, 1-n relation modeling
- filter
- update

actually --- we can enforce uniqueness.  We could use the exclude
constraint.  It would look like this:

    CREATE TABLE testtable(
        id serial PRIMARY KEY,
        refs integer[],
        EXCLUDE USING gist ( refs WITH && )
    );

But this is not as straight forward, likely less performant and does not express
the intent as clearly as `UNIQUE CONCSTRAINT ref` or `CREATE UNIQUE INDEX...`.




[bartunov]: http://www.sai.msu.su/~megera/postgres/talks/jsonb-pgconfnyc-2021.pdf
[wikijson]: https://en.wikipedia.org/wiki/JSON
[jsonb]: https://www.postgresql.org/docs/current/datatype-json.html

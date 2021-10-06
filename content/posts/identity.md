---
title: "Unique is not enough"
date: 2021-07-12T17:26:00+01:00
draft: true
toc: false
---

On our way from monolithic applications to a microservice architecture a
property provided by databases got lost --- the unique constraint.  We need a
different approach to mitigate the consequences of this missing property.

## Why an `id` is not sufficient

When designing a database schema it is considered a good habit to use a
[natural key][natural] as primary key.  If we have a [synthetic key][surrogate]
only (also known as surrogate key), we should have additionally an unique key.

Why should there be a unique key when a synthetic primary keys is present?
Because we want to be able to derive predications about the real world.
Generating a UUID or using a [sequence object][sequence] does not help here: it
provides us with uniqueness but it lacks the property of [identity][identity]
for the rows in the table.

If our database table contains information about things which we can point
at, we often are able to use a natural key (items in a warehouse, trees in
park).  Those things are often labeled with a name and we can use that name as a
natural primary key in our table.  In this case uniqueness ensures identity of
our relation with the real world.

But more often we deal with things we can not point at: e.g. a mother or a
purchase.  Those are relations you can't touch.  If we need to handle those
relations in our information system we need to understand their identity.  A
purchase has an identity because any item on stock can be sold only once by the
seller to the buyer.  Our purchase has a natural unique key containing customer,
merchant and item.

The presence of a single column primary key simplifies the definition of
references.  But more important for the purpose of the information system is the
presence of the unique key[^1].  With its definition no value could enter the
system which does not represent the entity in the real world.  Therefore a
PostgreSQL database could act as an oracle telling always the truth.  We would
lose this valuable property if we merely had a primary key which is
automatically generated.


## Identity and messaging

In our new world of distributed microservices our database schema got
distributed across many microservices.  Along the way we got messages with a
schema persisted in a data lake.  The schema on write made way for the schema on
read[^2].  Different encodings like json, parquet or avro focus on the
definition of the record.  Some systems declare [unique
identifiers][metadataeid] and leave the responsibility to the producer.  But...

The unique constraints got lost.

That unique identifier (the `eid`) is like a surrogate key prone to the error an
additional unique key should prevent.  Since there was a need to create unique
values without locks in a distributed environment UUID has been widely adopted.
Now we use those as identifiers.  They are unique but it is unclear, what they
identify.  It depends how they are generated and associated with the message,
but this is hidden for the consumer.

<!--

Since identity is not required
and cannot be enforced (by the schema) there is no guarantee a message (business
event) which carries the very same payload does not have a duplicate with a
different event id.  This means there will be duplicate rows (in respect to the
real world) which will have different identifiers.

The definition of unique identifiers created by a system will ensure the system
works from a technical point of view.

-->


## World view

Since our database schema got distributed additional effort is needed to make
sense out of the distributed data.  In order to be of a purpose for the business
we must be able to relate the blocks of information to the real world.

With the decision for a distributed system we also accepted that messaging is
not reliable.  If we go for at-least-once delivery we have to [expect
duplicates][leastonce] will end up in our data lake.  Since there is no instance
enforcing a unique constraint (like the database was) the rules need be defined
on read.  The unique constraint on write made way for unique constraint on read.

If there is no (machine readable) definition of unique constraints, different
readers will eventually implement deduplication differently.  This will lead
(eventually) to the situation that different analysts will analyze
the data differently.

It is already [a known problem in science][psychology] that the same data set can
be analyzed in respect to a given question with contradicting results.  An
important remark from the research is

> "that analysts’ prior beliefs about the effect did not explain the variation
> in outcomes, nor did a team’s level of statistical expertise or the peer
> ratings of analytical quality."

Making sense out of data is already a difficult business.  I think a missing
a common view of what a row identifies makes it even more complicated.

How could we mitigate this issue?  I think there are a couple of options:

- Declare the fields in the schema which uniquely identify the entity so that it
  would also be machine readable.
- Declare a business transaction id ([idempotence to the rescue][no-reliable])
- If UUID needs to be used, generate it deterministically: derive the UUID from
  the fields which make the event unique (natural key or candidate key) if
  possible.
- If random UUID need to be used special care has to be taken.


[^1]: It is also referred to as [candidate
    key](https://en.wikipedia.org/wiki/Candidate_key).

[^2]: An extensive discussion of schemaless data models, schema-on-read vs schema
on-write can be found in Kleppmann, M.: Designing Data-Intensive
Applications. O'Reilly 2017.


-----------

[psychology]: https://www.psychologicalscience.org/publications/observer/obsonline/how-researchers-can-find-different-results-using-the-same-data.html
[surrogate]: https://en.wikipedia.org/wiki/Surrogate_key
[natural]: https://en.wikipedia.org/wiki/Natural_key
[identity]: https://en.wikipedia.org/wiki/Identity_relation
[sequence]: https://www.postgresql.org/docs/current/functions-sequence.html
[metadataeid]: https://nakadi.io/manual.html#definition_EventMetadata
[leastonce]: https://nakadi.io/manual.html#client-rebalancing
[no-reliable]: https://www.infoq.com/articles/no-reliable-messaging/

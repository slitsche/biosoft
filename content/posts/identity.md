---
title: "Unique is not enough"
date: 2021-12-20T11:26:00+01:00
draft: true
toc: false
tags:
  - Modelling
---

On our way from monolithic applications to a microservice architecture a
property provided by databases got lost --- the unique constraint.  We need an
approach to mitigate the consequences of this missing property.

## Why an `id` is not sufficient

When designing a database schema it is considered a good habit to use a [natural
key][natural] as primary key.  If our database table contains information about
things which we can point at (e.g. items in a warehouse, trees in park), we
often are able to use a natural key .  Those things are labeled with a
name and we can use that name as a natural primary key in our table.  In this
case uniqueness ensures identity of our table with the real world.

But more often we deal with *relations* at which we can not point: e.g. a mother
or a purchase.  If we need to handle those relations in our information system
we need to understand their identity.  A purchase has an identity because any
item on stock can be sold only once by the seller to the buyer.  Our purchase
has a natural unique key containing customer, merchant and item[^a].

In such a case having a [synthetic key][surrogate] only (also known as surrogate
key, a `purchase_number` in our example) is not sufficient, we should have
additionally an unique key (the tuple `[customer merchant item]` in our
example).  But why?  Because we want to be able to derive predications about the
real world.  Uniqueness as provided by a synthetic key does not help here.  When
we generate an UUID or use a [sequence object][sequence] we will achieve
uniqueness.  But it lacks the property of [identity][identity] for the rows in
the table.

The presence of a single column primary key simplifies the definition of
references in our database.  But more important for the purpose of the
information system is the presence of the unique key[^1].  With its definition
no row could enter the system which does not represent the entity (the relation
in our case) in the real world.  Therefore a PostgreSQL database could act as an
oracle telling always the truth.  We would lose this valuable property if we
merely had a primary key which is automatically generated.


## Diverged information

In our new world of distributed microservices our database schema got
distributed across many microservices.  Along the way we got [events]({{< ref
"posts/turtle-event-category" >}}) with a schema persisted in a data lake.  The
schema on write made way for the schema on read[^2].  Different encodings like
json, parquet or avro focus on the definition of the record.  But...

The unique constraints got lost.

Some systems declare [unique identifiers][metadataeid] and leave the
responsibility to the producer.  Since services emit events we tend to treat all
the different event types as similar and therefore it seems to be obvious to
declare an event id as a general identifier.  That unique identifier is like a
surrogate key prone to the error an additional unique key would prevent in our
relational database.

Since there was a need to create unique values without locks in a distributed
environment UUID has been widely adopted.  Now we use those as identifiers.
They are unique but it is unclear, what they identify.  It depends on how they
are generated and associated with the event.  If a developer generates a new
value for the event id on every retry of a failed sending of events we get a unique
ID - but duplicate rows can end up in the data lake.  Those duplicates cannot be
eliminated using the event id.

By generalizing the event id (as a technical means) we lose the connection to
the business.  Only adding the generalized event id creates the possibility that
both information diverge.  Not having an event id would require a different
approach to deal with duplicates.

## Constraint on read

With the decision for a distributed system we also accepted that messaging is
not reliable.  If we go for at-least-once delivery we have to [expect
duplicates][leastonce] which end up in our data lake.  Since there is no
instance enforcing a unique constraint (like the database was) the rules need be
defined on read.  The unique constraint on write made way for *unique constraint
on read*.

Now that business data and event id diverge the event id cannot be used for that
purpose.  Having the unique fields declared in the event type metadata would be
useful for many consumers.

If there is no (machine readable) definition of unique constraints,
different readers will eventually implement deduplication differently.  This
will lead to the situation that different analysts will analyze the
data differently.

It is already [a known problem in science][psychology] that the same data set can
be analyzed in respect to a given question with contradicting results.  An
important remark from the research is

> "that analysts’ prior beliefs about the effect did not explain the variation
> in outcomes, nor did a team’s level of statistical expertise or the peer
> ratings of analytical quality."

## Conclusion

Making sense out of data is a difficult business.  I think a missing
common view of what a row identifies makes it even more complicated.

How could we mitigate this issue?  I think there are a couple of options:

- Declare the fields in the schema which uniquely identify the entity so that it
  would also be machine readable.
- Declare a business transaction id ([idempotence to the rescue][no-reliable])
  or use it as event id
- If event id needs to be used, generate it deterministically: derive the UUID
  from the fields which make the event unique (natural key or candidate key) if
  possible.
- If random UUID need to be used special care has to be taken.


[^a]: We assume there are no returned items.

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
[turtle]: turtle-event-category

---
title: "Unique is not enough"
date: 2021-07-12T17:26:00+01:00
draft: true
toc: false
---

On our way from monolithic applications to a microservice architecture a
property provided by databases got lost --- the unique constraint.  We need a
different approach to mitigate the consequences of this missing property.

# Why an `id` is not sufficient

When designing a database schema it is considered it a good habit to have either
a [natural key][natural] or if we have a [synthetic][surrogate] key only we
should have additionally an unique key.

Why should there be a unique key when a synthetic primary keys is present?
Because we want to be able to derive predications about the real world.
Generating a UUID or using a [sequence object][sequence] does not help here: it
provides us with uniqueness but it lacks the property of [identity][identity].

If our database table contains information about things at which we can point
at, we often are able to use a natural key (items in a warehouse, trees in
park).  Those things are often labeled with a name and we can use that name as a
natural primary key in our table.  In this case uniqueness ensures identity of
our relation with the real world.

But more often we deal with things we cannot point at: e.g. a mother or a
purchase.  Those are relations you cannot touch.  If we need to handle those
relations in our information system we need to understand their identity.  A
purchase has an identity because any item on stock can be sold only once.  We
also need the buyer and the seller.  Our purchase has a natural unique key
containing customer, merchant and item.

The presence of a single column primary key simplifies the definition of
references.  But more important for the purpose of the information system is the
presence of the unique key.  With its definition no value could enter the system
which does not represent the entity in the real world.  Therefore a PostgreSQL
database could act as an oracle telling always the truth.  We would lose this
valueable property if we merely had a primary key which is automatically
generated.


# Identity and messaging

In our new world of distributed microservices our database schema got
distributed across many microservices.  Along the way we got messages with a
schema persisted in an data lake.  The schema on write made way for the schema
on read[^1].  Different encodings like json, parquet or avro focus on
the definition of the record.  If we are lucky and use [Nakadi][metadataeid] we
are requested to use an unique identifiers.

The unique constraints got lost.

Since there was a need to create unique values without locks in a distributed
environment UUID has been widely adopted.  Now we use those as identifiers.
They are unique but it is unclear, what they identify.  It depends how they
are generated, but this is hidden for the consumer.  The `eid` is a surrogate
key prone to the error an additional unique key should prevent.

<!--
Nakadi documentation says the `metadata.eid`

    SHOULD be guaranteed to be unique from the
    perspective of the producer.
check api guidellines
https://opensource.zalando.com/restful-api-guidelines/#event-metadata
https://opensource.zalando.com/restful-api-guidelines/#211
talks only about uniqueness property!!!

https://opensource.zalando.com/restful-api-guidelines/#214 at least once

Since identity is not required
and cannot be enforced (by the schema) there is no guarantee a message (business
event) which carries the very same payload does not have a duplicate with a
different event id.  This means there will be duplicate rows (in respect to the
real world) which will have different identifiers.

The definition of unique identifiers created by a system will ensure the system
works from a technical point of view.

-->

<!--
TODO: nakadi documentation,  API guidelines
-->

# World view

Since our database schema got distributed additional effort is needed to make
sense out of the distributed data.  In order to be of a purpose for the business
we must be able to relate the blocks of information to the real world.

Due to the nature of messaging we have to [expect duplicates][leastonce].  Since
there is no instance enforcing a unique constraint (like the database was) the
rules need be defined on read.  The unique constraint on write made way for
unique constraint on read.

If there is no machine readable definition of unique constraints different
readers will eventually implement deduplication differently.  From the company
perspective this will lead to the situation that different analysts will analyse
the data differently.

It is already [a known problem in science][psychology] that the same dataset can
be analyzed in respect to a given question with contradicting results.  An
important remark from the research is

> that analysts’ prior beliefs about the effect did not explain the variation
> in outcomes, nor did a team’s level of statistical expertise or the peer
> ratings of analytical quality.

<!-- Since only the decisions during the statistical analysis was the object of the -->
<!-- research it is fair to assume the data set is clear documented and clean. -->

Lacking a common view on the unique constraints the variation will lead to
different results in the preparation of the data.  This variation adds to the
above mentioned variation of the analysis.  What does this mean for a company
when every business unit has a different view of the business?

How can we mitigate this issue?  I think there are a couple of options:

- Declare the fields in the schema which uniquely identify the entity
- Communicate more and live a review process
  https://opensource.zalando.com/restful-api-guidelines/#195
- Avoid a UUID when possible.
- If UUID needs to be used, generate it deterministically: derive the UUID from
  the fields which make the event unique (natural key) if possible.

[^1]: An extensive discussion of schemaless data models, schema-on-read vs schema
-on-write can be found in Kleppmann, M.: Designing Data-Intensive
Applications. O'Reilly 2017.

-----------

[psychology]: https://www.psychologicalscience.org/publications/observer/obsonline/how-researchers-can-find-different-results-using-the-same-data.html
[surrogate]: https://en.wikipedia.org/wiki/Surrogate_key
[natural]: https://en.wikipedia.org/wiki/Natural_key
[identity]: https://en.wikipedia.org/wiki/Identity_relation
[sequence]: https://www.postgresql.org/docs/current/functions-sequence.html
[metadataeid]: https://nakadi.io/manual.html#definition_EventMetadata
[leastonce]: https://nakadi.io/manual.html#client-rebalancing

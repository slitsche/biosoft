---
title: "Event Categories and Turtles"
date: 2020-11-30T16:48:41+01:00
draft: false
toc: false
---

Often in the past I had the discussion with colleagues about the question: When
should one choose a business event over a data change event?  I was not able to
tell the difference in a sentence.  So I tried to write it down.

## Context

[Nakadi](https://nakadi.io/) defines -- besides an undefined category -- [two
different categories of event types][event-types]: business events and data
change events.  If one fits better than the other defines the context.  I will
focus on one in this article.

In an [event-driven architecture][oreilly-event] microservices communicate by
exchanging events.  When archived those events produce a change log which is
important for analytical use cases.

## Differences between Event Categories


### Content of Information

The business event contains all information representing the triggering event.
It is possible to design business event types in a scarce way because every
single business event represents a change.  Every byte we persist is relevant.

In contrast data change events always contain all data for all attributes of the
[business object][bo], no matter if the field has been touched by the triggering
event or not.  This means on the other hand data change events carry
information which is irrelevant for the triggering event.  That said, it means
per byte it contains less information.

Above paragraphs reveal a problem with our language: there are different
notions behind the term "event".  First there is the event which describes what
happens when a user interacts with the system (e.g. a customer places an
order).  Second it describes the data structure holding information about
that event.

The data change event category misses the information about the triggering event
while it is present in the name of the event type for business events.  This has
some consequences.

### Evolving the System

I understand the event driven architecture in a way that systems exchange
messages (events) and the specific type of the event allows interested parties
(consumers) to react in a specific and appropriate manner. Given an event type
"object has changed" which specific action will it allow the consumer to
derive from?  Imagine you want to send the customer a notification that his
payment was received.  It would be quite difficult to enable this use case if only
an `order_has_changed` data change event is emitted.

While with business events it is possible to have separate services for every
single event it is not possible for the data change event.  If a single
microservice *S* emits business event types (*E1* and *E2*) it can be cut into
several services *without* need to redesign the event types.  Subsequently *S'*
could emit *E1* and *S''* could emit *E2*.  This implies that the architectural
change can be done without impact on the consumers of those events.  The same is
not as simple for data change events.


### Efficiency

A data change event has one advantage.  The consumer can reconstruct the latest
state by processing only the last message and discarding all others.  This is
already part of the problem: discarding means wasted resources and is a
consequence of the reduced content of information.

In the context of business analytics we often deal with questions in regard to
events (in the notion of "interaction with the system").  Retrieving that
information requires to search for when a certain field was changed.  This is a
quite complex computation on that data model compared to business events.

Business events require more design effort and understanding of the business
case.  But every piece in it is relevant.  This is simple from the system point
of view.  It is also efficient from the operational point of view.

## Summary

In an event-driven architecture you have only event producers and consumers
exchanging messages which we call "events".  In this model there aren't
databases.  Data change events make sense, if we want to replicate databases or
tables.  But calling them "events" will lead the reader to the assumption both
are different kind of turtles.  But they aren't.

Using the event broker and its event transport system moves the statement level
logging of a RDBMS up to level of communication of components within a
distributed system (therefore the [`data_op` field][data_op] is required).
Having both categories in the very same event broker *and* calling both "events"
could lead to the notion they can be used interchangeably.  Doing so would add
severe limitations on the options to evolve the system in which the microservice
is a component.  As Jessica Kerr pointed it out so nicely: "[It's never turtles
all the way down][turtles]".

[event-types]: https://nakadi.io/manual.html#using_event-types
[data_op]: https://nakadi.io/manual.html#definition_DataChangeEvent
[oreilly-event]: https://www.oreilly.com/library/view/software-architecture-patterns/9781491971437/ch02.html
[turtles]: https://jessitron.com/2020/11/24/every-level-is-different/
[bo]: https://en.wikipedia.org/wiki/Business_object

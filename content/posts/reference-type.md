---
title: "Kinship and Reference Types"
date: 2022-11-04T10:20:00+01:00
draft: true
toc: false
tags:
  - Modeling
---

## Kinship

In the middle of the 19th century the anthropologist [Lewis Morgan][morgan]
investigated the society and relationships among American aborigines.  He
observed that native Americans used a terminology for their relationships which
do not match the family in which they lived.  A couple of man and woman was
living together for a long period which made it clear what their children were.
However a man called "children" all offspring of him and of his brothers.  All
offspring of his sisters were his nephews and nieces.  The same was true for
woman.  A mother called all her offspring and the offspring of her sisters
"children".

Interestingly, it has been found a society which actually lived this type of
relationship in the Polynesian islands.  However, their names for relationships
again did not match what they lived.  All members of one generation, all
brothers and sisters have been called mothers and fathers for all of their
offspring.

I think this example nicely shows that our language may evolve slower than our
reality.  Our reality in the IT industry evolves as well, even faster than the
kinship.  Our language sometimes might not keep up.

## Reference Type

We often tend to look at the database schema plainly from a technical point of
view (e.g. ensuring consistency or referential integrity).  But I consider it as
wonderful documentation.  Since RDBMS expose information about the schema via
views in the `information_schema` we can nicely explore it using SQL.  It
documents not only tables with their attributes but also the relations between
those tables.  In my experience from many projects the schema is known by most
stakeholders.  It is used for communication.  The nice thing about the schema is
that it provides an *explicit* representation of our model of the domain.  This
model can now be used as a reference in the communication --- in case of doubt
we can look it up and resolve uncertainty.

Besides the communication declaring a [foreign key constraint][fk] results in an
important quality of the data.  In a column with such a constraint all values
are a subset of another well defined set.  The reader of this table can rely on
that every single reference in this column has an existing referent.  It also is
clear which attributes from this referent could be gotten --- one simply could
follow all the documented references.  The identifier of the referent I will
call in the following a *reference type*.  In programming [the same term][wiki]
is used to distinguish the different ways of memory allocation during run time.
In this context we not only want to differentiate value types from reference
types.  Here we need distinguish different types of references: books, shelfs,
customers etc.  Hence the data type of the foreign key column is a specific
reference type.  The reference type of a book is different from that of a shelf.

In our changed world of distributed systems and separation of storage and
compute (a.k.a. big data) our data dictionary looks not as rich as in earlier
times.  Data lakes typically [do offer neither unique constraint]({{< ref
"unique-not-enough" >}} "Unique is not enough") nor foreign key.

It results in high effort on research and communication for the consumers
(engineers, analysts) which want to use existing data.  Imagine an organization
with hundreds or even thousands of tables.  How would an analyst even start to
find candidate data sets for the current project?  First you will need to know
which reference types are available in one table and which other tables offer
the same reference type for correlation.  But which data types are currently
available for describing a table structure?  String, differently sized numbers,
timestamps - those information tell the reader something about some operations
(e.g. addition for numbers) one could apply to the values, but not the set of
values which are valid for a certain column.  One of the most powerful
operations is missing: correlation.

Often engineers try to address this missing information by naming columns with
the intent to document the reference type.  More advanced approaches use tools
to derive information about reference types by means of [column level data
lineage][lineage].

This has some shortcomings.  First column level data lineage is not widely
available and difficult to retrieve via machines.  Second it can only document
after the fact that there are multiple reference types in one column present.
Last but not least without the reference type we still could not *talk* about
reference types.  Communication is so important when producer and consumer need
to align on expectations on data.

## Conclusion

If we would have a reference type in our data dictionary (as an attribute of a
column) what would be possible?

- We could easily search for tables which could be used in analysis to enrich
  existing data.
- We could have more informative names of columns in tables.
- We could enable automatic validation of data (referential integrity on read).
- We could better protect data from being leaked to where they should not be
  shared.
- We could increase the speed of change by reducing the impact of not compatible
  changes.
- We could establish a vocabulary which allows communication across domains.

Just some thoughts.


[morgan]: https://en.wikipedia.org/wiki/Lewis_H._Morgan
[lineage]: https://www.castordoc.com/blog/what-is-data-lineage
[wiki]: https://en.wikipedia.org/wiki/Value_type_and_reference_type
[fk]: https://en.wikipedia.org/wiki/Foreign_key "Foreign Key in Wikipedia"

---
title: "Language, Evolution and Reference Types"
date: 2022-11-04T10:20:00+01:00
draft: true
toc: false
tags:
  - Modeling
---

## Language evolution

In the middle of the 19th century the anthropologist [Lewis Morgan][morgan]
investigated the society and relationships among American aborigines.  He
observed that native Americans used a terminology for their relationships which
do not match the family which was lived.  A couple of man and woman was living
together for a long period which made it clear what their children are.  However
a man called "children" all offspring of him and of his brothers.  All
offspring of his sisters were his nephews and nieces.  The same was true for
woman.  A mother called all her offspring and the offspring of her sisters as
children.

Interestingly it has been found a society which actually lived this type of
relationship in the Polynesian islands.  However, their names for relationships
again did not match what they lived.  All members of one generation, all
brothers and sisters have been called mothers and fathers for all of their
offspring.  The people were lacking proper words for the kinship
they were living in.

I think this example nicely shows that our language may develop slower than our
reality.  Our reality in the IT industry seems to evolve fast as well.  Our
language sometimes does not keep up.  I sometimes have the impression we miss
some words too.

## Referential Integrity

Relational databases are able to ensure referential integrity.  It can do this
if a developer has declared this specific relation between a column of one table
and the unique constraint of another table.  This foreign key relationship has
two important purposes: ensure referential integrity of the data during
modification and documentation.

We often tend to look at schema plainly from a technical point of view (ensuring
consistency).  But I consider it as a wonderful documentation.  Since RDBMS
expose information about the schema via views in the ~information_schema~ we can
nicely explore it using SQL.  It documents not only tables with their attributes
but also the relations between those tables.  In my experience from many
projects the schema is known by most stakeholders.  It is used for
communication[^1].

In our changed world of distributed systems and separation of storage and
compute (a.k.a. big data) our data dictionary [looks not as rich]({{< ref
"unique-not-enough" >}} "Unique is not enough") as in a RDBMS.  We try to
address this missing information by naming columns with the intent to document
the reference type or we build more systems to derive information about
reference types by means of [column level data lineage][lineage].

In my point of view this lacks an important feature.  A column with a reference
constraint had exactly one reference type - not two or three, one.  It means all
values in this column are a subset of another well defined set.  The reader of
this table can rely on that the every single reference in this column has an
existing referent.  It also was clear which attributes from this referent could
be gotten --- one simply could follow all in the schema documented references.

## Reference type

From our missing schema definition in data lakes I miss the most the declaration
of the reference type of a column.  It is more valuable as column level
lineage.

Having a reference type would offer many interesting possibilities:

- search for tables which could be used in analysis to enrich existing data
- more informative naming of columns in tables
- automatic validation of data (referential integrity on read)
- governance:  protect data from being leaked to where they should not
- increase speed of change by reducing the impact of not compatible changes
- establish a vocabulary which allows communication across domains

[^1]: The nice thing about the schema is that it provides an explicit representation
of our model of the domain.  This model can now be used as a reference in the
communication --- in case of doubt we can look it up and resolve uncertainty.

[morgan]: https://en.wikipedia.org/wiki/Lewis_H._Morgan
[lineage]: https://www.castordoc.com/blog/what-is-data-lineage

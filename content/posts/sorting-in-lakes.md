---
title: "Sorting in Lakes"
date: 2021-07-02T10:26:00+01:00
draft: false
toc: false
tags:
    - PostgreSQL
    - SQL
---

In case we sort rows using SQL we need to distinguish between duplicate values
of unique rows and duplicate values due to duplicate rows.

The nice thing about the [`row_number`][rownumber] SQL function is that it provides you with
a unique number (per partition) which is often used as a mean to de-duplicate a
set.  The `rank` function does not provide this property because duplicate
values share the same rank.

    SELECT a,
        dense_rank() OVER (ORDER BY a),
        rank() OVER (ORDER BY a),
        row_number() OVER (ORDER BY a)
    FROM (VALUES (1),(1),(2)) AS t(a);

     a | dense_rank | rank | row_number
    ---+------------+------+------------
     1 |          1 |    1 |          1
     1 |          1 |    1 |          2
     2 |          2 |    3 |          3


The problem occurs if you use it the wrong way.  Recently I spent a some time
debugging a weird behavior in a report.  The numbers changed during different
executions on an immutable data set --- which is not what you expect.

    SELECT a, b,
        row_number() OVER (ORDER BY a) AS rn
    FROM (VALUES
        (2, 'c'),
        (1, 'a'),
        (1, 'b')) AS t(a, b)
    ORDER BY rn;

     a | b | rn
    ---+---+----
     1 | a |  1
     1 | b |  2
     2 | c |  3

If you execute this query on PostgreSQL a couple of times it gives you most
likely always the same ordered set.  But this is not given and a unintended side
effect of providing the data using `VALUES`.  Logically ordering of duplicate
values is not defined and we can not rely on this result.  We *have to expect*
that sometimes 'a' and sometimes 'b' will get row number 1 assigned.  It should
be more probable to happen in distributed environments --- like Presto or Spark
(since PostgreSQL these days also supports parallel execution we should it
expect to happen as well).

If in such a situation the expression `rn=1` is used to filter and count the
values in column `b='a'` we will get a different result every time we execute
the query.  As a result it will look to the observer as if the query engine
works non-deterministic on stable input.

Maybe be it should help in such a case to ask whether or not we could safely
exchange `row_number` with `rank`.  If not, we should change the ordering
criteria.

Should we always prefer `rank` over `row_number`?  It depends I think.

It becomes more important when working on big data for two reasons.  A [data
lake][datalake] of plain files does not provide guarantees like a good old
database with well defined constraints could.  Furthermore data lakes are
solutions in environments where we rely on "at least once" message delivery.
This means for technical reason we have to expect duplicates.  In such a
situation we need to use `row_number`.

The notional exchange of both functions should help to find out whether or not
the duplicate value can happen only in case of a duplicate row.

[datalake]: https://en.wikipedia.org/wiki/Data_lake
[rownumber]: https://www.postgresql.org/docs/current/functions-window.html

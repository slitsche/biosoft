---
title: "PostgreSQL Background Writer Statistics"
date: 2014-10-07T10:30:00+01:00
draft: false
featuredImg: ""
tags:
  - Postgres
---
The [`pg_stat_bgwriter`
view](http://www.postgresql.org/docs/9.3/static/monitoring-stats.html)
provides some interesting information about the background writer. This
view provides only one row. If you want to analyze these data, these
results has to be stored somewhere with a timestamp. The following shall
show that it allows  an insight into the changes performed in shared
buffer cache and also hints for tuning several server parameters.

If a backend process (a client) requests data it is either found in a
block in shared buffer cache or the block has to be allocated (read from
disk). The latter is counted in `buffers_alloc` column. The usage count
of this block is increased. The backend process modifies data in this
requested page, so this page becomes dirty. With the commit the
transaction is written to WAL file. At some moment the background writer
will synchronize the dirty page with the disk and mark this page as
clean.

This latter asynchronous process can be triggered by the following three
events:

-   regular checkpoint
-   backend request
-   background clean process.

The regular checkpoint is triggered either when the number of available
`checkpoint_segments` are exhausted or when the `checkpoint_timeout` is
reached. The first are counted in `checkpoints_req` column, the latter
in `checkpoints_timed` column. How many blocks during checkpoint are
written is counted in `buffers_checkpoint` column.

It may happen that a dirty page is requested by a backend process. In
this case the page is synched to disk before the page is returned to the
client. The number of those pages are incremented in `buffers_backend`
column.

It may happen that a new page has to be allocated and for this an
allocated page has to be cleared. PostgreSQL may clear pages with a low
usage count in advance. The process scans for dirty pages with a low
usage count so that they could be cleared if necessay. Buffers written
by this process increment the `buffers_clean` column.

Writing dirty buffers on backend request may cause a delay of the
response to the client request. Using the clean writer process may
mitigate this effect. Writing least recently used pages (which have a
low usage count) is enabled if `bgwriter_lru_maxpages` has a value
bigger than 0. The number of pages to be written is calculated via the
number of recently allocated buffers (you can see it in `buffers_alloc`)
multiplied by `bgwriter_lru_multiplier` (which defaults to 2).

So a higher allocation rate may lead to a higher amount of buffers clean
operations. These cause a higher I/O between checkpoints caused by
background writer. On the other hand the higher allocation rate results
in a lower cache hit ratio. This may a have serious impact on client
applications e.g. it could cause canceling of querys with a very short
query timeout. The shared buffer cache should be increased.

On a healthy system there should more than 90% of all checkpoints
triggered by time. Based on a history of entries of `pg_stat_bgwriter`
view this can easily verified by comparing the calculated checkpoint
interval with current setting. Furthermore buffers written on checkpoint
should be higher than 80% of the this total number of blocks written.
The total number of blocks written is the sum of

-   buffer written on checkpoint
-   buffers written on clean
-   buffer written on backend request

So the ratio of cleaned buffers should be small while the ratio of
buffers written by a regular checkpoint should be higher.

The statistics view `pg_stat_bgwriter` provides us the current state of
statistics. We can reset the statistic:

``` {.sql}
select pg_stat_reset_shared('bgwriter‘);
```

If you want to make analysis on background writer statistics you either
have to reset the statistics or collect data into into a log table. From
these values important indicators of database state can be calculated
and can give hints which setting of the PostgreSQL cluster has to be
adjusted.

Interesting further reading:

-   <http://blog.2ndquadrant.com/measuring_postgresql_checkpoin/>
-   <http://www.westnet.com/~gsmith/content/postgresql/chkp-bgw-83.htm>
-   Gregory Smith (2010): PostgreSQL 9.0 High Performance. by Packt
    Publishing Ltd.


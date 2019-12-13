---
title: "NULL Werte in Order By Klausel"
date: 2011-07-21T16:21:00+00:00
draft: false
tags:
  - SQL
  - PostgreSQL
---

Man möchte in einer nach einer Spalte sortieren die [Null
Werte](http://de.wikipedia.org/wiki/Nullwert) enthält.  Aber man braucht ein
sicheres Verhalten dafür, ob die `NULL` Werte am Beginn oder am Ende eingefügt
werden.  Wie kann man das *standard konform* und *backend unabhängig* realisieren?

Am einfachsten wäre es, wenn es ein zugesichertes Verhalten gibt.  Leider gibt
es das nicht.  Der Standard gibt nur vor, dass alle Nullmarken gleich behandelt
werden.  Der ISO Standard SQL/92 sagt dazu (Zitat C.Date, H.Darwin (1998) [SQL - Der Standard](http://www.amazon.de/SQL-Standard-mit-den-Erweiterungen/dp/3827313457). Seite 278):

> Zum Zwecke der Ordnung werden alle Nullmarken entweder so betrachtet, als seien sei größer als alle Werte ungleich der Nullmarke oder aber, als seien sie kleiner als alle Werte ungleich der Nullmarke; welche von beiden Möglichkeiten allerdings zutrifft, ist durch die Implementierung definiert.

Manche DBMS wie Oracle [bieten eine Eweiterung](https://docs.oracle.com/cd/B19306_01/server.102/b14200/statements_10002.htm#i2168299) der `order by` Klausel: `order by expression desc nulls last` (im Standard seit SQL:2003). Das ist jedoch nicht auf allen Backends verfügbar. Bleibt also für eine Standard konforme Implementation, die auf unterschiedlichen Backends funktioniert, dass man die Nullmarken umwandelt.

    create table sli_test (  nutzung  varchar(10),  val     integer  );

    insert  into sli_test ( nutzung , val) values ('P', 1);
    insert  into sli_test ( nutzung , val) values ('G', 2);
    insert  into sli_test ( nutzung , val) values ( null, 2);
    commit;

    select nutzung, valfrom sli_test where (nutzung = 'P' or nutzung is null)
    order by case when nutzung is null then '1' else '0'+nutzung end;

    drop table sli_test;

Leider gibt es keine Standard Funktion zum Verketten von Strings. Ohne Verketten ist die Lösung auch nicht einfacher, da die Sortierung dann wieder vom Zeichensatz der Tabelle abhängt.

Unabhängig vom Datentyp der Spalte ist die folgende Variante (siehe auch [Stackoverflow](http://stackoverflow.com/questions/1456653/sql-server-equivalent-to-oracles-nulls-first)):

    ORDER BY (case WHEN ColAnyType IS NULL THEN 1 ELSE 0 END) asc, ColAnyType asc

Update: PostgreSQL unterstützt die Klauseln NULLS FIRST sowohl in Abfragen als
auch in *Indexdefinitionen*, wodurch sich explizite und teuere Sortieroperationen
vermeiden lassen (der Index liefert die Daten bereits in der sortierten
Reihenfolge, einschließlich der NULL Values).



---
title: "Umbennen von Postgres Typen"
date: 2012-11-08T16:49:57+00:00
draft: false
tags:
  - PostgreSQL
---

In PL/pgSQL, eine der Programmiersprachen für die serverseitige Programmierung
in [PostgreSQL](http://www.postgresql.org/), werden das Interface der Prozedur
und Body unterschiedlich behandelt.  Der Body wird beim ersten Aufruf in einer
Session kompiliert, für SQL werden Prepared Statements und ggfs. auch
Ausführungspläne erstellt und diese im Cache bis zum Ende der Session
gespeichert.  Innerhalb eines Bedingungsbaums werden so nur die Statements
vorbereitet, die auch benötigt werden ([siehe
Dokumentation](http://www.postgresql.org/docs/current/interactive/plpgsql-implementation.html)).

Typen können in PostgreSQL erstellt und als Parameter oder Variablen
referenziert werden.  Typen in Parameterdeklarationen werden beim Erstellen der
Funktion in die OID aufgelöst, Typen in Variablen Deklarationen zu Beginn der
Session, wenn der Body compiliert wird.

Wenn ein Typ mit `ALTER TYPE` geändert wird, dann bleibt seine OID gleich.
Wurde diese OID in einer Funktion als Interface definiert, so wird damit die
gespeicherte Interface Definition geändert.  Die im Cache befindlichen Funktionen
kennen diese Änderungen nicht, weil das vorbereitete Statement durch ein `ALTER
TYPE` nicht invalidiert wird.  Sind im Cache nun aber Aufrufe des Interfaces
enthalten, so verweisen diese auf den alten Typ.  Wird eine neue Session
erstellt, so wird der Body neu kompiliert und erst danach wird der neue -
geänderte - Typ referenziert.

Wenn man nun durch `ALTER TYPE` den *Namen* des Typs ändert, dann funktionieren
die aktuell im Cache enthaltenen vorbereiteten Statements weiterhin.  Im Quellcode
der Funktion sind jedoch noch den alten Namen des Typs enthalten.   Hier könnte
man auf die Idee verfallen, einen neuen Typen anzulegen, welcher den Namen des
alten Typs vor der Änderungen erhält.

Wenn man jedoch daneben einen neuen Typ anlegt, der den gleichen Namen hat wie
der geänderte Typ, so werden die neu kompilierten Prozeduren beim Aufruf (zur
Ausführungszeit) immer noch fehlschlagen, weil es keine Funktion mit der neuen
OID existiert!  Die Funktion wird gesucht mit dem passenden Typ im Namen.  Der
Typname wird aufgelöst nach der OID und die passende Funktion mit gesucht mit
der neuen OID gesucht.  Eine solche Funktion gibt es aber nicht, da das
Interface nicht neu compiliert wurde.

In diesem Fall, wenn Typen im Interface von Funktion geändert werden, müssen
diese Funktionen auch neu erstellt werden.  Das führt dazu, dass die bestehenden
vorbereiteten Statements im Cache invalide werden und die Funktionen bei einem
neuen Aufruf erneut kompiliert werden.

    create type mutableType as (myval int);
    --
    create or replace function useMutableType(mut mutableType)
    returns int stable language plpgsql as $body$
    begin
    return mut.myval;
    end;
    $body$

    create or replace function invokeMutableTypeFunction()
    returns int language plpgsql as $body$
    declare
    val mutableType;
    begin
    val.myval :` 1;
    return useMutableType(val);
    end;
    $body$

    local_db`# select * from invokeMutableTypeFunction() ;
    invokemutabletypefunction
    ---------------------------
    1
    (1 row)

In einer anderen Session kann man den Type ändern.

    alter type mutableType rename to mutatedType;

In der ersten Session kann das Statement weiterhin ausgeführt werden, führt man
das Select jedoch in der zweiten Session aus, führt das zu folgendem Fehler:

    local_db`# \c local_db
    You are now connected to database "local_db".
    local_db`# select * from invokeMutableTypeFunction() ;
    ERROR:  type "mutabletype" does not exist



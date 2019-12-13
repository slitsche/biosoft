---
title: "Was ETL auch ist"
date: 2008-10-10T20:57:00+00:00
draft: false
tags:
  - Messages
---
Meine bisherigen Recherchen zum Thema Datenmigration waren nicht besonders ergiebig - zumindest was Erfahrungen und Strategien zum Thema Datenmigration anbetrifft.  Allerdings bin ich dabei über das Thema ETL und dabei über [Scriptella](http://scriptella.javaforge.com/) gestoßen.  Heute wollte ich es doch mal ausprobieren.

Aufgabe war eine Liste der letzten geänderten Jobtickets mit einer kleinen
Auswertung als eine HTML-Seite aus einer Datenbank zu exportieren.  Die
vergleichbare Aufgabe hatte ich vor einigen Wochen mit Hilfe von Python und
gelöst.  Erfreulich einfach war das Verbinden zur Datenbank - einfach das jar
Archiv aus einem anderen Projekt kopieren und Spaß haben.  Im Vergleich dazu
musste ich bei Python erst einen ODBC Treiber für Ms-SQL installieren, der dann auch nicht mal sehr zuverlässig war.

Das Referenzieren der Felder über die Spaltennamen war aus dem Beispielen einfach zu übertragen.  Am Aufwendigsten war noch das hübschen und das Generieren des HTMLs, so dass das gewünschte Design entsteht.  Das ist eine Stelle, die mir nicht so recht gefiel.  Velocity als Templateengine zerreisst die Tags sehr, so dass Öffnendes und Schließendes Tag in unterschiedlichen Dateien liegen.  Innerhalb der ETL Datei wird der Code dadurch schnell etwas übersichtlich.

Trotzdem konnte das Ziel schnell erreicht werden.  Ausführung ist auch schnell.  Insgesamt sehr zufriedenstellend und eine etwas andere Anwendung als das weithin bekannte ETL.

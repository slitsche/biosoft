---
title: "OLAP OpenI"
date: 2010-06-08T18:23:57+00:00
draft: false
tags:
  - Datenbank
  - OLAP
---

Der Teufel steckt doch im Detail.  Beim Vergleich von Infor Alea mit Jasperserver sind beim Punkt OLAP und Navigation in den Daten doch deutliche Unterschiede aufgetreten.

Der erste Unterschied war die Performance, der zweite die Navigation in den Daten (hier insbesondere die Benutzerfreundlichkeit) und als drittes die Unterstützung mehrfacher Hierarchien.  Multiple Hierarchien kann ich im Jasperserver zwar auch definieren.   Allerdings kann der Anwender diese <strong>nicht </strong>über die Navigation des  Cubes auswählen.  Das hat mich verwundert und dazu veranlasst, den Blick schweifen zu lassen.  Denn das war in Alea eine Standardfunktion ich erwartete das auch von Mondrian.

Dabei bin ich auf <a title="Homepage openI" href="http://openi.org/">OpenI</a> gestoßen.  Die Demoseite war schnell und intuitiv und hat mich eher an die Alea Funktionen erinnert als Jasper.  Der Test war schnell gemacht.  Und ja, mit Mondrian in OpenI kann man auch in multiplen Hierarchien navigieren.  Dieses Manko betrifft offensichtlich jPivot.

Die Oberfläche für die Navigation in den Daten hat mir sehr gut gefallen, auch weil die Navigation immer in der Nähe war (Links angedockt, auch versteckbar).  Auch toll waren die automatisch erzeugten Views: ein Übersicht über alle Dimensionen hinsichtlich einer ausgewählten Kennzahl.  Und per Klick kommt man dann gleich in die Pivotansicht.  So stellt das sich wohl ein Anwender vor.

Auch von der Entwicklungsseite ist das nicht schlecht.  Der Entwickler muß keine MDX Abfragen manuell schreiben.  Er Deployed einfach nur das Schema, konfiguriert es im Mondrian (hinzufügen eines Katalogs).  Das war's.  Alle weiteren Funktionen gehen über die Oberfläche.

Allerdings war die Administration nicht ganz so ausgereift.  Die Felder waren nur per Maus zu bedienen und wenn ein Fehler auftrat (Validierung), mußte man die Seite verlassen und von vorn beginnen.

Im Gegensatz zum Benutzerkonzept sind das aber Kinderkrankheiten.

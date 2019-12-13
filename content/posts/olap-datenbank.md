---
title: "OLAP Datenbanken"
date: 2010-06-11T11:48:57+00:00
draft: false
tags:
  - Datenbank
  - OLAP
---

Das ist offensichtlich auch ein recht bunt schimmernder Begriff, der in vielerlei Hinsicht benutzt wird.

Bei Cubeware habe ich eine kleine Übersicht gefunden.

[Infor Alea] (http://www.infor.de") (ehemals: MIS DecisionWare) oder auch [Palo](http://www.palo.net/de/) sind Datenspeicher für Excel.  Palo selbst ist auch als Open Source verfügbar (allerdings muss man sich für einen Download vorher registrieren :-( ).

Insbesondere für die Power Anwender ist die Excel Integration ein wichtiges Merkmal.  Diese müssen in der Lage sein, kurzfristig auf Anforderung neue Abfragen zu erstellen.  Über die Navigation in den Dimensionen ist das aus Excels Pivot Funktion leicht möglich.  Allerdings (bei MIS) hat das den Nachteil, dass die Berichte (als xls)  - da sie direkt auf die OLAP DB zugreifen - nicht ohne OLAP Client weitergegeben werden können.

Die zu verwaltenden Datenmengen sind m.E.  begrenzt.  Von Palo wird ein Einbruch ab 5000 Elementen je Dimension genannt.

Pentaho oder Jasperserver sind dagegen Webportale, die auf verschiedene Datenspeicher zugreifen können, selbst aber keine Funktion als Datenspeicher bieten.  Über die Oberfläche wird eine Pivot Funktion geboten.

Hier ist aktuell die Performance nicht so schnell wie aus Excel mit den spezialisierten Speichern.  In der einschlägigen Dokumentation wird darauf verwiesen, dass bei großen Datenmengen Aggregat Tabellen erstellt werden sollen, die dann dem Schema zugefügt werden.  Diese werden bei bestimmten Anfragen dann automatisch ausgewählt, damit die Abfragen schneller gehen und weniger I/O erzeugen.

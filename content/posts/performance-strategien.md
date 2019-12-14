---
title: "Performance Strategien"
date: 2011-06-02T12:20:00+00:00
draft: false
tags:
    - SQL
---

Gerade arbeite ich in einem Projekt, bei dem es um die Konvertierung von ca. 20
Mio Datensätzen geht.  Vorgegebene Technik ist PL/SQL.  Die allgemein bekannten grundlegenden Maßnahmen zur Optimierung - wie optimale Zugriffspfade, Indizierung, Vermindern der Resultsets, etc. - werden genutzt.
Was kann man darüber hinaus noch tun?

* Vermeiden von I/O
* Parallelisierung

Zugriffe im Hauptspeicher sind bekanntermaßen schneller aus I/O Operationen.  Darum können Nachschlage Listen, die im Hauptspeicher bspw. als Arrays oder Hashlisten umgesetzt sind, deutliche Zeit ersparen.

Oft werden Daten in einer Prozedur ermittelt und gespeichert.  Tage später kommt
eine Erweiterung der Anforderungen herein, eine neue Prozedur wird
implementiert, die vorher gespeicherten Daten werden von der Datenbank gelesen,
transformiert und neu gespeichert.  Kann man machen, muß man aber nicht.

In meinem Fall war es ein Update auf eine Tabellenzeile, die kurz vorher
gespeichert wurde.  Durch Umstellen auf ein `Varray` und verschieben des
Speicherns konnte die Durchlaufzeit von 44 auf 32 Sekunden für (im Test)
ca. 2000 Datensätze verkürzt werden.  Schöner Nebeneffekt - vermiedene
Statements müssen auch nicht mehr optimiert werden.

Parallelisierung ist dann angebracht, wenn eine nicht unerhebliche Anzahl von
Operationen des Programms keine I/O Operationen sind.  Das trifft auch auf
PL/SQL Programme zu.  Und Server haben in der Regel mehrere Prozessoren, warum diese also nicht auch nutzen?

Um die Konsistenz der Daten zu gewährleisten, muß ein DBMS schreibende Zugriffe
synchronisieren.  Darum ist der I/O der limitierende Faktor.  Erste Tests haben
gezeigt, dass sich durch eine Parallelisierung der Verarbeitung von PL/SQL
Programmen die Laufzeit verbessert.  Die Laufzeit wurde solange deutlich kürzer,
solange die Anzahl paralleler Prozesse nicht größer war als die Anzahl der
Prozessoren des Datenbank Servers.  Das deckt sich mit den Erwartungen, will ich
aber noch weiter beobachten.

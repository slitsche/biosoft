---
title: "Kanban und Storm"
date: 2011-02-22T23:12:00+00:00
draft: false
tags:
  - Programming
---

Heute war ein Hadoop Get Together der [Scalable Information
Retrieval](https://www.xing.com/net/priad73cfx/informationretrieval) Group von
Xing.  Es gab interessante Vorträge, die sich jedoch nicht primär mit Hadoop auseinander setzten.

Der erste Vortrag von Markus Andrezak handelte über ein Prozessmodell in der
Softwareentwicklung.  Wie kann man [Kanban](http://de.wikipedia.org/wiki/Kanban)
in der Softwareentwicklung anwenden? Ausgangspunkt seiner Argumentation war das
Ziel, dass die Firma möglich schnell Werte realisieren möchte und vom Markt auch
schnell ein Feedback benötigt, die bestätigt, dass die Entwicklungen angenommen
werden oder nicht.  Dazu muss einerseits ein Modell bestehen, dass durch
Datenanalyse verifiziert werden kann.  Um ein schnelles Feedback zu bekommen, müssen Entwicklungen schneller deployed werden - das heisst tägliche Releases.

Interessant für mich waren verschiedene Aussagen.  Das Problem, so meint er, sei
das Projektmanagement, welches aus dem Management greifbarer Güter nicht auf
Kreativprojekte - bei denen es viel auch um Lernen geht, nicht übertragen lasse.
So konnte er durch das Reduzieren der gleichzeitig bearbeiteten Features die
Durchlaufzeit erhöhen.  Das führte dazu, dass auch die Varianz der Dauer der
Implementation von Features deutlich reduziert werden konnte.  Die Kosten für
Transaktionen (Auslieferungen) sind deutlich geringer, das Risiko ist geringer.
Auslieferung von Bugfixes ist kein Sonderfall, kleine Änderungen ausliefern ist
der Standardfall.

Der zweite Vortrag von Martin Scholl beschäftigte sich mit dem [Framework
Storm](https://github.com/nathanmarz/storm).  Leider ist die Einleitung (mit
einer netten musikalischen Analogie) recht lang geworden.  Darum hat dem
Vortragenden die Zeit für verschiedene technische Details und Beispiele nicht
mehr gereicht.  Storm ist eine Plattform für Echtzeit Analyse von Daten.  Das
System verarbeitet permanent einen Strom von Ereignissen und kann auf diese
reagieren.  Die Knoten können auf verschiedene Rechner verteilt werden.  Das
System stellt sicher, dass jedes Event mindestens einmal verarbeitet wird.
Versprochen wurde außerdem, dass sich das System viel leichter aufsetzen lassen
soll als [Hadoop](http://hadoop.apache.org/).  Muß man mal ausprobieren.

---
title: "Wörter zählen"
date: 2013-03-06T22:08:57+00:00
draft: false
tags:
  - Network
---

Am Donnerstag war <a href="https://soundcloud.com/">Soundcloud</a> wieder einmal so freundlich, seine Räume für das Treffen des FunClubs zur Verfügung zu stellen. Zu diesem Treffen sollten <a title="Task in Advance" href="http://www.meetup.com/thefunclub/events/104441382/">die Teilnehmer eine Aufgabe</a> lösen: Wörter in einem Text zählen und die 10 häufigsten Wörter anzeigen.

Die Präsentationen waren sehr interessant. Es waren Lösungen in
<ul>
	<li>Bash/Awk</li>
	<li>Erlang</li>
	<li>Haskell</li>
	<li>Scala</li>
	<li>Lua</li>
	<li>Clojure</li>
	<li>Common Lisp</li>
	<li>R</li>
	<li>C</li>
</ul>
zu sehen. Sehr interessant war, dass es doch trotz des sehr einfachen Problems sehr viele unterschiedliche Wege zu Lösung gibt.

Auch die Vergleich der Performance waren sehr interessant. In dieser Hinsicht war der Beitrag in C das Highlight des Abends (und zurecht auch am Schluss). Während bei den Hochsprachen Lua bei der Verarbeitung des 500MB Korpus mit ca. 20 Sekunden die Führung einnahm, so wurde diese Zeit durch die Implementation in C um Größen (2,8 Sekunden) geschlagen. Besonders interessant dabei war, wie viele Annahmen über das Problembereich gemacht wurden und welche Vereinfachungen der Implementation sich daraus ergeben - z.B. wenn man von einem belletristischen Text in englischer Sprache ausgeht kann man einen besonders einfachen und schnellen Algorithmus zur Berechnung des Hashwertes nehmen, da vermutlich kaum mehr als 100.000 Wörter vorkommen werden. Dafür war es in Zeilen gerechnet auch das längste Programm.

Hinsichtlich der optischen Reize war die Präsentation mit Keynote die Ansprechendste.

Leider ist wegen der großen Beteiligung und der vielen Beiträge die Diskussion des Problems etwas zu kurz gekommen. Es war aber trotzdem ein anregender Abend.

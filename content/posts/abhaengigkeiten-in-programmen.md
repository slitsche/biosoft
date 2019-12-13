---
title: "Abhängigkeiten in Programmen"
date: 2012-05-31T12:01:00+00:00
draft: false
tags:
  - Programming
---

Einige wenige Tage Beschäftigung mit
[Clojure](https://clojure.org/) bringt die gewohnten Bahnen des Denkes ganz
schön durcheinander.  Einerseits bin ich noch immer wieder erstaunt, wie kurz
funktionale Programme werden.  Zum anderen stelle ich fest, dass ich beim Review
von Code in imperativen Sprachen die Ausdruckskraft funktionaler Sprachen
vermisse.

Gegeben sei Prozess, welcher einen langen Liste von Werten aufbaut. Da die [Regeln umfangreich sind](http://en.wikipedia.org/wiki/Essential_complexity), wird die Verarbeitung aufgeteilt in verschiedene Methoden/Prozeduren, damit die Prozeduren übersichtlich bleiben.

    process1( liste )
    process2( liste )

`liste` ist ein Objekt, was von beiden Prozeduren verändert wird.  Es ist aber
nicht ersichtlich, ob prozess2 vom Ergebnis von prozess1 abhängig ist.  Es kann
sein, dass in prozess2 gelesen werden, die in prozess1 gesetzt wurden.  Es kann aber auch nicht sein. Dann würde

    process2( liste)
    process1( liste)

zum gleichen Ergebnis führen.  Das macht es einem Entwickler schwer, diesen
Ablauf zu ändern oder zu refaktorieren.  Der Entwickler, muß manuell die ganzen
Abhängigkeiten auflösen, ob process2 von einer Zustandsänderung in process1
abhängt.  Besser wäre es, wenn der Quellcode die Abhängigkeit explizit
ausdrückt.  Das ist eigentlich das prinzipielle Dilemma von imperativen
Sprachen.  Besser wäre die Form

    B := process1 ( A )
    C := process2 ( B )

Hier wird die Liste `A` nicht (in-place) verändert, sondern ist unveränderlich.  Damit ist ersichtlich, dass process2 vom Ergebnis von process1 abhängt.  Besteht keine Abhängigkeit, dann sollte auch dies erkennbar sein.

    A := process1 ( X )
    B := process2 ( Y )
    C := combine( A, B )

Damit ist auch ersichtlich, dass die Ausführungsreihenfolge von process1 und
process2 nicht von Bedeutung ist.  Wäre es sicher, dass sie keine Nebenwirkungen
haben - wie in rein funktionalen Sprachen - könnten diese Prozesse auch parallel
ausgeführt werden.  Leider ist nie alles Gute beisammen.  Wenn eine Funktion
immer das gleiche Ergebnis liefert, wenn man sie mit den gleichen Parametern
aufruft, ist das zum Testen ganz schön, aber nicht alle Probleme sind so
einfach.  Ich bin gespannt, wie man in funktionalen Sprachen zustandsbehaftete Probleme löst.




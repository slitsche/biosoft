---
title: "Parallele Verarbeitung"
date: 2011-10-11T13:27:00+00:00
draft: false
tags:
  - Programming
---

Um die Multi-Core-Prozessoren richtig zu nutzen, bietet sich parallele Verarbeitung an. Hauptanforderung an das zu lösende Problem ist, dass sich dieses in separate Einheiten aufteilen läßt, welche sich unabhängig voneinander verarbeiten lassen.

Die [Fibonacci Folge](http://de.wikipedia.org/wiki/Fibonacci-Folge) ist das
extreme Gegenbeispiel, jede Zahl der Folge berechnet sich aus den Vorgängern,
diese Berechnung läßt sich nicht parallelisieren. Daneben gibt es Grauzonen. Ich
habe eine Menge von Objekten, die sich identifizieren lassen und in der ersten
Annäherung könnte man sich entsprechend dem [PCP
Muster](http://de.wikipedia.org/wiki/Erzeuger-Verbraucher-Problem) einen
Producer und mehrere Consumer vorstellen.  Der Producer ermittelt die zu
verarbeitenden Objekte und stellt sie in eine Queue.  Diese Queue wird nun durch
verschiedene Consumer abgearbeitet.  Soweit so einfach.

Wenn nun aber die Verarbeitung der Consumer die Objektmenge verändert? Mehr als
ein konkurrierender Consumer kann ja die gleichen Objekte ermitteln, die der zu
verarbeitenden Objektmenge zuzufügen sind.  Die Menge der Objekte ist relativ
groß und ist nicht disjunkt von der Ursprungsmenge.  In diesem Fall muss die
Verarbeitung so gestaltet werden, dass die Ursprungsmenge abgearbeitet wird.
Alle (parallelen) Consumer müssen fertig sein, bevor die Menge der neuen Objekte
verarbeitet. 

Da die Mengen nicht disjunkt sind, ist die Herausforderung, die ursprünglich verarbeitete Menge von der neuen Menge abzuziehen, um die Menge der noch zu bearbeitenden Objekte zu erhalten.

Wir haben eine Datenbanktabelle und die Consumer schreiben die Identifikatoren
der neuen Objekte in eine Tabelle.  Der Consumer arbeitet diese dann nachträglich ebenfalls ab. Dann ergibt sich die Notwendigkeit, die Menge der neuen Objekte mit der Menge der schon verarbeiteten Objekte zu vergleichen und die Differenz zu ermitteln.

Nachteil: Das Speichern erfordert relativ langsame I/O Operationen.  Um die
relativ langsamen I/O Operationen zu vermeiden, kann das Sammeln der neuen
Objekte in den Hauptspeicher verlegt werden. Bei einer relativ großen Menge an
Objekten aber kann der [Bedarf an
Hauptspeicher](http://www.javaspecialists.eu/archive/Issue193.html) bei diesem
Vorgehen recht hoch sein.  Hier heisst es also abwägen.



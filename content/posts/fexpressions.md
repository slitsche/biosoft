---
title: "Funclub about fexpressions"
date: 2012-08-12T10:38:57+00:00
draft: false
tags:
  - Programming
  - Lisp
---

Gestern war ich auf einem [Meetup des
Funclub](http://www.meetup.com/thefunclub/events/75999942/?a=ea1_grp&rv=ea1&_af_eid=75999942&_af=event).
[Tim Felgentreff](http://www.meetup.com/thefunclub/members/50113032/) sprach
über [Fexprs](http://en.wikipedia.org/wiki/Fexpr) und erläuterte das Konzept und
auch die Nachteile.  Interessant war, was mit einem solch einfachen Konzept
möglich wird.  Bei Fexprs werden die Operanden nicht evaluiert, bevor sie an die
Funktion übergeben werden.  Die Funktion erhält darüber hinaus die Umgebung des
Aufrufers und kann darüber entscheiden, ob die Operanden evaluiert werden.

Interessant war die Demonstration, mit wie wenig Kernfunktionen eine
Implementation auskommt, die Fexprs evaluiert.  Dies ist die Stärke des
Konzepts.  Leider - und das ist der Nachteil - ist die Ausführung unglaublich
langsam.  Die statische Analyse kann nicht feststellen, ob ein Operator eine
normale Funktion oder eine Fexprs darstellt.

Tim verschärfte das Problem in der Diskussion.  Dadurch, dass die Umgebung (die
Menge der Symbole und der gebundenen Werte) der Fexpr zugänglich ist, kann diese
auch geändert werden kann.  Alle späteren Implementationen von Lisp (nach 1980)
haben meist auf die Fexprs zugunsten der Macros verzichtet.

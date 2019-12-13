---
title: "Properties in OLAP Cubes"
date: 2011-03-11T12:18:00+00:00
draft: false
tags:
  - Datenbank
  - OLAP
---
Levels in Dimensionen können auch Properties haben. Die Deklaration im Schema ist recht einfach: Name der Property und die Spalte der Datenbanktabelle.

Die Werte muß man sich dann jedoch durch einen [Cast]( http://mondrian.pentaho.com/documentation/mdx.php) in den gewünschten Typ umwandeln, die Werte sind nicht selbstverständlich ein String oder eine Zahl. In meinem Fall ist die Property nur für ein Blatt im Baum der Hierarchie definiert, darum muß ich natürlich die Ebene in der Hierarchie ermitteln, bevor ich auf die Property zugreife. Mondrian kennt zwar nicht die Funktion `isLeaf`, es gibt aber eine gute Alternative:

```
IIf([AUSGABE].CurrentMember.Children.Count > 0, 0.0,
CAST([AUSGABE].CurrentMember.Properties("MyProperty") AS NUMERIC))
```

Damit lassen sich hübsch Werte berechnen, die z.B. von bestimmten Dimensionen abhängig sind.

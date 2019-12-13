---
title: "Jasperserver Import"
date: 2010-03-12T17:27:57+00:00
draft: true
tags:
  - SEO
---

Die Fehlersuche um Jasper ist wegen kryptischer Fehlermeldungen manchmal mühselig.  Wie sind bestimmte Meldungen zu interpretieren?

    Folder details not found in import input for folder /System/Resources

Bedeutet: Hier bricht der Import ab.  Weitere Objekte, die zu importieren wären,
werden nicht importiert.  Die `.folder.xml` Datei stimmt nicht mit dem Datei System überein.

Beim Import mit der option `--update` scheint es so, dass die Datasources vorhanden sein müssen.

Die Objekte ohne Datasources können also aktualisiert werden.  Mondrian client connections können also nicht ohne Datasource Datei durch Import aktualisiert werden.

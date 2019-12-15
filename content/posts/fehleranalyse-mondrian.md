---
title: "Adressen im ERP"
date: 2010-01-27T15:14:00+01:00
draft: false
tags:
    - Modelling
---

Das Thema Adressen versus Personen ist immer wieder spannend. Und Quelle von Verwirrungen.

![Person und Adresse](/img/PersonAdresse.png)

ERP Systeme verwalten in der Regel Adressen als komplexe Attribute von Aufträgen. Für das Abwickeln von Aufträgen ist das ausreichend. Diese werden jedoch zunehmend mit CRM Funktionen angereichert. Vom Standpunkt des Marketings ist die Adresse nicht allein eine Adresse, sondern sie identifiziert eine Person. Über die möchte das Marketing jedoch möglichst viel wissen. Aus diesem Ansatz entsteht der Wunsch, Dubletten zu vermeiden. Aber in der Wirklichkeit hat ein Mensch nicht nur eine Adresse. Darum braucht es ein Konstrukt in der Software, dass Adressen zusammenfasst, die Person.

SAP kennt das Konzept der Person, diese heisst Geschäftspartner. Ein Geschäftsspartner kann in unterschiedlichen Rollen auftreten. Und eine Person kann mehrere Adressen besitzen. Soweit so gut. Allerdings ist es scheinbar für Anwender ein Problem, mit unterschiedlichen Adressen je Geschäftspartner umzugehen.

Ich bin mir nicht ganz sicher, ob die Anforderungen für das Konzept Person im einem Datawarehouse nicht besser aufgehoben wäre.

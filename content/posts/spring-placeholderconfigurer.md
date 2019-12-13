---
title: "Spring: PropertyPlaceholderConfigurer"
date: 2011-09-08T14:33:00+00:00
draft: false
featuredImg: ""
tags:
  - Spring
  - Java
---

Problem: in der `context.xml` Konfigurationsdatei für den Spring
Applicationcontext hatte ich einen [PropertyPlaceholderConfigurer](
http://static.springsource.org/spring/docs/2.5.5/api/org/springframework/beans/factory/config/PropertyPlaceholderConfigurer.html#setIgnoreUnresolvablePlaceholders%28boolean%29)
konfiguriert.  Nur wurden keine Platzhalter ersetzt.

Erklärung: ich hatte in meiner Anwendung versehentlich eine BeanFactory
erstellt, um mir die Bean geben zu lassen.  Eine Beanfactory hat aber
[wesentlich weniger
Funktionen](http://static.springsource.org/spring/docs/3.0.x/spring-framework-reference/html/beans.html#context-introduction-ctx-vs-beanfactory)
als ein ApplicationContext. Wesentlich für das oben genannte Probelm ist der
Hinweis, dass die BeanFactory keinen `BeanFactoryPostProcessor`
registriert. Jedoch ein `PropertyPlaceholderConfigurer` ist jedoch ein
`BeanFactoryPostProcessor`.  Und diese werden nur ausgeführt, wenn die Anwendung
einen `ApplicationContext` ausführt.

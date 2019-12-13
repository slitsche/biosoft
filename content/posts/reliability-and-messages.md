---
title: "Reliablity of Messages"
date: 2014-12-19T13:57:00+00:00
draft: true
tags:
  - Messages
---

Recently I had the time to evaluate Akka. Since it relies on communication via messages and the transport layer does not guarante any Delivery I was interested how reliability can be achieved.

<a title="Infoq - No Reliable Messaging" href="http://www.infoq.com/articles/no-reliable-messaging">This article</a> discusses that from business perspective guarante that a message was delivered is not necessary - it is only important that the outcome is the expected. If I order one book, I expect one - not none nor two. This means it is up to the application ensure reliablitity.

Akka defaults to at least once delivery.

---
title: "Duplicate Port Allocation"
date: 2017-04-19T15:05:57+00:00
draft: false
tags:
  - Network
---

Weird observation:
From Clojure Repl I run a webserver application. From a browser I was able to connect to this app. An application in another JVM running some acceptance test failed to connect:

    #error {
    :cause "connection was closed”

This is strange since from same terminal

    $ nc -z localhost 8080
    Connection to localhost port 8080 [tcp/http-alt] succeeded!

Than I remembered that I configured port forwarding for Virtualbox for this port as well.
Could it be that there are two bindings for the same port to different applications?

    sudo lsof -i -n -P | grep TCP | grep 8080
    VBoxHeadl 10270       sli   20u  IPv4 0xc0e59eafb581c8ef      0t0  TCP *:8080 (LISTEN)
    java      86447       sli  303u  IPv6 0xc0e59eaf98f62d9f      0t0  TCP *:8080 (LISTEN)

There is one binding for IPv4 and one binding for IPv6. Now it was easy to find the solution to make the acceptance test pass:

    -Djava.net.preferIPv6Addresses=true

The other option is to specify the loopback interface for IPv6 explicitly:

    http://[::1]:8080

Context:
On MacOS Sierra I run Docker in a VirtualBox. I use port forwarding of the VirtualBox to make docker applications accessible via localhost.

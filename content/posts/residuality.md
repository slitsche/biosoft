+++
title = "Residuality Theory"
date = 2025-12-17T10:20:00+01:00
draft = false
comments = false
slug = ""
tags = ["programming"]
categories = []

showpagemeta = true
showcomments = true
+++

A couple of days ago I've attended a 3 days workshop about Residuality theory
with Barry O'Reilly.  It was a great pleasure to learn some new ideas about
software development.  The following are my main take aways which I would like
to share.

Proponents of TDD claim, applying the method would lead to successful software
projects.  Let's assume 10% of the successful projects applied TDD.  Why then
successful project exist which did not utilize TDD?  Please replace TDD with
your favourite methodology.

We build software in the business enterprise context.  The software works
because we dilligently applied logic.  The logic based machinery is quite
brittle, it can only do what it was built for.  But the business context
apparently changes in a non-predictable way.  How do such brittle systems
survive in an unpredictable environment?  Successful software survives off-spec.

Residuality theory uses insights from complexity science.  It proposes to start
with a functional design and put it under stress.  We should find many different
stressors and do not judge them with our bias.  The last point is the very
important.  Any stressor is equally valuable, even the giant fire spitting
lizard.

Yes, this introduces a lot of fun into the design work.

Those stressors are used to find weak points in the initial design.  Every
stressor will lead to a different weak point.  But after 20 or 30 different
stressors we observe, that a mitigation of one or more earlier stressors would
help with the current one.  The more stressors we test, the more often we will
see this pattern repeating.

With every new stressor we walk around the problem and challenge our mental
model.  Methods like TDD could help as well to walk around the problem.
Residuality theory makes this process explicit.  Furthermore it can help to
decide when we should stop with the design.  It allows to compare designs in
respect to how many stressors one would handle better than the other.

In 1968 Pablo Picasso stated that, “Computers are useless. They can only
give you answers”.  Lizards can help to find new questions.

[Youtube: Introduction into Residuality Theory]( https://www.youtube.com/watch?v=0qKahTgetQ4 )

[Interview with Barry O'Reilly]( https://www.youtube.com/watch?v=8GEy0C6EGvw )

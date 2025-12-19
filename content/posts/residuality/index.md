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

![dragon](carlos-cram-ttJt5X9Hmu8-unsplash-small.jpg "Title")

*Image by [Carlos Cram](https://unsplash.com/@cramtek?utm_source=unsplash&utm_medium=referral&utm_content=creditCopyText)*

A couple of days ago I attended a three-days workshop about Residuality theory
with Barry O'Reilly.  For a long time I haven't been exposed to completely new
ideas about software development as in this workshop.  I enjoyed it very much.
The amount of topics and ideas covered is too much for this blog post.
However I try to summarize one thought I find especially relevant.

---

Proponents of  [TDD](https://en.wikipedia.org/wiki/Test-driven_development "Wiki:
-Test Driven Development") claim, applying the method would lead to successful
software projects.  However, even if we assume 10% of successful projects apply
TDD, how do we explain the success of the remaining 90% that do not?
Please replace TDD with your favorite methodology, the question remains.

In an enterprise context, we build software using logic. The logic based
machinery is quite brittle, it can only do what it was built for.  Yet, the
business context changes unpredictably.  How do such successful brittle systems
survive in an unpredictable environment?

Residuality theory uses insights from complexity science applied to biological
evolution.  Stuart Kauffman could [predict the number of cell
-types](https://ui.adsabs.harvard.edu/abs/1969JThBi..22..437K/abstract "Abstract
-of article") in a species based on the number of genes and their dependencies.
Barry applies [this model](https://en.wikipedia.org/wiki/Boolean_network
-"Wikipedia") to software.  The number of the components and their
connections would influence the ability to react to unforeseen changes in the
business context.

The process begins with a functional design that is then put under stress.  We
should find many different stressors without judging their likelihood.  The last
point is crucial.  Any stressor is equally valuable, even the giant fire
spitting dragon.

Yes, this introduces a lot of fun into the design work.

These stressors reveal weak points in the initial design.  After iterating over
20 different stressors patterns emerge. We observe that a mitigation of one or
more earlier stressors would help with the current one.  The more stressors we
test, the more often we will see this pattern repeating.

With every new stressor we walk around the problem and challenge our mental
model.  Methods like TDD could help with it as well.  But often we tend to be
biased which results in certain stressors not being considered.  Residuality
theory makes this process of walking explicit by emphasizing that no stressor
should be rejected.  As a bonus this approach helps to understand the business
better.

Furthermore it allows to decide when we should stop iterating over our
design.  Using the stressors we are able to compare designs in respect to how
many of them the one would handle better than the other.  We can actually train
our design.

In 1968 Pablo Picasso stated that, “Computers are useless. They can only
give you answers”.  Dragons can help to find new questions.

---
layout: post
title: "Picking a new language to learn"
date: 2015-04-14 23:08:55 +0100
comments: true
categories: learning, languages, criteria, scala, clojure, go, elixir
---
Most years I try to wrap my head around a new language and typically the choice has been straight forward. For some reason this year I have wrangled with it. Maybe it's because there's such a proliferation of interesting languages out there. Maybe it's because I am torn between picking between OO and a Functional paradigm. 

At the top of the list are [Scala](http://www.scala-lang.org/), [Go](https://golang.org/), [Clojure](http://clojure.org/) and [Elixir](http://elixir-lang.org/). All but one are in the functional realm of programming languages. However Go seems to have a huge traction right now. On the other hand there is something about Elixir that really appeals to me, maybe it's because it's described as being close to Ruby and be focused on developer happiness...

A few things that are important to me when making the choice are: the testing story, build tools, CI support and the backing of a web framework.

Scala has this covered with SBT, Circle CI/SnapCI and the play framework. What about testing?

The CI story for Elixir is a little murky, there are [custom scripts out there](https://gist.github.com/joakimk/48ed80f1a7adb5f5ea27) to run builds on Circle CI. As a web framework there is the [Phoenix Framework](http://www.phoenixframework.org/). The testing story [doesn't look fabulous](http://elixir-lang.readthedocs.org/en/latest/exunit/)

As for Clojure, well there are quite a few options for the web framework side of things (http://www.luminusweb.net/), CI => Snap CI, build tools => http://leiningen.org/, testing => http://speclj.com/ && https://github.com/marick/Midje && others. It's mature, but hmm it's Java

What about Go?

What about dependency management?

So there are quite a few things to take into consideration... And then there's the question does the language jell with me. To help me with that I have found an awesome resource that allows me to explore the languages: [Exercism](http://exercism.io/), the brain child of Katrina Owen

Writing all this down seems like a lot of consideration for something that I used to do on a whim.
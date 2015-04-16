---
layout: post
title: "Picking a new language to learn"
date: 2015-04-14 23:08:55 +0100
comments: true
categories: learning, languages, criteria, scala, clojure, go, elixir
---
I started writing this post with the intent to layout what was important to me in choosing what language to pick up this year and go through the options. In doing this post and thinking about what I wanted out of language and it's community and doing the research, there was only one real winner by the end. It does help to put things into writing... The TL;DR is this year I will be looking at: [Clojure](http://clojure.org/)? Why it ticks all of the boxes I set out in this post.

---

Most years I try to wrap my head around a new language and typically the choice has been straight forward. For some reason this year I have wrangled with it. Maybe it's because there's such a proliferation of interesting languages out there. Maybe it's because I am torn between picking between OO and a Functional paradigm. 

At the top of the list are [Scala](http://www.scala-lang.org/), [Go](https://golang.org/), [Clojure](http://clojure.org/) and [Elixir](http://elixir-lang.org/). All but one are in the functional realm of programming languages. However Go seems to have a huge traction right now. On the other hand there is something about Elixir that really appeals to me, maybe it's because it's described as being close to Ruby and be focused on developer happiness...

### What matters to me 
A few things that are important to me when making the choice are: the testing story, build tools, CI support, dependency management and the backing of a web framework.

### Scala
Scala ships with [SBT](http://www.scala-sbt.org/) as the build tool. Both [Circle CI](http://www.circlci.com) and [SnapCI](https://www.snap-ci.com/) support Scala. You have a few choices on the web framework side of this with the [Play framework](https://www.playframework.com/), [Scalatra](http://scalatra.org/) and [Lift](http://liftweb.net/). What about testing? The first two things I came across were [ScalaTest](http://www.scalatest.org/) and [Specs2](http://etorreborre.github.io/specs2/). Being built on the JVM, you can also leverage Maven/Gradle for build automation and dependency management.

### Elixir
The CI story for Elixir is a little murky, there are [custom scripts out there](https://gist.github.com/joakimk/48ed80f1a7adb5f5ea27) to run builds on [Circle CI](http://www.circlci.com). As a web framework there is the [Phoenix Framework](http://www.phoenixframework.org/). The testing story [doesn't look fabulous](http://elixir-lang.readthedocs.org/en/latest/exunit/) yet. Elixir comes with `Mix` for dealing with dependencies. It's still early days, but being on the front line could be a good thing and well there's the whole developer happiness thing that just can't be discounted.

### Clojure
As for [Clojure](http://clojure.org/), well there are quite a few options for the web framework side of things with [Caribou](http://let-caribou.in/), [luminusweb](http://www.luminusweb.net/) and [Pedestal](https://github.com/pedestal/pedestal). ThoughtWorks CI service, [Snap CI](https://www.snap-ci.com/), has Clojure covered. In terms of build automation tools you have [Leiningen](http://leiningen.org/) and [Clojar](https://clojars.org/) looks like a good source of libraries. The testing story is also a good one, it comes with it's [own test framework](http://clojure.github.io/clojure/clojure.test-api.html), but also has many other options, such as [speclj](http://speclj.com/) and [Midje](https://github.com/marick/Midje). All in all it looks like Clojure ticks all of the boxes, thanks to it's wide adoption and maturity. The only downside, which is also one of it's advantages, is that it runs on the JVM and hence allows you to leverage the rich Java eco system.

### Go
What about Go?

So there are quite a few things to take into consideration... And then there's the question does the language jell with me. To help me with that I have found an awesome resource that allows me to explore the languages: [Exercism](http://exercism.io/), the brain child of Katrina Owen. Also I have recently been thumbing through [Seven Languages in Seven Weeks](https://pragprog.com/book/btlang/seven-languages-in-seven-weeks) again, which has been really great at introducing some of the languages I am considering as well suggesting a few exercises for further exploration.

Writing all this down seems like a lot of consideration for something that I used to do on a whim.
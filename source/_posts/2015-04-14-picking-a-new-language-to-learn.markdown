---
layout: post
title: "Picking a new language to learn"
date: 2015-04-14 23:08:55 +0100
comments: true
categories: learning, languages, criteria, scala, clojure, go, elixir
---
I started writing this post with the idea to just layout what was important to me in choosing what language to pick up this year and go through the options. I didn't really expect to make a choice by the end of it.

In doing this post and thinking about what I wanted out of a language, the community around it and doing the research, there was only one real winner in the end. It does help to put things into writing... The TL;DR is this year I will be looking at: [Clojure](http://clojure.org/)? Why it ticks all of the boxes I set out in this post.

---

Most years I try to learn a new language and typically the choice has been straight forward. For some reason this year I have struggled with this. Maybe it's because there's such a proliferation of interesting languages out there. Maybe it's because I am torn between picking between OO and a Functional paradigm. 

At the top of the list are [Scala](http://www.scala-lang.org/), [Go](https://golang.org/), [Clojure](http://clojure.org/) and [Elixir](http://elixir-lang.org/). All but one are in the functional realm of programming languages; Go being the odd one out. However it does seems to have a huge traction right now. On the other hand there is something about Elixir that really appeals to me, maybe it's because it's described as being close to Ruby and be focused on developer happiness... and it's the shiny new hotness.

Oddly enough only Scala featured in my [Technology Radar](http://www.tcias.co.uk/blog/2015/02/22/build-your-own-technology-radar/). Swift was one that I listed, but does not figure at all in my shortlist. This tells me I need to leverage my radar a bit more and also think about what goes into it a little more deeply.

### What matters to me 
Things that are important to me when making the choice are: the testing story, build tools, CI support, dependency management and the backing of a web framework.

### Scala
Scala ships with [SBT](http://www.scala-sbt.org/) as the build tool. [Circle CI](http://www.circlci.com), [Codeship](https://codeship.com/) and [SnapCI](https://www.snap-ci.com/), all support Scala. 

You have a few choices on the web framework side of this with the [Play framework](https://www.playframework.com/), [Scalatra](http://scalatra.org/) and [Lift](http://liftweb.net/). 

What about testing? The first two things I came across were [ScalaTest](http://www.scalatest.org/) and [Specs2](http://etorreborre.github.io/specs2/). Being built on the JVM, you can also leverage Maven/Gradle for build automation and dependency management.

### Elixir
The CI story for Elixir is a little murky, there are [custom scripts out there](https://gist.github.com/joakimk/48ed80f1a7adb5f5ea27) to run builds on [Circle CI](http://www.circlci.com). As a web framework there is the [Phoenix Framework](http://www.phoenixframework.org/). The testing story [doesn't look fabulous](http://elixir-lang.readthedocs.org/en/latest/exunit/) yet, but it's good enough. Elixir comes with `Mix` for dealing with dependencies. It's still early days, but being on the front line could be a good thing and well there's the whole developer happiness thing that just can't be discounted.

### Clojure
As for [Clojure](http://clojure.org/), well there are quite a few options for the web framework side of things with [Caribou](http://let-caribou.in/), [Luminusweb](http://www.luminusweb.net/) and [Pedestal](https://github.com/pedestal/pedestal). 

ThoughtWorks' CI service, [Snap CI](https://www.snap-ci.com/), has Clojure covered. [Codeship](https://codeship.com/) also provide support. 

In terms of build automation tools you have [Leiningen](http://leiningen.org/) and [Clojar](https://clojars.org/) looks like a good source of libraries. 

The testing story is also a good one, it comes with it's [own test framework](http://clojure.github.io/clojure/clojure.test-api.html), but also has many other options, such as [speclj](http://speclj.com/) and [Midje](https://github.com/marick/Midje). All in all it looks like Clojure ticks all of the boxes, thanks to it's wide adoption and maturity. The only downside, which is also one of it's advantages, is that it runs on the JVM and hence allows you to leverage the rich Java eco system. And there are a lot braces to digest.

### Go
[Codeship](https://codeship.com/) provides outamated builds. Go ships with a test framework as well as benchmarking tools, so that covers the automated testing angle. There are other solutions as well such as [GoConvey](http://goconvey.co/) or [GinkGo](http://onsi.github.io/ginkgo/).

For web frameworks both [Revel](http://revel.github.io/) and [Martini](http://martini.codegangsta.io/) look good. With regards to build tools and dependency management, these are also built into the language with `go build` and `go get` respectively.

### Final thoughts

All of the languages address the things that are important to me, with varying degrees of maturity. However there's the question does the language jell with me? To help me with that I have found an awesome resource that allows me to explore the languages: [Exercism](http://exercism.io/), the brain child of Katrina Owen. She refers to them as a set of toy problems to solve and you can go very deep into the solutions, but it also provides with you with a good experimentation platform.

The other thing I remembered was this book : [Seven Languages in Seven Weeks](https://pragprog.com/book/btlang/seven-languages-in-seven-weeks). I have been recently thumbing through it again and it provides a great introduction to some of the languages I am considering as well suggesting a few exercises for further exploration.

Writing all this down seems like a lot of consideration for something that I used to do on a whim. However now that I went through this exercise, I know why language I would like to get to know more of this year: [Clojure](http://clojure.org/)

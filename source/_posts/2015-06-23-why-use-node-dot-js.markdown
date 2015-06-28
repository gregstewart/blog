---
layout: post
title: "Why use Node.js"
date: 2015-06-23 22:46:22 +0100
comments: true
categories: 
---

Recently we have been asked why we recommend the use of Node.js on our project. Stuart is putting together a [blog post on this](https://docs.google.com/a/red-badger.com/document/d/1gb1ILf2erEhlhFZurLBPQstMt1Jm__E7TTdnmT1nb14/edit?usp=sharing_eid), but it got me wondering what it is about Node.js that I like so much and why we should use it.

To be honest, I do have a love/intense dislike relationship with JavaScript. I think it's great for UI work. Adopting a functional programming paradigm and buying into immutable data has given it a new lease of life for me on the front end. Combine that with React and our Arch framework, and we do have a solid front end solution. I even enjoy working with Hapi.js, but I think actually think that maybe we should opt for another language there. Don't get me wrong it's allowed us to get out of the blocks quickly.

There are a few things that are not great though. The rate of change is dizzying at times. I think [Neal Ford](http://devchat.tv/ruby-rogues/195-rr-building-your-technology-radar-with-neal-ford) put it well when discussing the ThoughtWorks' Technology Radar:

>Well, we find that places, technology locations that have a lot of churn ends up getting a lot of  in Asses that never make it into Trial. So, we went through this recently with JavaScript frameworks because they’re like mushrooms after a rainstorm. They keep popping up and going away. So, one of the things we do for every Radar is call out themes that we’ve seen across all the blips. And one of the themes that we called out then was churn in the JavaScript space. Because at the time I think there were two common build and dependency management tools. And one was in the process of replacing the other one and you needed all three of them to get something to work. And so, there was just a lot of craziness in that space.

When looking for arguments into why we should use Node.js in the enterprise, the following benefits get attributed to using it: 

* Massive performance gains (LinkedIn, Groupon, PayPal, Walmart and Ebay)
* Great for Mobile development (Walmart and Yahoo)
* Vibrant community
* Built from day one around Async model and event driven
* Easier to find people that can work on Node than say Erlang
* Contributors are maturing

There are however a lot of common misconceptions:

* Just a JS Dev, which is clearly not true JS Devs are just as Software Engineering focused as Java Developers
* It's a server. Again not true, it's more akin to a JVM or runtime
* It's just JavaScript - look to the advances of ES6 and the future of the language. It supports TDD and DI, Static Code analysis, Error handling/Logging all the stuff the Enterprise loves
* It is slow. I think those days are behind us - measure it - V8 is fast, as are many other engines, Nashorn JVM based JS engine is also available

We need to put together a pretty consistent story that backs a lot of these statements and disavows the others. 

Let's consider some other advantages:

* cross skilling between front end and back end teams, between the whole team.
* pretty decent package management system
* it's a foundation (backed by Joyent, IBM, PayPal, Microsoft, Fidelity and the Linux Foundation)

While [this quote](http://blog.parse.com/learn/how-we-moved-our-api-from-ruby-to-go-and-saved-our-sanity/?utm_source=rubyweekly&utm_medium=email) relates to Go it's still relevant as it relates to async programming:

>An asynchronous model had many other benefits. We were also able to instrument everything the API was doing with counters and metrics, because these were no longer blocking operations that interfered with communicating to other services. We could downsize our provisioned API server pool by about 90%. And we were also able to remove silos of isolated Rails API servers from our stack, drastically simplifying our architecture.

This is one of those facts that backs the productivity increase and total cost of ownership reduction by choosing the right tool for the job. As said this is for Go, however there are many quotes to be found that back these claims in the JavaScript and Node.Js space, given it's event based non-blocking architecture. Of course performance gains from this architecture are not a guaranteed outcome, bad coding practice can undo these advantages easily.

[Modularisation + NPM = win](https://www.talentbuddy.co/blog/building-with-node-js-at-the-new-york-times/?utm_source=nodeweekly&utm_medium=email)

> Modularization via Node Modules was a big win as well, as we were able to share components across teams and easily manage them through a NPM

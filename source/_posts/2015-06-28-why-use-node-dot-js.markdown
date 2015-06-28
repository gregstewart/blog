---
layout: post
title: "Why use Node.js"
date: 2015-06-28 15:35:22 +0100
comments: true
categories: 
---

Recently we were asked why we recommend the use of [Node.js](https://nodejs.org/) on our project. While [Stuart](https://twitter.com/stuartharris) and I are putting together a presentation and working on a blog post, it got me wondering what it is about Node.js that I like so much and why we should use it.

To be honest, I do have a love/intense dislike relationship with JavaScript; however having adopted a functional programming paradigm and buying into immutable data, JavaScript development has been given a fresh impetus. Combine that with [React](http://facebook.github.io/react/) and our [Arch framework](http://archjs.org), and I am having fun building a front end application. I even enjoy working with [Hapi.js](http://hapijs.com/) at our API layer, but I think that maybe we should opt for another language there. Don't get me wrong this combination has allowed us to get out of the blocks quickly.

When looking for arguments into why we should use Node.js in the enterprise, the following benefits get attributed to using it, in brackets are the companies that have attested these benefits: 

* Massive performance gains ([LinkedIn](https://engineering.linkedin.com/nodejs/blazing-fast-nodejs-10-performance-tips-linkedin-mobile), [Groupon](https://engineering.groupon.com/2013/misc/i-tier-dismantling-the-monoliths/), [PayPal](https://www.paypal-engineering.com/2013/11/22/node-js-at-paypal/), Walmart and Ebay)
* Great for Mobile development (Walmart and Yahoo)
* Vibrant community
* Built from day one around Async model and event driven
* Easier to find people that can work on Node than say Erlang
* Contributors are maturing
 
When it comes to the performance claims, we need to put together a pretty consistent story that backs a lot of these statements and disavows the others. When looking into this for our presentation, the information is spread across tweets and blog posts. TO convince Enterprise decision makers, I think we would need something more cohesive.

While [this quote](http://blog.parse.com/learn/how-we-moved-our-api-from-ruby-to-go-and-saved-our-sanity/?utm_source=rubyweekly&utm_medium=email) relates to Go it's still relevant as it relates to async programming:

>An asynchronous model had many other benefits. We were also able to instrument everything the API was doing with counters and metrics, because these were no longer blocking operations that interfered with communicating to other services. We could downsize our provisioned API server pool by about 90%. And we were also able to remove silos of isolated Rails API servers from our stack, drastically simplifying our architecture.

This is one of those facts that backs the productivity increase and total cost of ownership reduction by choosing the right tool for the job. As said this is for Go, however there are many quotes to be found that back these claims in the JavaScript and Node.Js space, given it's event based non-blocking architecture. Of course performance gains from this architecture are not a guaranteed outcome, bad coding practice can undo these advantages easily.

The vibrant community claim are both a benefit and a detriment. I find the rate of change and churn dizzying at times. I think [Neal Ford](http://devchat.tv/ruby-rogues/195-rr-building-your-technology-radar-with-neal-ford) put it well when discussing the ThoughtWorks' Technology Radar:

>Well, we find that places, technology locations that have a lot of churn ends up getting a lot ofin Asses that never make it into Trial. So, we went through this recently with __JavaScript frameworks because they’re like mushrooms after a rainstorm. They keep popping up and going away__. So, one of the things we do for every Radar is call out themes that we’ve seen across all the blips. And one of the themes that we called out then was churn in the JavaScript space. Because at the time I think there were two common build and dependency management tools. And one was in the process of replacing the other one and you needed all three of them to get something to work. And so, there was just a lot of craziness in that space.

It is proving difficult to ignore the new shiny and this is compounded by other people's enthusiasm for experimenting with new tools and frameworks. This can have an impact on productivity as you can be forever adopting and re-writing things and it requires discipline to evaluate the tools and when to apply them to a project. On the plus side, it shows the community is driving change and improvements. 

On the flip side there are however still a lot of common misconceptions:

* Just a JS Dev, which is clearly not true. JS Devs are just as Software Engineering focused as Java Developers. This is evident in the maturing of contributors to Open Source projects
* It's a server. Again not true, it's more akin to a JVM or runtime
* It's just JavaScript - look to the advances of ES6 and the future of the language. It supports TDD and DI, Static Code analysis, Error handling/Logging all the stuff the Enterprise loves
* It is slow. I think those days are behind us - measure it - V8 is fast, as are many other engines (Shakra/Spidermonkey, etc...), Nashorn JVM based JS engine is also available

Let's consider some other advantages:

* Cross skilling between front end and back end teams, between the whole team. We blur the boundaries between front and back  end specialists, and this to me is a good thing. It also helps with pluging knowledge gaps and knowledge being concentrated with one team member or area of the team 
* It has a pretty decent package management system with NPM
* It's a foundation (backed by Joyent, IBM, PayPal, Microsoft, Fidelity and the Linux Foundation)

To expand a little on the NPM point. If you consider [Modularisation and NPM](https://www.talentbuddy.co/blog/building-with-node-js-at-the-new-york-times/?utm_source=nodeweekly&utm_medium=email), you find yourself in a win win situation.

> Modularization via Node Modules was a big win as well, as we were able to share components across teams and easily manage them through a NPM

Smaller/modular code is easier to maintain and debug. More modular code, is more composable and indeed more re-usable. 

I touched on this briefly at the top, but when you consider the ability to write code that runs on both the server and client (as you do with with Isomorphic apps), you add great value for your clients. Time to first render using JavaScript that was rendered on the server is good for the user experience. People all to often focus on the value this approach offers to SEO (it does add value by the way), however I think if you consider Single Page Applications that can seemlessly fall back to a Request/Response model you have a real winner on your hands. While turning off JavaScript on the client is an argument as well, the reality is very few people do this. _BUT_ a lot of devices have poor JavaScript support, to the point where they might as well be categorised as having  JavaScript turned off (I am looking at you BlackBerry in the enterprise). Having an isomorphic solution up your sleeve in these situations is worth it's weight in gold. 

There are many things that speak to Node.js being a great choice for developing and delivering applications across the spectrum of businesses. I hope I have also made a few points that back up why this is a great platform to work and have fun delivering solutions with.

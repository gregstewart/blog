---
layout: post
title: "TCIAS: now with continuous delivery"
date: 2014-05-24 17:27
comments: true
tags:
- ci
- codeship
- code climate
- coveralls
- travis ci
- capistrano

categories:
- ruby
- continuous delivery
- capistrano
- rails
---
This time last year, I reworked TCIAS and my initial focus was to develop the site using a build pipeline.
I opted to a few tools:

* [Travis CI](https://travis-ci.org/)
* [Code Climate](https://codeclimate.com/)
* [Coveralls](https://coveralls.io/)
* [Capistrano](http://capistranorb.com/)

The workflow went as follows, commit to Github, let Travis CI pick up the changes, on successful build,
push coverage results to Coveralls. At that point I did a little bit of manual work, reviewed Coveralls,
refreshed Code Climate and reviewed the results. The final step was to run:

    Cap deploy

And push the changes to my server. Life was pretty good, but I was still missing that final step,
automating the deployment to my box. Fast forward a year and a colleague suggested I check out Codeship.io.

I think I spent possibly an hour getting up to speed and configuring things, basically building on the
Travis CI setup and in no time I had everything continuously deploying to my server. A few gotchas:

* [figuring out coveralls integration](http://blog.codeship.io/2013/04/24/take-cover-with-coveralls-on-codeship.html) - as sadly it's missing from the documentation section
* [figuring out my coveralls repo token](https://github.com/lemurheavy/coveralls-public/issues/152)
* rvm ruby 2.1.0 - when the deployment kicked off and my deploy script started doing it's thing on my box,
it aborted complaining about rvm not being able to use ruby 2.1.0 (for the record I use [rvm](http://rvm.io/)
and had version 2.1.1 of ruby installed). Once I installed 2.1.0 everything was fine.

I am really impressed with how simple Codeship have made things. Maybe it's because I ironed out a lot of
the kinks when setting up Travis CI, however being able to just add a cap deploy configuration to your
build pipeline that can use your Capistrano configuration without any change was just delightful. I highly
recommend everyone check them out. They are incredibly helpful and communicative, very impressive and I am a
happy customer, with a complete continuous integration pipeline.
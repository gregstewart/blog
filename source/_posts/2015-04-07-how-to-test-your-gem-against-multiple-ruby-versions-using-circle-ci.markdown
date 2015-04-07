---
layout: post
title: "how to test your gem against multiple ruby versions using circle ci"
date: 2015-04-07 22:14:24 +0100
comments: true
categories: ruby, gem, coder_wally, circle ci, test, automation, continuous delivery
---
My work on my little gem continues to make slow but stead progress. This week I wanted I carried out some mjaor re-working of the API. I wanted to follow the [Parallel Change](http://www.tcias.co.uk/blog/2014/07/20/design-pattern-parallel-change/) pattern for these changes, as I didn't want to completely break the API. However there was at least one breaking change, given that I moved from:

```
client = CoderWally::Client.new
coder_wally = client.get_everything_for ARGV[0]
```

To:

```client = CoderWally::Client.new ARGV[0]```

For the record you can still call `client.get_everything_for ARGV[0]`, but you will see a deprecation warning.

The other thing that I wanted to experiment with was running a build against multiple versions of Ruby. In [Circle Ci](https://circleci.com/), this is actually really straightforward. All you need to do is override the dependency and test steps in your `circle.yml` file. I wanted to run a build against ruby: `2.0.0-p568`, `2.1.5` and `2.2.0`, so here's what my config file looks like to achieve this:

```
dependencies:
  override:
    - 'rvm-exec 2.0.0-p598 bundle install'
    - 'rvm-exec 2.1.5 bundle install'
    - 'rvm-exec 2.2.0 bundle install'

test:
  override:
    - 'rvm-exec 2.0.0-p598 bundle exec rake'
    - 'rvm-exec 2.1.5 bundle exec rake'
    - 'rvm-exec 2.2.0 bundle exec rake'
```

While this was easy to set up there were a cople of learnings:

* Do not specify a bundler version in your gems dev dependencies. It's just more flexible to trust the system and ruby version that is running the `bundle install` command. If you do then you need to install the corresponding version on the build server. Also if you want to go back to older versions of ruby that aren't supported by the bundler version you have specified, then there's more fuffing about.
* The other thing had to do with [Minitest](https://github.com/seattlerb/minitest) and Ruby 2.2.0: simply put the call to require it failed. To get the build to pass on [Circle Ci](https://circleci.com/), I had to [add a dev dependency to my Gemspec](https://github.com/gregstewart/coder_wally/blob/master/coder_wally.gemspec).

I would like to test out running against older versions of Ruby and the latest JRuby, but when I had a [quick go](https://circleci.com/gh/gregstewart/coder_wally/35), [Webmock](https://github.com/bblimke/webmock) was telling me that I should stub my requests, which I am doing, but for some reason, there aren't being recognised in this configuration. 

 
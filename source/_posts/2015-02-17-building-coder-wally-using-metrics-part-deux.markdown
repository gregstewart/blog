---
layout: post
title: "building coder_wally using metrics - part deux"
date: 2015-02-17 16:31:18 +0000
comments: true
categories: 
---
Earlier this week I posted a short piece on building [Coder_Wally](https://rubygems.org/gems/coder_wally/) and some of the tools I used to improve the code. This post continues on from where I left on talking about [Reek](https://github.com/metricfu/reek) and [RuboCop](https://github.com/bbatsov/rubocop).

[RuboCop](https://github.com/bbatsov/rubocop) was an interesting tool, as it helped me write code the Ruby way. Some of the methods I had written used things like `get_` or `has_`. The Ruby way you don't bother with the `get_something`, instead it just becomes `something`. `has_something` simply becomes `something?`. Those were the greatest benefits from using RuboCop that I recall. 

One thing that bit me though was changing `"` to `'` when no string interpolation was happening. Changing this: 
    
    spec.files = `git ls-files -z`.split("\x0") 

to 

    spec.files  = `git ls-files -z`.split('\x0')

The Gem would no longer build or install throwing `string contains null byte message` error (somewhat after the fact). The problem: single quotes around `split('\x0')`. Need to look into exactly why this was a problem.

I found [Reek](https://github.com/metricfu/reek) awesome. It flagged a bunch of potential code smells ([duplicate calls](http://www.rubydoc.info/github/troessner/reek/Reek/Smells/DuplicateMethodCall) and [nested iterators](http://www.rubydoc.info/github/troessner/reek/Reek/Smells/NestedIterators)) and pointed out where methods on certain classes were exhibiting [feature envy](http://www.rubydoc.info/github/troessner/reek/Reek/Smells/FeatureEnvy) and [utility function](http://www.rubydoc.info/github/troessner/reek/Reek/Smells/UtilityFunction) behaviour. I am linking to the docs as they are really insightful.

The outcome of refactoring the code was a few more classes, extracted the exception handling to it's own class and create and error code finder. 

Interestingly enough after fixing some code smells, I was now confronted with a [Control Parameter smell](http://www.rubydoc.info/github/troessner/reek/Reek/Smells/ControlParameter). The solution there was to revert the method extractions I had done some time ago and inline them back again (I had extracted helper methods for request errors that raised an exception based on the status code). 

I found this iterative approach of running [RuboCop](https://github.com/bbatsov/rubocop) and [Reek](https://github.com/metricfu/reek) after a few iterations each, really helpful and it certainly led to cleaner looking code. At least I thinks so `:)`. Again, one should not blindly follow metrics, but use your judgement and in the absence of having someone to review your work they certainly help. Overall an interesting exercise and productive exercise.

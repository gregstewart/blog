---
layout: post
title: "building coder_wally using metrics - part deux"
date: 2015-02-17 16:31:18 +0000
comments: true
categories: ruby, gem, reek, rubocop
---
Earlier last week I [posted a short piece](http://gregs.tcias.co.uk/2015/02/09/building-my-coder-wally-gem-using-metrics/) on building [Coder_Wally](https://rubygems.org/gems/coder_wally/) and some of the tools I used to improve the code. This post continues on from where I left on talking about [Reek](https://github.com/metricfu/reek) and [RuboCop](https://github.com/bbatsov/rubocop).

[RuboCop](https://github.com/bbatsov/rubocop) was an interesting tool, as it helped me write code in more idomatic way, i.e. more like a Ruby developer would. Some of the methods I had written used things like `get_` or `has_`. The Ruby way you don't bother with the `get_something`, instead it just becomes `something`. `has_something` simply becomes `something?`. 

One thing that bit me though was changing `"` to `'` when no string interpolation was happening. Changing this: 
    
    spec.files = `git ls-files -z`.split("\x0") 

to 

    spec.files  = `git ls-files -z`.split('\x0')

The Gem would no longer build or install throwing `string contains null byte message` error (somewhat after the fact). The problem: single quotes around `split('\x0')`. Need to look into exactly why this was a problem. I hope I am not being unfair to RuboCop, but it's primary focus is to help your code follow the [Ruby Style guide](https://github.com/bbatsov/ruby-style-guide) and not point out code hot spots. 

[Reek](https://github.com/metricfu/reek) on the other hand was awesome for finding hotspots. It flagged a bunch of potential code smells ([duplicate calls](http://www.rubydoc.info/github/troessner/reek/Reek/Smells/DuplicateMethodCall) and [nested iterators](http://www.rubydoc.info/github/troessner/reek/Reek/Smells/NestedIterators)) and pointed out where methods on certain classes were exhibiting [feature envy](http://www.rubydoc.info/github/troessner/reek/Reek/Smells/FeatureEnvy) and [utility function](http://www.rubydoc.info/github/troessner/reek/Reek/Smells/UtilityFunction) behaviour. I am linking to the docs as they are really insightful.

The outcome of refactoring the code was a few more classes. I extracted the exception handling to it's own class and created and error code finder. Methods that were manipulating objects to get there work done, were updated to have less knowledge and only work on what they needed. Take this method as an example:

    # parse account information from data
    def parse_accounts(response)
      Account.new(response[accounts]) if response[accounts]
    end

This method actually has two problems for one it was making duplicate calls (`response[accounts]`). This could have been fixed by extracting the calls to a variable; however by fixing the underlying problem (the [utility function](http://www.rubydoc.info/github/troessner/reek/Reek/Smells/UtilityFunction) behaviour) would also fix that issue. The method knew too much about response object and what it contains in order to get it's work done, the change is quite simple extract the knowledge to the calling method: 

    # parse account information from data
    def parse_accounts(accounts)
      Account.new(accounts) if accounts
    end
    
    ...
    
    # build CoderWall object from API response
    def build(response)
      badges = parse_badges(response['badges'])
      accounts = parse_accounts(response['accounts'])
      user = parse_user(response)

      CoderWall.new badges, user, accounts
    end

Interestingly enough after extracting my Exception Handler object, I was now warned about a [Control Parameter smell](http://www.rubydoc.info/github/troessner/reek/Reek/Smells/ControlParameter). The solution there was to revert the extraction of helper method for request errors that raised an exception based on the status code by inlining them back again.  
I found this iterative approach of running [RuboCop](https://github.com/bbatsov/rubocop) and [Reek](https://github.com/metricfu/reek), really helpful and it certainly led to cleaner looking code. At least I thinks so `:)`. Again, do not blindly follow metrics, but use your judgement. In the absence of having someone to review your work these tools certainly help. Overall an interesting exercise and productive exercise.

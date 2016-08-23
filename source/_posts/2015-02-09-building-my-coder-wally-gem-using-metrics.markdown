---
layout: post
title: "building my coder_wally gem using metrics"
date: 2015-02-09 22:37:32 +0000
comments: true
categories: ruby, gem, metric_fu, flog, rubocop
---

A few weeks back I decided to add [CoderWall badges](https://coderwall.com/welcome) to the feed on [my site](//www.tcias.co.uk). I could have just grabbed an existing gem but I decided to [build my own](https://github.com/gregstewart/coder_wally). If you are truly keen you can also find it over at [Rubygems.org](https://rubygems.org/gems/coder_wally/) and add to the other 1,245 downloads `:)`.

To get the ball rolling I followed the steps described over at [How I Start](http://www.howistart.org/posts/ruby/1). The first stab ended up looking like this:

	require "coder_wally/version"
	require "open-uri"
	require "json"

	# All code in the gem is namespaced under this module.
	module CoderWally
  		# The URL of API we'll use.
		Url = "https://coderwall.com/%s.json"

  		class Badge
    		attr_reader :name, :badge, :description, :created

	    	def initialize(hashed_badge)
    	  		@name = hashed_badge.fetch("name")
      			@badge = hashed_badge.fetch("badge")
      			@description = hashed_badge.fetch("description")
	      		@created = hashed_badge.fetch("created")
    		end
  		end

	  	def CoderWally.get_badges_for username
    		raise(ArgumentError, "Plesae provide a username") if username.empty?
	    	url = URI.parse(Url % username)
	    	response = JSON.load(open(url))      

		    response["badges"].map { |badge| Badge.new(badge) }
	  	end
	end

It simply fetched JSON from the API for a given username and returned a collection of badges. Over the next couple of iterations I reworked a few things and added support for user details and accounts. For testing purposes (and to speed things up) I used [Webmock](//github.com/bblimke/webmock) to fake responses from the service. The most interesting thing to solve, was how to dynamically assign `attr_accessor`s to the account object. I eventually found that you could do so by using a combination of `singleton_class.class_eval` and `self.instance_variable_set`. With the features done I looked around at other gems and what their README's and tool chain looked like.

The first tool I decided to investigate was [Flog](http://ruby.sadi.st/Flog.html) which [Sandy Metz used in a talk](//www.youtube.com/watch?v=8bZh5LMaSmE) I saw recently. The Initial run yielded the following output:

     find lib -name \*.rb | xargs flog                                                                                                                                    
     84.3: flog total
     6.0: flog/method average

    19.1: CoderWally::Client#build_coder_wall lib/coder_wally/client.rb:47
    16.2: CoderWally::Client#send_request  lib/coder_wally/client.rb:20
    11.1: CoderWally::Account#initialize   lib/coder_wally/account.rb:6
     8.8: main#none

The `Client` object could use a little love. To start things of, I decided to pull all of the API related calls into their own class, so anything relating to `send_request`:

     89.0: flog total
     5.2: flog/method average

    16.4: CoderWally::Client#build_coder_wall lib/coder_wally/client.rb:27
    16.2: CoderWally::API#send_request     lib/coder_wally/api.rb:13
    11.1: CoderWally::Account#initialize   lib/coder_wally/account.rb:6
     9.9: main#none

That just moved the complexity around, but at least the Client object was now a little simpler, so to fix the complexity I extracted methods from the the send_request, which looked started off as follows:

	# Dispatch the request
        def send_request url
          begin
            open(url)
          rescue OpenURI::HTTPError => error
            raise UserNotFoundError, 'User not found' if  error.io.status[0] == '404'
            raise ServerError, 'Server error' if  error.io.status[0] == '500'
          end
        end

Not overly complicated, but let's follow the advice and see if we can't improve on this, by extracting methods. I ended up with this:

      def send_request(url)
        begin
          open(url)
        rescue OpenURI::HTTPError => error
          handle_user_not_found_error(error)
          handle_server_error(error)
        end
      end

      # Parse status code from error
      def get_status_code(error)
        error.io.status[0]
      end

      # Raise server error
      def handle_server_error(error)
        raise ServerError, 'Server error' if  get_status_code(error) == '500'
      end

      # Raise user not found error
      def handle_user_not_found_error(error)
        raise UserNotFoundError, 'User not found' if  get_status_code(error) == '404'
      end

Running flog showed that the code in the `send_request` method was now no longer being flagged as complicated.

    86.1: flog total
     4.3: flog/method average

    15.1: CoderWally::Client#build_coder_wall lib/coder_wally/client.rb:27
    11.1: CoderWally::Account#initialize   lib/coder_wally/account.rb:6
     9.9: main#none
     6.3: CoderWally::API#uri_for_user     lib/coder_wally/api.rb:36
     5.7: CoderWally::Badge#initialize     lib/coder_wally/badge.rb:9
     5.0: CoderWally::User#initialize      lib/coder_wally/user.rb:9

Next I tackled `CoderWally::Client#build_coder_wall` method. This led to creating a Coderwall `builder` object with simpler and more single purpose methods:

	module CoderWally
		# Builds the CoderWall object from the response
		class Builder
    			# Instantiate class
		    	def initialize
		    	end

		    	# parse badges from data
		    	def parse_badges(data)
		      		data['badges'].map { |badge| Badge.new(badge) } if data['badges']
		    	end

		    	# parse account information from data
		    	def parse_accounts(data)
      				Account.new(data['accounts']) if data['accounts']
    			end

		    	# parse user information from data
		    	def parse_user(data)
		      		User.new(data['name'], data['username'],
               				data['location'], data['team'], data['endorsements'])
		    	end

		    	# build CoderWall object from API response
    			def build response
      				badges = parse_badges(response)
		      		accounts = parse_accounts(response)
		      		user = parse_user(response)

			    	CoderWall.new badges, user, accounts
	    		end
	 	end
	end

Still not happy with all of the names, but it did feel and look better than this:

	# Builds a CoderWall object
        def build_coder_wall(username)
        	json_response = JSON.load(send_request(uri_for_user(username)))
       		badges = json_response['badges'].map { |badge| Badge.new(badge) }
       		accounts = Account.new(json_response['accounts'])
       		user = User.new(json_response['name'], json_response['username'],
               		json_response['location'], json_response['team'], json_response['endorsements'])

	        CoderWall.new badges, user, accounts
        end

Flog agreed as well, and while the flog total was on the up, the method average kept going down (we started with a `6.0` average and ended up with `3.9`):

	93.4: flog total
     	3.9: flog/method average

	11.1: CoderWally::Account#initialize   lib/coder_wally/account.rb:6
    	11.0: main#none
     	7.0: CoderWally::Builder#parse_user   lib/coder_wally/builder.rb:15
     	6.3: CoderWally::API#uri_for_user     lib/coder_wally/api.rb:38
     	5.7: CoderWally::Badge#initialize     lib/coder_wally/badge.rb:9
     	5.0: CoderWally::Builder#build        lib/coder_wally/builder.rb:20
     	5.0: CoderWally::User#initialize      lib/coder_wally/user.rb:9
     	4.0: CoderWally::API#send_request     lib/coder_wally/api.rb:13
     	3.9: CoderWally::API#get_status_code  lib/coder_wally/api.rb:23

I am going to stop here. In a follow up post I will talk specifically about [Rubocop](https://github.com/bbatsov/rubocop) and [Metric_fu](https://github.com/metricfu/metric_fu) and how they further impacted the design and reability of the code. Before I go though, I wanted to finish up with some thoughts on using Flog and how it changed my code.

I started with one object that did everything and through a series of refactorings I ended up with several smaller more cohesive objects that also followed the Single Responsibility principle more closely (I wasn't there yet and probably still am not).

I felt that my initial implementation was simple and readable enough. But that's just the thing isn't it? We feel that our code is good enough, but statistics can back these 'feelings' up or indeed refute them. I am not saying that one should blinbdly follow these kind of metrics and drive our code based off of these, but they are a good source of information and as this little experiment has shown can help improve the code. In the absence of being able to pair with somone or have someone else review your code, Flog proved very useful. Overall I am happier with having a class for API calls and who's methods are more intention revealing. Likewise with my builder object and it's methods, in the next post I will show how I continued on the improvement path for that particular class using [Metric_fu](https://github.com/metricfu/metric_fu) ([Reek](https://github.com/metricfu/reek) in particular) and [Rubocop](https://github.com/bbatsov/rubocop).

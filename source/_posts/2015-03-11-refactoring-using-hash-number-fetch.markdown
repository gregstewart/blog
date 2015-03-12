---
layout: post
title: "refactoring using Hash#fetch]"
date: 2015-03-11 21:28:54 +0000
comments: true
categories: coer_wally, ruby, reek, refactoring, memoization
---
Last night I decided to add a simple memoization pattern to my [coder_wall gem](https://rubygems.org/gems/coder_wally) to stop unnecessary network calls to retrieve data from the CoderWall API. Memoization is a form of caching, well there's more to it than that. So let's refer to [Wikipedia](http://en.wikipedia.org/wiki/Memoization) for a more detailed explanation and more reading if you are interested:

> In computing, memoization is an optimization technique used primarily to speed up computer programs by storing the results of expensive function calls and returning the cached result when the same inputs occur again.

My intent was to reduce calls to the CoderWall API for the same `username`. Here is what the code for fecthing data used to look like:

```
# Fetch data from CoderWall
def fetch(username)
	uri = uri_for_user(username)
    json = send_request(uri)

	begin	
    	JSON.parse(json.read)
    rescue JSON::ParserError
        raise InvalidJson, 'Received invalid json in response'
    end
end
```

I created a `@response` instance variable that would store the parsed results of the call. If the `username` key existed in the hash just return the result otherwise go over the wire to get the data:

```
# Fetch data from CoderWall
def fetch(username)
	return @response[username] unless @response[username].nil?

	uri = uri_for_user(username)
    json = send_request(uri)
 
    begin
		@response[username] = JSON.parse(json.read)
    rescue JSON::ParserError
        raise InvalidJson, 'Received invalid json in response'
    end
end
```

So far so good, until I ran [Metric_fu](https://github.com/metricfu/metric_fu) and I got two warnings: Nil checking and duplicate calls. That immediately reminded me of a passage in [Avdi Grimm](http://about.avdi.org/)'s excellent book [Confident Ruby](http://www.confidentruby.com/). Armed with that knowledge I was wable to make one change that removed the code smells:

```
# Fetch data from CoderWall
def fetch(username)
	@response.fetch(username) do
        uri = uri_for_user(username)
        json = send_request(uri)

        begin
          @response[username] = JSON.parse(json.read)
        rescue JSON::ParserError
          raise InvalidJson, 'Received invalid json in response'
        end
	end
end
```

Because `@response` is a [Hash](http://ruby-doc.org/core-2.2.0/Hash.html) I was able to leverage using the [fetch](http://ruby-doc.org/core-2.2.0/Hash.html#method-i-fetch) method in conjunction with passing a block to it, thus avoiding any of Nil checking. There's a little more to it, but really you should read all about it in Avdi's [book](http://www.confidentruby.com/), it is a veritable treasure trove of patterns.

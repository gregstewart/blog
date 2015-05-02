---
layout: post
title: "exploring the open closed principle"
date: 2015-04-27 15:29:33 +0000
comments: true
categories: 
---
At the start of the year I watched sandy Metz's talk: [All the Little Things](https://www.youtube.com/watch?v=8bZh5LMaSmE). It's an absolutely brilliant and once again inspiring talk.

[![RailsConf 2014 - All the Little Things by Sandi Metz](http://img.youtube.com/vi/8bZh5LMaSmE/0.jpg)](https://www.youtube.com/watch?v=8bZh5LMaSmE)

She touches on many interesting and thought provoking topcis. The one I would like to focus on with this post is the [open closed principle](http://en.wikipedia.org/wiki/Open/closed_principle):

> In object-oriented programming, the open/closed principle states "software entities (classes, modules, functions, etc.) should be open for extension, but closed for modification"; that is, such an entity can allow its behaviour to be extended without modifying its source code.

In essence you should be able to add a feature to a certain part of your application without having to modify the existing code. When I first came across this idea, at first this seems unachievable. How can you add a feature without touching existing code? The talk got me thinking about some of my code and I was keen to explore applying this to my code.

So toward the backend of February I embarked on a refactoring exercise of the core feature of my site [Teacupinastorm](http://www.tcias.co.uk/). For some time I had been meaning to add a few new feeds to the page, but adding them was a bit of a slog, as I needed to touch way to many files in order to add one feed. Sounded like a prime candidate to explore the Open Close principle in practical manner.

As I mentioned, in order to add a feed I needed to edit at least two files and then create a new object to fetch and format the feed data it into a standard structure that my view could use. What really helped me with this exercise was that the functionality had decent test coverage.

At the heart we have the `Page` Object, which basically co-ordinates the calls to the various APIs and quite a bit more. This is a another smell, it goes against the Single responsibility principle. This is what it used to look like: 

```
class Page
  attr_reader :items

  def initialize
    @items = []
    @parser_factory = ParserFactory.new
  end

  def fetch
    parser_configurations = {wordpress: {count: 10}, delicious: {count: 5}, instagram: {count: 6}, github: {count: 5},
                  twitter: {count: 4}, vimeo: {count: 1}, foursquare: {count: 10}}

    parser_configurations.each do |parser_configuration|
      parser_type = parser_configuration[0]
      feed_item_count = parser_configuration[1][:count]

      parser = @parser_factory.build parser_type
      feed_items = parser.get_last_user_events feed_item_count

      feed_items.each do |item|
        parser_configuration = set_page_item(parser_type, item[:date], item[:content], item[:url], item[:thumbnail], item[:location])
        @items.push(parser_configuration)
      end

    end

  end

  def sort_by_date
    @items.sort! { |x, y| y[:date] <=> x[:date] }
  end

  def set_page_item(type, date, content, url, thumbnail, location)
    page_item = {}
    page_item[:type] = type
    page_item[:date] = fix_date(date, type)
    page_item[:content] = content
    page_item[:url] = url
    page_item[:thumbnail] = thumbnail
    page_item[:location] = location
    page_item
  end

  def fix_date(date, type)
    return DateTime.new if date.nil?

    (type == :instagram || type == :foursquare) ? DateTime.parse(Time.at(date.to_i).to_s) : DateTime.parse(date.to_s)
  end

  def get_by_type(type)
    @items.select { |v| v[:type] =~ Regexp.new(type) }
  end

end
```

It does a lot and it also had some inefficiencies. It also had a high churn rate. All smells asking to be improved upon.

One of the first things I did was move the `parser_configuration` out of this object. It's a perfect canditate for a configuration object. So I moved that into it's own yaml file and let rails load that into application scope. Now when I add a new feed, I no longer need to touch this file, but just add it to the yaml file. 

Next I looked at the `ParserFactory`. Basically it took a type and and returned an object that would fetch the data. Another candidate to refactor so that I would not need to edit this file when I added a new feed.

```
class ParserFactory

  def build (type)

    case type
      when :foursquare
        parser = FoursquareParser.new
      when :instagram
        parser = InstagramParser.new
      when :delicious
        parser = DeliciousParser.new
      when :github
        parser = GithubParser.new
      when :twitter
        parser = TwitterParser.new
      when :vimeo
        parser = VimeoParser.new
      when :wordpress
        parser = WordpressParser.new
      else
        raise 'Unknown parser requested'
    end

    parser
  end

end
```

The individual parsers were actually fecthing the data and formatting the response into a standard format for the view. If you watched Sandy's video you will recognise the pattern here. Once a new feed was added I had to add a new case. I re-worked the code to this:

```
class WrapperFactory

  def build (type)
    begin
      Object::const_get(type + "Wrapper").new
    rescue
      raise 'Unknown parser requested: ' + type
    end
  end

end
```

They objects themselves were more wrappers, so I re-named the factory object and the individual objects. I can't quite get rid the "Wrapper" part as some the gem names would clash with the class names. Need to work on that some more.

So the wrappers massaged the content of the response into the right format by looping over the result set and return the collection to the `Page` object. Then I would loop again in the `Page` object to set the page item. Redundant looping, let's address this.

I looked at the `set_page_item` and `fix_date` methods. For starters they seemed related and did not belong in this object so I extracted them into a `PageItem` object. Furthermore `fix_date` checked the feed type to format the date. I decided to move the responsibility for creating this object into the individual wrappers and then just appending the result to the items collection.

Now the `Page` object looks like this:

```
class Page
  attr_reader :items

  def initialize
    @items = []
    @wrapper_factory = WrapperFactory.new
  end

  def fetch_page_items

    FEED_CONFIGS.each do |feed_configuration|
      parser_type = feed_configuration[0]
      feed_item_count = feed_configuration[1]['count']

      wrapper = @wrapper_factory.build parser_type.to_s.capitalize

      @items.concat(wrapper.get_last_user_events(feed_item_count))
    end
  end

  def fetch_sorted_page_items
    fetch_page_items
    sort_by_date
  end

  def sort_by_date
    @items.sort! { |x, y| y.date <=> x.date }
  end

  def get_by_type(type)
    @items.select { |v| v.type == type }
  end

end
```

A little simpler, but more importantly when it comes to adding a new feed I no longer need to edit this file or indeed the Factory object. It's safe to say that both `WrapperFactory` and `Page` are now open for extension and closed for modification. The next time I add a feed, I do not need to touch these two objects. I simply update my configuration file and create a feed type wrapper. 

However now `PageItem` is not open closed. What if I add a new feed and I need fix the date? Now I would need to adjust the `fix_date` method in that object. So I decided to extract that method from the `PageItem` into it's own module. I adjusted the code to be more generic and put the responsibility on parsing the date back on the individual feed wrappers. Ultimately they have more knowledge about the data they are handling and it's certainly not the `PageItem`'s responsibility to that job.

The code overall is better to reason about and each object has a more concrete responsibility now and more importantly when I add a new feed I no longer have to touch `Page`, `PageItem` or `WrapperFactory`. 

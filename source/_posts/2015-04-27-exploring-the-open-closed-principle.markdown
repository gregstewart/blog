---
layout: post
title: "exploring the open closed principle"
date: 2015-04-27 15:29:33 +0000
comments: true
categories: 
---
Toward the backend of February I embarked on a refactoring exersice of the core feature of my site [Teacupinastorm](http://www.tcias.co.uk/). For some time I had been meaning to add a few new feeds to the page, but adding them was a bit of a slog I basically needed ot touch way to many files in order to add one feed. The spark came from watching sandy Metz's brilliant talk: [All the Little Things](https://www.youtube.com/watch?v=8bZh5LMaSmE)

[![RailsConf 2014 - All the Little Things by Sandi Metz](http://img.youtube.com/vi/8bZh5LMaSmE/0.jpg)](https://www.youtube.com/watch?v=8bZh5LMaSmE)

The [open closed principle](http://en.wikipedia.org/wiki/Open/closed_principle):

> In object-oriented programming, the open/closed principle states "software entities (classes, modules, functions, etc.) should be open for extension, but closed for modification"; that is, such an entity can allow its behaviour to be extended without modifying its source code.

In order to add a feed I needed to edit at least three files and then create a new object to handle the feed data to format it into something my view could use.

At the heart we have the `Page` Object, which basically co-ordinates the calls to the various APIs and this is what is used to look like: 

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

It does a lot and it also had some inefficiencies, it also had the high churn rate, bot suprising since it was the heart of the app. There were two methods (`get_by_type` and `sort_by_date`) that only the controller cared about so I moved them back into the controller. 

Next I moved the `parser_configuration` out of this object, it's a perfect canditate for some configuration object. So let's move that into it's own yaml file.
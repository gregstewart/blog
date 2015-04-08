---
layout: post
title: "a couple of bundler tricks"
date: 2015-04-07 22:04:33 +0100
comments: true
categories: ruby, bundler
---
Quite literally two things, no more no less. 

To install a specific version of bundler do:

    gem install bundler -v x.x.x

Where `x.x.x` is the version to install. Probably well known, but I had to look it up. Then use that version run, instead of the the latest one you have installed:

    bundle _x.x.x_ install

Those `_` surrounding the version number are not a typo and it does look odd, but it works... 


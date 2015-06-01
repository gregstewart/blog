---
layout: post
title: "Two cool use cases for Vagrant"
date: 2015-06-01 21:56:48 +0100
comments: true
categories: vagrant, virtualisation, docker, bluemix, automation
---

I have been using [Vagrant](https://www.vagrantup.com/) on and off for a couple of years now to set up dev environments. Admittedly [Docker](https://www.docker.com/) has recently been my prefered way for setting up such environments. Last week I came across two other uses cases for Vagrant that I wanted to share. 

We were tasked with setting up [Jenkins](https://jenkins-ci.org/) on a server and while we were waiting for the environment to be made available, [Stuart](https://twitter.com/stuartharris) went ahead and built a box using the same target OS to work through and document the steps needed to install Jenkins. Once done, we just ran `vagrant destroy` and `vagrant up` to quickly repeat and validate that the steps we had jotted down were correct and that we had everything we needed. Such a quick and easy to prepare and validate an install. As a result installing [Jenkins](https://jenkins-ci.org/) on the target environment only took me about 20 minutes.

The other use I came across was, when working with a [Bluemix buildpack](https://www.ng.bluemix.net/docs/#starters/byob.html). I was setting up a [Nginx](http://nginx.org/) based reverse proxy for our app, but I wanted to upgrade the Nginx version. Reading through the documentation for the [buildpack](https://github.com/cloudfoundry/staticfile-buildpack), I saw probably the coolest use yet for Vagrant. Simply run `vagrant up` and it spins up two instance of Ubuntu ([Lucid](http://releases.ubuntu.com/10.04/) and [Trusty](http://releases.ubuntu.com/14.04/)), patches itself, builds the Nginx binaries and moves them to a distribution folder once done. To upgrade Nginx was a doddle as a result: simply update the target version (and the [PCRE](http://www.gammon.com.au/pcre/index.html) version), run `vagrant up` and a few minutes later you have two new sets of binaries that can be pushed to [Bluemix](https://console.ng.bluemix.net/) with the community buildpack. Be sure to also check out the tests!

So there you have it, Vagrant is not only great for solo devs and dev teams as a sandboxed dev environment, but you can try out installations and build binaries with a few simple commands.

---
layout: post
title: "getting started"
date: 2014-09-03 12:09:32 +0100
comments: true
categories: [book, ci, assets, generate, less, javascript, browserify, uglify, grunt, task]
---

Here's the getting started chapter of the book, you can read the [chapter of the book here](
http://gregstewart.gitbooks.io/modern-web-app-development/manuscript/chapter2.html), as well as the full book.

Here's also a list of chapters you can find as blog posts on the site:

 * [Book Introduction](/2014/09/03/book-introduction/)
 * [Getting started](/2014/09/03/getting-started/)
 * [Writing our first functional test](/2014/09/03/writing-our-first-functional-test/)
 * [Continuous delivery](/2014/09/03/continuous-delivery/)
 * [Building Your Assets Using Grunt](/2014/08/12/building-your-assets-using-grunt/)
 * [Development guided by tests](/2014/09/03/development-guided-by-tests/)

* * *

The first thing I like to do with any project is to get our build pipeline set up and start deploying code to our 'production' environment. To that end we need to look at building the simplest thing possible to validate our testing infrastructure works, our CI envinronment can pick up changes on commit and after a succesful build deploy the changes.

I will assume you have signed up and installed all of the software outlined in the [What you will need section]("What you will need section").

##Setting up our project##
Open up a terminal window or code to the command line and navigate to the location you want to store your project files. Once there let's create a project folder:

	mkdir weatherly && cd weatherly

And initilise our github repository:

	git init
	Initialized empty Git repository in /Users/gregstewart/Projects/github/weatherly/.git/

Before we go any further let's create a .gitignore file in the root of our project and add the following to it:

	node_modules
	.idea

Let's commit this change quickly:

	git add .gitignore
	git commit -m "Adding folders to the ignore list"

From a folder perspective I like to create a distribution folder and an app folder to hold the source, so let's go ahead and add these folders as well.

	mkdir app
	mkdir dist

We'll start by using bower to grab some of our front end dependencies. Let's start by creating a bower.json file by typing: `bower init`, fill in the details as you see fit, but here's what I selected:

	{
  		name: 'weatherly',
  		version: '0.0.0',
  		authors: [
    		'Greg Stewart <gregs@tcias.co.uk>'
  		],
  		description: 'Building a web app guided by tests',
  		moduleType: [
    		'amd'
  		],
  		license: 'MIT',
  		homepage: 'http://www.tcias.co.uk/',
  		private: true,
  		ignore: [
    		'**/.*',
    		'node_modules',
    		'bower_components',
    		'test',
    		'tests'
  		]
	}

Everybody likes a bit of Bootstrap so let's start with that package :

	bower install bootstrap --save

The `--save` flag at the end of the command means that the dependecy will be added to our bower.jon file. We are doing this because we do not want to check in any external dependencies into our repository. Instead at build/CI time we'll restore these using bower.

So let's edit our .gitignore file to make sure we don't accidentally commit these files:

	node_modules
	.idea
	bower_components

And let's add this change to our repo:

	git add .gitignore
	git commit -m "Adding bower_components to the ignore list"

To round things off let's install HTML5 boilerplate

	bower install html5-boilerplate

You may have noticed that I decided not to add this package to our bower.json file, simply because we'll copy the files we need into our app folder:

	mv bower_components/html5-boilerplate/css app/
	mv bower_components/html5-boilerplate/img app/
	mv bower_components/html5-boilerplate/*.html app/
	mv bower_components/html5-boilerplate/*.png app/
	mv bower_components/html5-boilerplate/*.xml app/
	mv bower_components/html5-boilerplate/*.ico app/
	mv bower_components/html5-boilerplate/*.txt app/

In your favourite editor open up the app/index.html file and add the following:

	<!DOCTYPE html>
	<!--[if lt IE 7]>      <html class="no-js lt-ie9 lt-ie8 lt-ie7"> <![endif]-->
	<!--[if IE 7]>         <html class="no-js lt-ie9 lt-ie8"> <![endif]-->
	<!--[if IE 8]>         <html class="no-js lt-ie9"> <![endif]-->
	<!--[if gt IE 8]><!--> <html class="no-js"> <!--<![endif]-->
    	<head>
        	<meta charset="utf-8">
        	<meta http-equiv="X-UA-Compatible" content="IE=edge">
        	<title>Weatherly - Forecast for London</title>
        	<meta name="description" content="">
    	    <meta name="viewport" content="width=device-width, initial-scale=1">

	        <!-- Place favicon.ico and apple-touch-icon.png in the root directory -->

        	<link rel="stylesheet" href="css/main.css">
    	</head>
    	<body>
        	<!--[if lt IE 7]>
            	<p class="browsehappy">You are using an <strong>outdated</strong> browser. Please <a href="http://browsehappy.com/">upgrade your browser</a> to improve your experience.</p>
        	<![endif]-->

        	<!-- Add your site or application content here -->
        	<div class="container">
            	<div class="header">
                	<ul class="nav nav-pills pull-right">
                    	<li class="active"><a href="#">Home</a></li>
                    	<li><a href="#">About</a></li>
                   		<li><a href="#">Contact</a></li>
                	</ul>
                	<h3 class="text-muted">test</h3>
            	</div>

            	<div class="jumbotron">
                	<h1>London Right Now</h1>
                	<p class="temperature">14 degrees</p>
                	<p>Mostly cloudy - feels like 14 degrees</p>
            	</div>

            	<div class="row marketing">
                	<div class="col-lg-6">
                    	<h4>NEXT HOUR</h4>
                    	<p>Mostly cloudy for the hour.</p>

                    	<h4>NEXT 24 HOURS</h4>
                   		<p>Mostly cloudy until tomorrow afternoon.</p>
                	</div>
            	</div>

            	<div class="footer">
                	<p><span class="glyphicon glyphicon-heart"></span> from Weatherly</p>
            	</div>

        	</div>
        	<p></p>

        	<script src="//ajax.googleapis.com/ajax/libs/jquery/1.10.2/jquery.min.js"></script>
        	<script>window.jQuery || document.write('<script src="js/vendor/jquery-1.10.2.min.js"><\/script>')</script>

        	<!-- Google Analytics: change UA-XXXXX-X to be your site's ID. -->
        	<script>
            	(function(b,o,i,l,e,r){b.GoogleAnalyticsObject=l;b[l]||(b[l]=
                   	 function(){(b[l].q=b[l].q||[]).push(arguments)});b[l].l=+new Date;
                	e=o.createElement(i);r=o.getElementsByTagName(i)[0];
                	e.src='//www.google-analytics.com/analytics.js';
                	r.parentNode.insertBefore(e,r)}(window,document,'script','ga'));
            	ga('create','UA-XXXXX-X');ga('send','pageview');
        	</script>
    	</body>
	</html>

If you open up the file in your browser you should see something like this hopefully:

![Rendered HTML](/images/book-assets/Screenshot_2014-06-18_23.19.42.png)

Not exactly something to write home about, but it's enough for us to get started setting up our little server, writing a functional test and deploying something to our Heroku instance.

We'll make this a lot prettier later on in the book when we deal with setting up Grunt to build our JavaScript and CSS assets.

The last thing we'll do is commit all of our changes to our local repos:

	git add .
	git commit -m "Added Bootstrap/Modernizr to bower.json, moved the skeleton of the HTML5 boilerplate to the app folder and created a base index page for our weather forecat app."

At this stage it's a good idea to also push the changes to our remote repository. If you have followed the [What you will need section]("What you will need section"), you will hopefully have created a Github account. If not go ahead and to that now. Then create a repository called weatherly, here's what I entered:

![Creating your weatherly repository](/images/book-assets/Screenshot_2014-06-18_23.35.50.png)

To push our changes to the remote repository, you will need to tell your local repo where it is:

	git remote add origin https://github.com/<account_name>/weatherly.git

Now you can push your changes:

	git push -u origin master

##Recap##
Before we move on let's just quickly recap what we have done so far:

* created our app folder structure
* initialised our git repo
* created a Git ignore file
* used bower to manage some of our front end dependencies:
	* Bootstrap
	* Modernizr
	* HTML5 boilerplate
* created a very basic index.html page
* pushed all of the changes to our remote git repository

* * *

You can read the full book over at [GitBook](https://www.gitbook.io/book/gregstewart/modern-web-app-development) or
[LeanPub](https://leanpub.com/building-a-web-app-guided-by-tests/). Updated content for this chapter can be found on
[GitHub](https://github.com/gregstewart/book/blob/master/manuscript/chapter2.md).

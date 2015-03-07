---
layout: post
title: "working with function arguments"
date: 2015-03-07 19:39:11 +0000
comments: true
categories: javascript, function, arguments
---

This week I was working on some build tasks to daemonise some of the services we intend to use for our project. I decided to use [forever](https://github.com/foreverjs/forever) for this and ended up with a call that looks something like this:

	let task = execForeverCommand('start', 'path/to/service');

or

	let task = execForeverCommand('start', 'path/to/service', 'some', 'other', 'option');


The `execForeverCommand` would build up a command to execute based off of this variable length list of function arguments by concatenating them into one single string. What foolows are three different approaches to working with function arguments. 

My initial intention was to just use `arguments.join(" ")`; however function arguments are not an array but [an Array like object](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Functions/arguments). My first stab at solving this, was using a for-in loop:

	function execForeverCommand() {
		let commands = '';
		for (var argument in arguments) {
			if(arguments.hasOwnProperty(argument)) {
				commands += ' ' + arguments[argument];
			}
		}
	
		return shell.task('./node_modules/forever/bin/forever ' + commands);
 	}

That worked. Having a working solution, I spent some time reading through the [MDN post](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Functions/arguments) I referenced above in more detail and I realised that I could change it to use `Array.prototype.slice.call` and combine that with my initial plan:

	function execForeverCommand() {
		let commands = Array.prototype.slice.call(arguments).join(" ");
 
		return shell.task('./node_modules/forever/bin/forever ' + commands);
 	}
 	
Those folks who are astute might have spotted the use of `let` in these functions. On this project we are using ES6 features (with the assistance of [Babel](https://babeljs.io/)). ES6 allows us to use a third option: [Rest Parameters](http://tc39wiki.calculist.org/es6/rest-parameters/). Thanks to rest parameters I rewrote the function one last time, basically going full circle and implementing the solution with my original plan, by using `Array.prototype.join()`.:

	function execForeverCommand(...commands) {
		return shell.task('./node_modules/forever/bin/forever ' + commands.join(" "));
 	}
 	
 
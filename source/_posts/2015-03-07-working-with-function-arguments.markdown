---
layout: post
title: "working with function arguments"
date: 2015-03-07 19:39:11 +0000
comments: true
categories: javascript, function, arguments
---

LAst week I was working on build tasks to daemonise some of the services we intend to use for our project. I decided to use [forever](https://github.com/foreverjs/forever) and ended up with a call that looks something like this:

	let task = execForeverCommand('start', 'path/to/service');

or

	let task = execForeverCommand('start', 'path/to/service', 'some', 'other', 'option');


The `execForeverCommand` would build up a command to execute by concatenating a variable length list of function arguments into one single string. What follows are three different approaches I took to build up that string based off of those arguments. 

My initial intention was to just use `arguments.join(" ")`; however function arguments are not an array, instead they are [an Array like object](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Functions/arguments), therefore I opted to use a for-in loop:

	function execForeverCommand() {
		let commands = '';
		for (var argument in arguments) {
			if(arguments.hasOwnProperty(argument)) {
				commands += ' ' + arguments[argument];
			}
		}
	
		return shell.task('./node_modules/forever/bin/forever ' + commands);
 	}

That worked, but is very verbose. Having a working solution, I spent some time reading through the [MDN article](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Functions/arguments) I referenced above in more detail. I straight away realised that I could change the code to use `Array.prototype.slice.call` and combine that with my initial plan:

	function execForeverCommand() {
		let commands = Array.prototype.slice.call(arguments).join(" ");
 
		return shell.task('./node_modules/forever/bin/forever ' + commands);
 	}
 	
Now those astute readers might have spotted the use of `let` in these functions. On this project we are using ES6 features (with the assistance of [Babel](https://babeljs.io/)). This gave me a third option: [Rest Parameters](http://tc39wiki.calculist.org/es6/rest-parameters/). Thanks to rest parameters I rewrote the function one last time, effetively going full circle and implementing my originally intended solution, i.e. by using `Array.prototype.join()`.:

	function execForeverCommand(...commands) {
		return shell.task('./node_modules/forever/bin/forever ' + commands.join(" "));
 	}
 	

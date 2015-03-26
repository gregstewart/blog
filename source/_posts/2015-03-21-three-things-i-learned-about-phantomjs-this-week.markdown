---
layout: post
title: "three things I learned about PhantomJs this week"
date: 2015-03-21 14:27:19 +0000
comments: true
categories: javascript, testing, user journey tests, end to end tests, phantomjs, CORS
---
This week we had a bit of a *fun* moment with one of our feature tests. As a little background we are using a combination of [PhatomJs](http://phantomjs.org/), [Cucumber.js](https://github.com/cucumber/cucumber-js) and [WebDriver.io](http://webdriver.io/) for our end to end/user journey tests. 

One test failed repeatedly when we used to PhantomJs but if we switched to Chrome it would pass. The test itself was sending an Async POST request to an API and then based on the response the browser would redirect to the created resource (well it did more, but that was the basic premise). 

After some head scratching and painful debugging we eventually narrowed it down to our `Location` header disappearing from the API response. We initially thought this might be a bug in PhantomJs, because we could clearly see the server sending the header and in the debug tools it would show up as well; however it turns out that this is PhantomJs' security model. By default PhatomJs only handles '*standard*' headers. Apparently `Location` isn't one of them. The solution in the end is quite simple, simply start PhatomJs with the `--web-security` flag set to `false`: `./node_modules/.bin/phantomjs --web-security=false`

Note that this also turns off SSL certificate checking, but since we are using this for test purposes we are fine. Your mileage may vary though depending on what you are using PhantomJs for.

The other thing I learned during this episode was that there is no need to use or install the Selenium stand alone server as you can launch PhantomJs with webdriver support (in the shape of [GhostDriver](https://github.com/detro/ghostdriver) I believe): `./node_modules/.bin/phantomjs --webdriver=4444`

To debug the test we used the following flag, which allows you to then remote debug using a browser and the [web inspector interface](https://www.webkit.org/blog/1620/webkit-remote-debugging/): `./node_modules/.bin/phantomjs --remote-debugger-port=9000`

Open the browser and go to `http://localhost:9000` and you will be presented with a list of PhantomJs sessions. By selecting one you can start your debugging. 

So there you are three things I learned about PhantomJs.

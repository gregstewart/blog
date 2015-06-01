---
layout: post
title: "Are you using docker?"
date: 2015-05-14 21:54:43 +0100
comments: true
categories: ci, development, docker, immutable, infastructure
---
Are you using [Docker](https://www.docker.com/) for development? For continous integration? For deployment? No? Why not? This is not an inflamatory question, I am genuinely interested in hearing why you would not embrace containers.

##Development

We have been using Docker on our most recent project and it's been an awesome experience. I am sure you have experienced this at least once on every porject:

![Works on my machine](http://cdn.meme.am/instances/500x/48009108.jpg)

Using containers has almost completely eliminated the old adage `but it works on my machine` and any issues encountered so far have usually been resolved by installing dependencies after a pull.

![Clueless](http://cdn.meme.am/instances/500x/55497481.jpg)

Getting new team members onboarded is incredibly efficient as well: check the repo out, run `npm i` and our `docker run` script and you are up and running. This alone should convince you to use Docker now. The days of spending hours tinkering with the setup, debugging and pouring over out dated documentation are numbered! If are still not convinced about using Docker in your development environment, do yourself a favour at a bare minimum invest time exploring it.

##CI

Ok so your dev machine setup and environment differences are basically eliminated. What about gettign ready for deployment? Using this configuration, you can now confidently and easily build your code/app on your CI sever as well. No need for extra configurations between CI and dev, it's the same container. Always want a clean base line for each build? Yout got it, since on re-build, your whole stack is clean with each build. Sure it adds a little time to your build, however I think the extra couple of minutes it takes to re-build the container and push it to a registry after a successful build, are definitely worth it. 

At time of writing it takes us from merging a Pull Request 8 minutes to build, test and deploy to AWS. Granted your mileage may vary but to give you some idea we run some 200 unit tests, 30 integration tests and 10 feature tests (and yes we need to improve our coverage...) and it's all written in Node.js. 

![](http://cdn.meme.am/instances/500x/59833717.jpg)

Another thing to consider is: does your CI environment not support your language of choice for development? Containers can help here as well. Run `docker exec` and execute your tests inside of the container.

##Application deployment

Your dev envinronment is consistent, your build is consistent and now we come to the top of the chain: deploying your application. 

So far I have avoided using [Immutable Infrastructure](https://highops.com/insights/immutable-infrastructure-6-questions-6-experts/) to describe containerisation, but it is the key here. A quick search for Immutable Infrastructure throws up tons of results, maybe just the sign of a fad, but I believe there is so much more to it. The focus is on dev ops in a lot of these posts and rightfully so; however being able to develop against what will be in production, then confidently, reliably and repeatedly build and deploy your application and environment is no longer a pipe dream. 

![](http://www.quickmeme.com/img/91/91937cf37ba5d6727302ec24851b9a1ff46ae5cdaf1578b7bc7dc2c31a7746b5.jpg)

All configuration is held in one place, so spinning up new instances to support increased demand is now so much easier, than any other provisioning mechanism I have seen. Check out this video:

[![Docker On Diego](http://img.youtube.com/vi/e76a50ZgzxM/0.jpg)](https://www.youtube.com/watch?v=e76a50ZgzxM)

> In a similar veing Blue/green deployments have never been easier either.

##Is it perfect?

Well truth be told: No not yet... Variance still exists after all the container has to run on some machine in some data center. Docker on Windows and OS X has a few kinks and runs inside a VM. We have come across a few issues, dealing with the file system (watching for file changes in development and read/writes across shared volumes on the host and containers). DNS going walk about on the host VM have also plagued each of us at least once on this project.

Given that the code runs inside of a container, debugging has had a few challenges. Having said that it pushed a focus on logging to the start of the cycle rather than leaving it to later stages.

So there are a few issues, but this should not deter you from seriously looking into using Docker. 

---
layout: post
title: "Are you using docker?"
date: 2015-06-07 22:51:43 +0100
comments: true
categories: ci, development, docker, immutable, infastructure
---
Are you using [Docker](https://www.docker.com/) for development? For continous integration? For deployment? No? Why not? This is not an inflamatory question, I am genuinely interested in hearing why you would not embrace Docker or more broadly speaking: containers.

##Development

We have been using Docker on our most recent project and it's been an awesome experience. I am sure you have experienced this at least once on every porject:

![Works on my machine](http://cdn.meme.am/instances/500x/48009108.jpg)

Using containers has almost completely eliminated the old adage `but it works on my machine`. Eliminating any kind of variance in developer machine setup is the key here and by adopting containers we are very close to almost having next zero variance. I say next to zero, because the hardware is likely to still be different; however the in terms of dependencies and system configruation we have eliminated the variance. All configuration for the conatiner resides in our repository and any issues encountered so far have usually been resolved by installing dependencies after a pull or updating the container by executing the build command.

![Clueless](http://cdn.meme.am/instances/500x/55497481.jpg)

Getting new team members onboarded is incredibly efficient as well: check the repo out, run `npm i` (install dependencies) and our `docker run` script (build the container) and you are up and running. I think this alone should convince you to use Docker now. The days of spending hours tinkering with the setup, debugging and pouring over out dated documentation are numbered!

##CI

So your devevelopment machine setup and environment differences are basically eliminated. What about getting ready for deployment? Using this configuration, you can now confidently and easily build your code/app on your CI sever as well. No need for extra configurations between CI and dev environments, it's the same container. Always want a clean base line for each build? Yout got it, since on re-build, your whole stack is clean with each build. Sure it adds a little time to your build, however I think the extra couple of minutes it takes to re-build the container and push it to a registry after a successful build, are definitely worth it. 

At time of writing, it takes us from merging a Pull Request 8 minutes to build, test and deploy to AWS. Granted your mileage may vary but to give you some idea we run some 200 unit tests, 30 integration tests and 10 feature tests (and yes we need to improve our coverage...) and it's all written in Node.js. 

![Continuous delivery](http://cdn.meme.am/instances/500x/59833717.jpg)

Another thing to consider is: does your CI environment not support your language of choice to build your product(s)? Containers can help here as well.

##Application deployment

Your dev envinronment is consistent, your build is consistent and now we come to the top of the chain: deploying your application. 

![Dev ops problem now](http://www.quickmeme.com/img/91/91937cf37ba5d6727302ec24851b9a1ff46ae5cdaf1578b7bc7dc2c31a7746b5.jpg)

So far I have avoided using [Immutable Infrastructure](https://highops.com/insights/immutable-infrastructure-6-questions-6-experts/) to describe containerisation, but it is another key aspect here. A quick search for Immutable Infrastructure throws up tons of results, maybe just the sign of a fad, but I believe there is so much more to it. The focus is on dev ops in a lot of these posts and rightfully so; however I think the chaps over at [CodeShip some up the points best](https://blog.codeship.com/immutable-infrastructure/). 

* start every build and deployment from a clean slate
* replace rather than update
* use base images
* state isolation
* atomic deployments

So being able to develop against what will be in production, then confidently, reliably and repeatedly build and deploy your application and environment is no longer a pipe dream. 

All configuration is held in one place, so spinning up new instances to support increased demand is now so much easier, than any other provisioning mechanism I have seen. Just check out this video:

[![Docker On Diego](http://img.youtube.com/vi/e76a50ZgzxM/0.jpg)](https://www.youtube.com/watch?v=e76a50ZgzxM)

In a similar managing and moving toward Blue/green deployments has also never been easier either, especially when you add to it the tooling behind AWS.

##Is it perfect?

Well truth be told: No. Not yet at least... As I mentioned variance still exists; after all the container has to run on some machine in some data center. Docker on Windows and OS X has a few kinks and runs inside a VM. We have come across a few issues, dealing with the file system (watching for file changes in development and read/writes across shared volumes on the host and containers). DNS going walk about on the host VM have also plagued each of us at least once on this project.

Given that the code runs inside of a container, debugging has had a few challenges. Having said that it pushed a focus on logging to the start of the cycle rather than leaving it to later stages.

So there are a few issues, but this should not deter you from seriously looking into using Docker. 

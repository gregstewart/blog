---
layout: post
title: "Are you using docker?"
date: 2015-05-14 21:54:43 +0100
comments: true
categories: ci, development, docker, immutable, infastructure
---
Are you using [Docker](https://www.docker.com/) for development? For continous integration? For deployment? No? Why not? This is not an inflamatory question, I am genuinely interested in hearing why you would not embrace containers??

** Application deployment **

Let's start at the top of the chain deploying your application. [Immutable Infrastructure](https://highops.com/insights/immutable-infrastructure-6-questions-6-experts/) is the key here. A quick search for Immutable Infrastructure throws up tons of results, maybe just the sign of a fad, but I believe there is so much more to it. The focus is on dev ops in a lot of these posts and rightfully so. However being able to confidently, reliably and repeatedly build and deploy your application and environment is no longer a pipe dream. 

![](http://s.quickmeme.com/img/e3/e3cff629826455f00a5f94e29d00aa0725e1a1266e83db81b0aebcef03a61eff.jpg)

All configuration is held in one place.

Blue/green deployments have never been easier

** CI **

Ok so you can confidently deploy your environment to your target environment... guess what? You can confidently build your code to your CI environment now as well. No need for extra configurations between CI and production, it's the same container. Always want a clean base line for each build? Yout got it, since you re-build you can rebuild your whole stack with each build. Sure it adds a little time to your build, however I think the extra couple of minutes it takes to re-build the container and push it to a registry on a successful build are worth it. At time of writing it takes us from merging a Pull Request 8 minutes to build, test and deploy to AWS. 

![](http://cdn.meme.am/instances/500x/59833717.jpg)

Another thing to consider is: does your CI environment not support your language of choice for development? Containers can help here as well. `docker exec` and run your tests on the container.

** Development **

We have been using Docker on our most recent project and it's a game changer. I am sure you have experienced this at least once on every porject:

![Works on my machine](http://cdn.meme.am/instances/500x/48009108.jpg)

Using containers has almost completely eliminated the old adage `but it works on my machine` and any issues encountered so far have usually been resolved by installing dependencies after an update.

![Clueless](http://cdn.meme.am/instances/500x/55497481.jpg)

Getting new team members onbaorded is incredibly efficient: checkout the repo, `npm i` and our `docker run` script and you are up and running. This alone should convince you to use Docker now. The days of spending hours tinkering with the setup, debugging and poring over out dated documentation are numbered! If are still not convinced about using Docker in your development envinronment, do yourself a favour at a bare minimum invest time exploring it.

** Is it perfect? **

No not yet... Variance still exists after all the container has to run on some machine in some data center. Docker on Windows and OS X has a few kinks and runs inside a VM. We have come across a few issues, dealing with the file system (watching for file changes in development and read/writes across shared volumes on the host and containers). DNS going walk about on the host VM have also plagued each of us at least once on this project.
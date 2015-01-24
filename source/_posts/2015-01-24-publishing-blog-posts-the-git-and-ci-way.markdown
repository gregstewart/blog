---
layout: post
title: "publishing blog posts the git and ci way"
date: 2015-01-24 16:50:53 +0000
comments: true
categories: blogging, automation, ci, github, pull requests, codeship
---
I recently switched over the source control of my blog from Bitbucket to Github. I wanted to try out a new workflow with
regards to publishing. As I tend to create a new git branch for each post I am working on, I wanted to use the pull
request approach to publishing posts (like those wonderful folks over at ThoughtBot for example). Now granted I am not
exactly collaborating with others on posts, I still find this `review` process handy. Reading the post in a different
context has been truly been beneficial, furthermore I now tend to give myself a few days between writing and actually
posting as a result of this process. Using Github and their editor I can review, re-read and edit posts at my convenience. S
o far so good.

This got me thinking though are there any other improvements I could make to my workflow... Well yes there are actually.
As I mentioned I tend to create a branch for each post and running the new post rake task. I started by modifying the
tasks for posts and pages to create a new branch for me using the title. However then I realised I could take it even
further, create an initial commit and create a new tracked remote branch. Here's what that looks like:

    blog git:(change-workflow) rake 'new_post[test branch]'
    mkdir -p source/_posts
    Creating new post: source/_posts/2015-01-24-test-branch.markdown
    Switched to a new branch 'test-branch'
    [test-branch c5c786a] created new post entry: test-branch
    2 files changed, 8 insertions(+), 4 deletions(-)
    create mode 100644 source/_posts/2015-01-24-test-branch.markdown
    Counting objects: 8, done.
    Delta compression using up to 4 threads.
    Compressing objects: 100% (8/8), done.
    Writing objects: 100% (8/8), 801 bytes | 0 bytes/s, done.
    Total 8 (delta 6), reused 0 (delta 0)
    To git@github.com:gregstewart/blog.git
    * [new branch]      test-branch -> test-branch
    Branch test-branch set up to track remote branch test-branch from origin.

The next thing I wanted to improve upon was the publishing step. Given I am now using Pull Requests and can use Github
to sign off on these, then why not use CI to build and publish the Blog on merge to Master? So I created a new project
over at [CodeShip](https://codeship.com/), left the test settings empty, but under deployment added:

    bundle exec rake generate
    bundle exec rake deploy

Now whenever I merge a pull request, CI takes over and publishes my post to my server!
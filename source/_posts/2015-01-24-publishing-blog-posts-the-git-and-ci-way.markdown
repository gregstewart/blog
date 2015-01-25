---
layout: post
title: "publishing blog posts the git and ci way"
date: 2015-01-24 16:50:53 +0000
comments: true
categories: blogging, automation, ci, github, pull requests, codeship
---
I recently switched over the source control of my blog from [Bitbucket](https://bitbucket.org/) to [Github](https://github.com/), because I wanted to try out a new workflow with regards to editing and publishing posts. 

As I tend to create a new git branch for each post I am working on, I wanted to use the [pull request](https://help.github.com/articles/using-pull-requests/) approach to publishing postsI first came across this idea, thanks those wonderful folks over at [ThoughtBot](http://playbook.thoughtbot.com/). Now granted I am not collaborating with others on posts; however I still find this `review` process handy. Reading the post in a different context has been beneficial. Furthermore I now tend to give myself a few days between writing and posting as a result of this process. Using Github and [their editor](https://github.com/blog/1379-zen-writing-mode) I can review, re-read and edit posts at my convenience. So far it's worked well for me.

This got me thinking though: are there any other improvements I could make to my workflow... Well yes there are. As I mentioned I tend to create a branch for each post, followed by running the new post rake task. I started by modifying the tasks for posts and pages to create a new branch for me using the title. Then I realised I could take it even further, create an initial commit and create a new tracked remote branch. Here's what the output looks like:

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
    
The code for this is pretty straight forward and not foolproof, but a good starting point:

    # create git branch
    def create_branch(branch_name)
        exec "git checkout -b #{branch_name}; git add .; git commit -m 'created new post entry: #{branch_name}'; git push -u origin #{branch_name}"
    end

The next thing I wanted to improve upon was the publishing step. Commit/Push/Generate and Deploy were the steps I used in the past, a bit long winded and repetitive. Also if I was not at home, then I had to wait to publish an update. Given how I am now using Pull Requests and use Github to sign off on and merge these, why not use CI to build and publish the Blog on merge to `master`? So I created a new project over at [CodeShip](https://codeship.com/), left the test settings empty, but under deployment added:

    bundle exec rake generate
    bundle exec rake deploy

Now whenever I merge a pull request, CI takes over and publishes my post to my server! Note that, if like me you use rsync, you will need to add [CodeShips public key](https://codeship.com/documentation/continuous-integration/where-can-i-find-the-ssh-public-key-for-my-project/) to your `authorized_keys` in order for [Octopress' rsync](http://octopress.org/docs/deploying/rsync/) publishing to work. This post is the first to feature this new workflow!

_Update: it turns out you can complete this workflow using Bitbucket as well!_

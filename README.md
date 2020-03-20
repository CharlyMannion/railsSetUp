# Rails Set Up

A guide to setting up a basic Ruby on Rails Web Application, following a TDD approach

## Instructions

### Step 1 - basic set up

* cd in to the directory
* run `rails new railsSetUp -T`, replacing railsSetUp with whatever you want the directory to be called. The `-T` command skips setting up the test suite, as we will be using RSpec and Capybara
* cd in to the directory `cd railsSetUp`
* initialize git `git init`
* Make an empty repository on your github page, with the same name as the local repository
* merge the two: `git remote add origin [insert github url here]`
* commit and push changes
`git add .`
`git commit -m "first commit"`
`git push -u origin master`

### Step 2 - Gemfile
* copy the Gemgile in this repository, found here https://github.com/CharlyMannion/railsSetUp/blob/master/Gemfile

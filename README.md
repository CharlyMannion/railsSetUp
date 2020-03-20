# Rails Set Up

A guide to setting up a basic Ruby on Rails Web Application, following a TDD approach

## Instructions

### Step 1 - basic set up

* Navigate to the directory where you want the rails app to be kept
* Run `rails new railsSetUp -T`, replacing railsSetUp with whatever you want the directory to be called. The `-T` command skips setting up the test suite, as we will be using RSpec and Capybara
* Navigate to the directory `cd railsSetUp`
* Initialize git `git init`
* Make an empty repository on your github page, with the same name as the local repository
* Merge the two: `git remote add origin [insert github url here]`
* Commit and push changes
`git add .`
`git commit -m "first commit"`
`git push -u origin master`

### Step 2 - Gemfile
* Copy the Gemgile in this repository, found here: https://github.com/CharlyMannion/railsSetUp/blob/master/Gemfile
* Check you're using the latest versions of RSpec and Capybara
* `bundle`

### Step 3 - RSpec
* Run `rails g` to see the list of RSpec commands
* Run the command `rails g rspec:install` to set up the bare bones spec directory for the rails app
* Open up spec/rails_helper.rb and copy this repository's content, which can be found here: https://github.com/CharlyMannion/railsSetUp/blob/master/spec/rails_helper.rb
* Open .rspec, delete it's content and copy this repository's .rspec contents, which can be found here: https://github.com/CharlyMannion/railsSetUp/blob/master/.rspec
* Run `rake` and make sure the test suite is green, but without any examples
* Commit to Github at this stage

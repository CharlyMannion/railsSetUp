# Rails Set Up

A guide to setting up a basic Ruby on Rails Web Application, following a TDD approach.

This guide provides instructions for creating an app that lets a user add post to a web page.

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
* Note: there is some hashed out code enabling Features which may be required later
* Open .rspec, delete it's content and copy this repository's .rspec contents, which can be found here: https://github.com/CharlyMannion/railsSetUp/blob/master/.rspec
* Run `rake` and make sure the test suite is green, but without any examples
* Commit to Github at this stage

### Verify that rails is running (smoke test)
* write a test for visiting the homepage. An example of this can be found here: https://github.com/CharlyMannion/railsSetUp/blob/master/spec/user_visits_homepage_spec.rb
* run all tests in the test suite `rake`
* Boot up the app locally `rails server`
* Visit http://localhost:3000/
* Pass the test
* Open config/routes.rb, and add the route to the homepage with the following code
`Rails.application.routes.draw do
  root to: "todos#index"
end`
* An example of the routes used in a Todo app can be found hashed out at the bottom of this file: https://github.com/CharlyMannion/railsSetUp/blob/master/config/routes.rb
* `rake`
* You should get an error: `uninitialized constant PostsController`
* Create the controller (in this example, the controller is called posts):
`touch app/controllers/posts_controller.rb`
* Find the PostController example document here: https://github.com/CharlyMannion/railsSetUp/blob/master/app/controllers/posts_controller.rb
* Create the template (view)
`mkdir app/views/posts`
`touch app/views/posts/index.html.erb`
* Open up app/views/layouts/application.html.erb and add the h1 css tag
`<h1>Checking the Root</h1>`
* Find the application view example here: https://github.com/CharlyMannion/railsSetUp/blob/master/app/views/layouts/application.html.erb
* Run `rake` and the entire test suite should be green

### Creating the first Post
* Create a new spec for creating a post:
`mkdir spec/features`
 `touch spec/features/user_creates_post_spec.rb`. See the example here: https://github.com/CharlyMannion/railsSetUp/blob/master/spec/features/user_creates_post_spec.rb
 * Run the test `rspec ./spec/features/user_creates_post_spec`
 * Open views/posts/index.html.erb and add the code required to make the test pass. The example can be found here: https://github.com/CharlyMannion/railsSetUp/blob/master/app/views/posts/index.html.erb
 * Add the path to config/routes.rb
 `resources :posts, only: :new`
 * You should be seeing this error: `The action 'new' could not be found
for PostsController`
* Add the new route to the posts controller, which will now look like this:
```
class PostsController < ApplicationController
  def index
  end

  def new
  end
end
```
* The new error will be `PostsController#new is missing a template for request formats: text/html`
* Create the template `touch app/views/posts/new.html.erb`
* New error: `Unable to find visible field "Title"
 that is not disabled`
* Generate the model `rails g model Post title`
* Open app/views/posts/new.html.erb, and add the following code to render the form:
```
<%= form for @post do |form| %>
  <%= form.label :title %>
  <%= form.text_field :title %>
<% end %>
```
* New error: `Migrations are pending. To resolve this issue, run: rails db:migrate RAILS_ENV=test
No examples found.`
* So, run `rake db:migrate`
* New erorr: `First argument in form cannot contain nil or be empty`. This means @post is nil
* Update the new method in PostController
```
def new
  @post = Post.new
end
```
* New error: `undefined method 'posts_path'`
* Add create to the resources in routes.rb
`resources :posts, only: [:new, :create]`
* New error: `Unable to find visible link or button "Submit"`
* Add the submit button to the new form:
```
<%= form_for @post do |form| %>
  <%= form.label :title %>
  <%= form.text_field :title %>
  <p>
    <%= form.submit "Submit" %>
  </p>
<% end %>
```
* New error: `The action 'create' could not be found
 for PostsController`
 * Add the create route to the PostsController
 ```
 def create
   redirect_to posts_path
 end
 ```
* Add index to the list of actions
`resources :posts, only: [:index, :new, :create]`
* New error: `Failure/Error: expect(page).to have_css '.posts li', text: "My First Post" expected to find visible css ".posts li" with text "My First Post" but there were no matches`
* Build structure to create the post
* Open index.html.erb, add a list and iterate over the posts and render an li:
* New error: `undefined method 'each' for nil:NilClass`
* Update the index method in PostController
```
def index
  @posts = Post.all
end
```
* Update the create method in PostsController. The file should now like this:
```
class PostsController < ApplicationController
  def index
    @posts = Post.all
  end

  def new
    @post = Post.new
  end

  def create
    Post.create(post_params)
    redirect_to posts_path
  end

  private
  def post_params
    params.require(:post).permit(:title)
  end
end
```
* The test for this should now be passing
* Run `rake`: `3 examples, 0 failures, 1 pending`
* Remove spec/models.post_spec.rb
* The test suite will now be green
* Run `rails server` to sense check the app
* Commit the changes to git

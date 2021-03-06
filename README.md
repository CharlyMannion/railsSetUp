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

### Step 4 - Verify that rails is running (smoke test)
* write a test for visiting the homepage. An example of this can be found here: https://github.com/CharlyMannion/railsSetUp/blob/master/spec/user_visits_homepage_spec.rb
* run all tests in the test suite `rake`
* Boot up the app locally `rails server`
* Visit http://localhost:3000/
* Pass the test! See below:
* Open config/routes.rb, and add the route to the homepage with the following code
```
Rails.application.routes.draw do
  root to: "todos#index"
end
```
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

### Step 5 - Creating the first Post
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
* New error: `Unable to find visible field "Title" that is not disabled`
* Generate the model `rails g model Post title`
* Open app/views/posts/new.html.erb, and add the following code to render the form:
```
<%= form for @post do |form| %>
  <%= form.label :title %>
  <%= form.text_field :title %>
<% end %>
```
* New error: `Migrations are pending. To resolve this issue, run: rails db:migrate RAILS_ENV=test No examples found.`
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
* Commit and push the changes to git

### Step 6 Signing in and Post Ownership

* Open spec/features/user_creates_post_spec.rb, replace `visit /` with a call to a method `sign_in`, that we will define ourselves, that will be used during the scenario:
```
require "rails_helper"

feature "User visits homepage" do
  scenario "successfully" do
    sign_in
    expect(page).to have_css "h1", text: 'Checking the Root'
  end
end
```
* `rake` will show that the method is undefined
*  Create the spec in rspec:
`mkdir spec/support`
`mkdir spec/support/features`
`touch spec/support/features/sign_in.rb`
* In sign_in.rb (example found here: ):
```
module Features
  def sign_in
      visit root_path
      fill_in "Email", with: "person@example.com"
      click_on "Sign in"
  end
end
```
* Add a call to sign_in in the user_creates_post_spec.rb:
```
feature "User creates a post" do
  scenario "successfully" do
    visit "/"
    sign_in
    click_on "Add a new post"
    fill_in "Title", with: "My First Post"
    click_on "Submit"

    expect(page).to have_css '.posts li', text: "My First Post"
  end
end
```
* Open up spec/rails_helper.rb and uncomment the code at the bottom that enables features i.e. `config.include Features, type: :features`
* Also uncomment `Dir[Rails.root.join('spec', 'support', '**', '*.rb')].each { |f| require f }`
* The error should now be: `Unable to find visible field "Email" that is not disabled`
* Open up the posts controller and add the following line of code to the top of the class `before_action :authenticate`
* The error is now: `undefined method 'authenticate' for #<PostsController:0x00007fa211a86eb0>`
* Define the authenticate method and the signed_in? method in ApplicationController:
```
class ApplicationController < ActionController::Base
  def authenticate
    if !signed_in?
      redirect_to new_session_path
    end
  end

  def signed_in?
    false
  end
end
```
* New error: `undefined local variable or method `new_session_path'`
* Define the route:
`resource :session, only: :new`
* New error: `uninitialized constant SessionsController`
* `touch app/controllers/sessions_controller.rb`:
```
class SessionsController < ApplicationController
  def new
  end
end
```
* New error: `ActionController::MissingExactTemplate`
* Create the view:
`mkdir app/views/sessions`
`touch app/views/sessions/new.html.erb`
* New error: `Unable to find visible link or button "Add a new post"`
* Create the form for our session within new.html.erb:
```
<%= form_for :session, url: session_path do |form| %>
  <%= form.label :email %>
  <%= form.text_field :email %>
  <%= form.submit "Sign in" %>
<% end %>
```
* Add create to the list of resources in routes:
`resource :session, only: [:new, :create]`
* Define the create method in sessions controller:
```
class SessionsController < ApplicationController
  def new
  end

  def create
    redirect_to root_path
  end
end
```
* New error: `Unable to find visible link or button "Add a new post"`
* This is because signed_in? in ApplicationController currently always returns false. We need to change the logic to check to see if we know who the user is. Let us store the email in the session to solve this:
```
def signed_in?
  session[:current_email].present?
end
```
* We now need to save the email in the session at it's creation, in SessionsController:
```
def create
  session[:current_email] = params[:session][:email]
  redirect_to root_path
end
```

### Step 7: Add an email to the Post in the database
* We need to associate an email address to each post in the database in order to only display the Posts of the signed in user
* Create the migration adding email to posts:
* run `rails g migration add_email_to_todos`
* Open the migration (it will be in the app/db/migrate directory) and update the change method:
```
class AddEmailToTodos < ActiveRecord::Migration[6.0]
  def change
    add_column :posts, :email, :string
  end
end
```
* run `rake db:migrate`
* Add a new test to verify that we're scoping this correctly
* We will add a test that writes a post as a user, and check that the post does not show up when we sign in as a different user
* `touch spec/features/user_sees_own_posts_spec.rb'

``` require 'rails_helper'

feature "User sees own posts" do
  scenario "doesn't see others' posts" do
    Post.create!(title: "Day 8 in quarantine", email: "someoneelse@example.com")

    sign_in_as "someone@example.com"

    expect(page).not_to have_css ".posts li", text: "Day 8 in quarantine"
  end
end
```
* Add the sign_in_as method to spec/support/features/sign_in.rb:
```
module Features
  def sign_in
    sign_in_as "person@example.com"
  end

  def sign_in_as(email)
    visit root_path
    fill_in "Email", with: email
    click_on "Sign in"
  end
end
```
* Add the database cleaner gem to group test (it may already be in there if you have copied the gemfile example provided):
`  gem 'database_cleaner'`
* Configure database cleaner:
`touch spec/support/database_cleaner.rb`
```
RSpec.configure do |config|
  config.before(:suite) do
    DatabaseCleaner.clean_with(:truncation)
  end

  config.before(:each) do
    DatabaseCleaner.strategy = :transaction
  end

  config.before(:each, js: true) do
    DatabaseCleaner.strategy = :truncation
  end

  config.before(:each) do
    DatabaseCleaner.start
  end

  config.after(:each) do
    DatabaseCleaner.clean
  end
end
```
* Update the index method in PostController so only the Posts associated with the signed in user are displayed:
```
def index
  @posts = Post.where(email: session[:current_email])
end
```
* New error, when you run full rake: `Failure/Error: expect(page).to have_css '.posts li', text: "My First Post"`
* Add the email the creation of the Post:
```
def create
  Post.create(post_params.merge(email: session[:current_email]))
  redirect_to posts_path
end
```
* All the tests should now pass

### Step 8: Refactor the controllers:
* Firstly, we will refactor the controllers
* Add a current_email method to the Application controller that sets the current email in the session, then refactor the controllers to use calls to this method:
```
def current_email
  session[:current_email]
end

def signed_in?
  current_email.present?
end
```
* Update the SessionsController to use a signed_in_as method:
```
def create
  signed_in_as params[:session][:email]
  redirect_to root_path
end
```
* Define the signed_in_as method in ApplicationController:
```
def signed_in_as(email)
  session[:current_email] = email
end
```
### Step 9: Refactor to create a User model:
* It would be better if we could refer to and interact with a user, not as en email address, but as a User object
* Update the index method in PostsController to use a new object, current_user:
```
def index
  @posts = current_user.posts
end
```
* Update the create method in PostsController:
```
def create
  current_user.posts.create(post_params)
  redirect_to posts_path
end
```
* New error: `undefined local variable or method 'current_user'`
* We need to define the current_user, for now we will do this in ApplicationController:
```
def current_user
end
```
* New error: `undefined method 'posts' for nil:NilClass`
* We need to have current user return an object that has posts and can be interacted with. Update the method:
```
def current_user
  User.new(current_email)
end
```
* New error: `uninitialized constant ApplicationController::User`
* Define the User class: `touch app/models/user.rb`:
```
class User
  def initialize(email)
    @email = email
  end

  def posts
    Post.where(email: @email)
  end
end
```

### Step 10: Delete a Post:
* Start by writing a test for the deletion of a post:
`touch spec/features/user_deletes_post_spec.rb`:
```
require 'rails_helper'

feature "User deletes a post" do
  scenario "successfully" do
    sign_in
    click_on "Add a new post"
    fill_in "Title", with: "Post to delete"
    click_on "Submit"
    click_on "Destroy"

    expect(page).not_to have_css '.posts li', text: "Post to delete"
  end
end
```
* Update the posts view (app/views/posts/index.html.erb) to add a destroy button to each post:
```
<%= link_to "Add a new post", new_post_path %>

<ul class="posts">
  <% @posts.each do |post| %>
  <li>
    <%= post.title %>
    <%= link_to 'Destroy', post_path(post),
        method: :delete,
        data: { confirm: 'Are you sure?' } %>
  </li>
  <% end %>
</ul>
```
* Add the route to config/routes.rb:
```
resources :posts, only: [:index, :new, :create, :destroy]
```
* Add a destroy route method to PostsController:
```
def destroy
  @post = Post.find(params[:id])
  @post.destroy

  redirect_to posts_path
end
```

### Step 11: Update a Post
* Start by writing the spec `touch spec/features/user_updates_post_spec.rb`:
```
require 'rails_helper'

feature "User updates a post" do
  scenario "successfully" do
    sign_in
    click_on "Add a new post"
    fill_in "Title", with: "Post to edit"
    click_on "Submit"
    click_on "Edit"
    fill_in "Title", with: "Edited post"
    click_on "Submit"

    expect(page).to have_css '.posts li', text: "Edited post"
    expect(page).not_to have_css '.posts li', text: "Post to delete"
  end
end
```
* Create a form in views for editing a post `touch app/views/posts/edit.html.erb`:
```
<%= form_for @post, method: :patch do |form| %>
  <%= form.label :title %>
  <%= form.text_field :title %>
  <p>
    <%= form.submit "Submit" %>
  </p>
<% end %>
```
* Add a link to this form to the index view: `<%= link_to 'Edit', edit_post_path(post) %>`
* The index form will now look like this:
```
<% @posts.each do |post| %>
<li>
  <%= post.title %>
  <%= link_to 'Edit', edit_post_path(post) %>
  <%= link_to 'Destroy', post_path(post),
      method: :delete,
      data: { confirm: 'Are you sure?' } %>
```
* Write the methods for edit and update in the PostController:
```
def edit
    @post = Post.find(params[:id])
  end

  def update
  @post = Post.find(params[:id])
  if @post.update(post_params)
    redirect_to posts_path
  else
    render 'edit'
  end
end
```
* Update `config/routes.rb`:
```
resources :posts, only: [:index, :new, :create, :edit, :update, :destroy]
```

### Step 12 - Add user's identity to the Post
* Write test:
```
scenario "the user's name is on their post" do
  Post.create!(title: "Day 15 in quarantine", email: "someone@example.com")
  sign_in_as "someone@example.com"

  expect(page).to have_css ".posts li", text: "Day 15 in quarantine"
  expect(page).to have_content("someone@example.com")
end
```

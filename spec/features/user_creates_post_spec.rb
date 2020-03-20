require 'rails_helper'

feature "User creates a post" do
  scenario "successfully" do
    visit "/"
    click_on "Add a new post"
    fill_in "Title", with: "My First Post"
    click_on "Submit"
    
    expect(page).to have_css '.posts li', text: "My First Post"

    # later this will be refactored to:
    # sign_in
    # create_post("My First Post")
    # expect(page).to display_post "My First Post"
  end
end

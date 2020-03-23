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

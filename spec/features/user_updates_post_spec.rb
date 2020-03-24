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

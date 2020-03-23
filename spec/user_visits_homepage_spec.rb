require "rails_helper"

feature "User visits homepage" do
  scenario "successfully" do
    # visit "/"
    # you can also use:
    # visit root_path
    sign_in
    expect(page).to have_css "h1", text: 'Checking the Root'
  end
end

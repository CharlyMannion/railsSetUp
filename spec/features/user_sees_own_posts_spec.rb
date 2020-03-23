require 'rails_helper'

feature "User sees own posts" do
  scenario "doesn't see others' posts" do
    Post.create!(title: "Day 8 in quarantine", email: "someoneelse@example.com")

    sign_in_as "someone@example.com"

    expect(page).not_to have_css ".posts li", text: "Day 8 in quarantine"
  end
end

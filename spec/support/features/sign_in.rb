module Features
  def sign_in
      visit root_path
      fill_in "Email", with: "person@example.com"
      click_on "Sign in"
    # sign_in_as "person@example.com"
  end
  #
  # def sign_in_as(email)
  #   visit root_path
  #   fill_in "Email", with: email
  #   click_on "Sign in"
  # end
end

class User
  def initialize(email)
    @email = email
  end

  def posts
    Post.where(email: @email)
  end
end

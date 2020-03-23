class PostsController < ApplicationController
  before_action :authenticate

  def index
    @posts = Post.where(email: session[:current_email])
  end

  def new
    @post = Post.new
  end

  def create
    Post.create(post_params.merge(email: session[:current_email]))
    redirect_to posts_path
  end

  private
  def post_params
    params.require(:post).permit(:title)
  end
end

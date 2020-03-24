class PostsController < ApplicationController
  before_action :authenticate

  def index
    @posts = current_user.posts
  end

  def new
    @post = Post.new
  end

  def create
    current_user.posts.create(post_params)
    redirect_to posts_path
  end

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

  def destroy
    @post = Post.find(params[:id])
    @post.destroy

    redirect_to posts_path
  end

  private
  def post_params
    params.require(:post).permit(:title)
  end
end

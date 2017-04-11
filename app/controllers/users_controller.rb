class UsersController < ApplicationController

  before_action :find_user, only: [:dashboard, :show]
  before_action :find_movie, only: [:dashboard, :show]


  def index
    @users = User.all.order("created_at DESC").paginate(:page => params[:page], :per_page => 1)

  end

  def show
  end

  def dashboard
  end

  private

  def find_movie
    @movies = Movie.where(user_id: @user).order("created_at DESC").paginate(:page => params[:page], :per_page => 1)
  end

  def find_user
    if params[:id].nil?
      @user = current_user
    else
      @user = User.find(params[:id])
    end
  end
end

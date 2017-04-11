class MoviesController < ApplicationController
  before_action :authenticate_user!, exept: [:show]
  before_filter :require_permission
  before_action :find_user
  before_action :find_movie, only: [:show, :edit, :update, :destroy]

  def new
    @movie = @user.movies.new
  end

  def create
    @movie = @user.movies.new(movie_params)
    if @movie.save
      redirect_to user_movie_path(@user, @movie)
    else
      render 'new'
    end
  end

  def show
    @movies = Movie.where(podcast_id: @user).order("created_at DESC").reject { |e| e.id == @movie.id }
  end

  def edit
  end

  def update
    if @movie.update movie_params
      redirect_to user_movie_path(@user, @movie), notice: "Movie succesfully updated!"
    else
      render "edit"
    end
  end

  def destroy
    @movie.destroy
    redirect_to root_path
  end

  private

  def movie_params
    params.require(:movie).permit(:title, :description, :movie_logo, :video)
  end

  def find_user
    @user = User.find(params[:user_id])
  end

  def find_movie
    @movie = Movie.find(params[:id])
  end

  def require_permission
    @user = User.find(params[:user_id])
    if current_user != @user
      redirect_to root_path, notice: "Sorry, You haven't permission!"
    end
  end
end

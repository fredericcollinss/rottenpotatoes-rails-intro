class MoviesController < ApplicationController
  def movie_params
    params.require(:movie).permit(:title, :rating, :description, :release_date)
  end

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    # extract params
    @all_ratings = Movie.all_ratings
    @sort_option = params[:sort]
    @rating_options = params[:ratings]

    # fill the missing param from session if available
    if @sort_option.nil?
      @sort_option = session[:sort]
      if @sort_option
        flash.keep
        redirect_to movies_path(sort: @sort_option, ratings: @rating_options)
        return
      end
    end

    if @rating_options.nil?
      @rating_options = session[:ratings]
      if @rating_options
        flash.keep
        redirect_to movies_path(sort: @sort_option, ratings: @rating_options)
        return
      end
    end

    if @sort_option.nil? && @rating_options.nil?
      @movies = Movie.all
    elsif @sort_option && @rating_options.nil?
      @movies = Movie.order(@sort_option)
      session[:sort] = @sort_option
    elsif @rating_options && @sort_option.nil?
      @movies = Movie.where(rating: @rating_options.keys)
      session[:ratings] = @rating_options
    else
      @movies = Movie.where(rating: @rating_options.keys).order(@sort_option)
      session[:sort] = @sort_option
      session[:ratings] = @rating_options
    end

  end

  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully updated."
    redirect_to movie_path(@movie)
  end

  def destroy
    @movie = Movie.find(params[:id])
    @movie.destroy
    flash[:notice] = "Movie '#{@movie.title}' deleted."
    redirect_to movies_path
  end

end

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
    sort_option = params[:sort]
    @rating_options = params[:ratings]

    # store choices to season[]
    if sort_option.nil?
      sort_option = session[:sort]
    else
      session[:sort] = sort_option
    end

    if @rating_options.nil?
      @rating_options = session[:ratings]
    else
      session[:rating_options] = @rating_options
    end


    # query base on params
    @movies = if sort_option.nil? && @rating_options.nil?
                Movie.all
              elsif sort_option && @rating_options.nil?
                Movie.order(sort_option)
              elsif @rating_options && sort_option.nil?
                Movie.where(rating: @rating_options.keys)
              else
                Movie.where(rating: @rating_options.keys).order(sort_option)
              end

    # update column header
    @clicked_column = sort_option unless sort_option.nil?
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

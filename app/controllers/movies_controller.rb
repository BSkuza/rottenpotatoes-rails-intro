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
    @movies = Movie.all
    @all_ratings = Movie.getRatings
    
    #@ratings = @all_ratings
    session[:ratings] ||= @all_ratings
    session[:sortMovies] ||= 'id'
    
    if params[:sortMovies] == 'sortName'
      @movies = @movies.order(:title)
      session[:sortMovies] = :title
    end
    
    if params[:sortMovies] == 'sortRelease' 
      @movies = @movies.order(:release_date)
      session[:sortMovies] = :release_date
    end
    
    session[:ratings] = params[:ratings].keys if params[:ratings]
    @ratings = session[:ratings] if session[:ratings]
    #@sortMovies = session[:sortMovies]
    @movies = Movie.where(rating: @ratings).order(session[:sortMovies])
    
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

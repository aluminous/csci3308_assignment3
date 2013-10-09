class MoviesController < ApplicationController

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    # Load user preferences from session
    if session.key? :movies_filter
      filter = session[:movies_filter]
    else
      session[:movies_filter] = filter = {}
    end

    if (!params[:sortcol] and filter[:sortcol]) or
       (!params[:ratings] and filter[:ratings])
      # Redirect to include saved parameters in URL
      flash.keep
      return redirect_to movies_path(filter.update params)
    end

    # Sort and filter settings
    @sortcol = params[:sortcol]
    @all_ratings = Movie.list_ratings

    if !params.key? :ratings
      # By default, all ratings are selected (not filtered by rating)
      rating_pairs = @all_ratings.collect {|rating| [rating, 1]}
      @ratings = Hash[*rating_pairs.flatten]
    else
      @ratings = params[:ratings]
    end

    # Save user preferences
    filter[:sortcol] = @sortcol
    filter[:ratings] = @ratings

    @movies = Movie.where(:rating => @ratings.keys).order(@sortcol)
  end

  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(params[:movie])
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(params[:movie])
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

class MoviesController < ApplicationController

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    
    # Unsorted movies, initialized.
    @movies = Movie.all

    # Generate all possible ratings.
    @all_ratings = Movie.possible_ratings

    # Update type of sort if new param detected.
    if !params[:sort].nil?
      if params[:sort] == session[:sort]
        session[:sort] = nil
      else
        session[:sort] = params[:sort]
      end
    end

    # Update rating filtering, store session ratings.
    if !params[:ratings].nil?
      @filter_ratings = params[:ratings]
      session[:filter_ratings] = @filter_ratings
    end

    # Filter by sort.
    if session[:sort] == "title"
      @movies.sort! {|x, y| x.title <=> y.title}
      @movie_hilite_class = "hilite"
    elsif session[:sort] == "release_date"
      @movies.sort! {|x, y| x.release_date <=> y.release_date}
      @date_hilite_class = "hilite"
    else
      flash[:message] = "Should not have reached this point."
    end

    # Filter by rating.
    if !session[:filter_ratings].nil?
      rate_filter = session[:filter_ratings]
      @movies = @movies.select{|x| rate_filter.include? x.rating}
    end

    # Edge case; fill in from session if blank ratings.
    if params[:ratings].nil? && !session[:filter_ratings].nil?
      @filter_ratings = session[:filter_ratings]
      @sort = session[:sort]
      flash.keep
      redirect_to movies_path({order_by: @sort, ratings: @filter_ratings})
    end

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

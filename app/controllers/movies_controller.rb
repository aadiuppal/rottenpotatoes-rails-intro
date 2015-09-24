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
    @all_ratings = Movie.ratings
    @movies = Movie.all
    @sort_by = params[:sort_by]
    if(@sort_by != nil)
	    session[:sort_by] = @sort_by
    end
    if(params[:ratings] != nil || params[:sort_by] != nil)
	    session[:parameters] = session[:parameters].present? ? session[:parameters] : {}
  	if (params[:sort_by] != nil && params[:sort_by].length != 0)
	  	session[:parameters][:sort_by] = params[:sort_by]
  	elsif (session[:parameters] != nil && session[:parameters].length != 0)
	  	params[:sort_by]  = session[:parameters][:sort_by]
  	end
	  if (params[:ratings] != nil)
		  session[:parameters][:ratings] = params[:ratings]
    end
    elsif (session[:parameters] != nil && session[:parameters].length != 0)
    	flash.keep
    	redirect_to movies_path + '?' + session[:parameters].to_query
    end

    if(session[:parameters])
    	@sel_ratings = (session[:parameters][:ratings].present? ? session[:parameters][:ratings].keys : @all_ratings)
  	if(@sort_by == nil)
	  	@sort_by = session[:parameters][:sort_by] ? session[:parameters][:sort_by] : params[:sort_by]
  	end
    else
	    @sel_ratings = @all_ratings
      @sort_by = params[:sort_by]
    end
      @sort_by = session[:sort_by]

      if(@sort_by != nil)
	    @movies=Movie.where(:rating =>@sel_ratings).order(@sort_by)
    else
    	@movies=Movie.where(:rating =>@sel_ratings)
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

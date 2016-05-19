class MoviesController < ApplicationController

	def single_movie
		@current_user ||= User.find(session[:user_id]) if session[:user_id]
		if !@current_user.blank?
			@watchlist_slugs = [ ]
			@watched_slugs = [ ]

			watchlist = @current_user.userwatchlists.all

			watchlist.each do |w|
				@watchlist_slugs << w.slug
			end

			watched = @current_user.usermovies.all

			watched.each do |wa|
				@watched_slugs << wa.slug
			end

			if !Movie.where(:slug => params[:slug]).first.blank?
				@movie = Movie.where(:slug => params[:slug]).first
			else
				@moviet = Tmdbimdb.where(:slug => params[:slug]).first
			end
		end
	end
end

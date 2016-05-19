class WatchlistController < ApplicationController

	def watchlist
		@current_user ||= User.find(session[:user_id]) if session[:user_id]
		if !@current_user.blank?
			@movie_list = [ ]

			@current_user.userwatchlists.each do |m|
				@movie_list << Movie.where(slug: m.slug).first
			end

			@movie_list.delete_if {|x| x == nil}

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
		end
	end

	def add_to_watchlist
		current_user ||= User.find(session[:user_id]) if session[:user_id]

		if Movie.where(:slug => params[:slug]).first.blank?
			movie = Toptiy.where(:slug => params[:slug]).first
			genre = movie.Genre.split(",")
			genre.map! {|item| item.strip}
			Movie.create( {name: movie.Title, slug: movie.slug, image: movie.Poster, genre: genre, plot: movie.Plot, title: movie.Title, year: movie.Year, runtime: movie.Runtime, director: movie.Director, actors: movie.Actors, metascore: movie.Metascore,imdbRating: movie.imdbRating,imdbVotes: movie.imdbVotes,tmdbvote_average: movie.TMDBvote_average, youtubeID: movie.YoutubeID, youtubeviews: movie.YoutubeViews.to_i, algorithm_score: movie.algorithm_score} )
		else
			movie = Movie.where(:slug => params[:slug]).first
		end
		current_user.userwatchlists.create({:slug => movie.slug })
		render :json => { message: 'Watchlist updated' }
	end

	def remove_from_watchlist
		current_user ||= User.find(session[:user_id]) if session[:user_id]
		current_user.userwatchlists.destroy_all(:slug => params[:slug])
		render :json => { message: 'Watchlist updated' }
	end

	def add_to_watched
		current_user ||= User.find(session[:user_id]) if session[:user_id]
		if Movie.where(:slug => params[:slug]).first.blank?
			movie = Toptiy.where(:slug => params[:slug]).first
			genre = movie.Genre.split(",")
			genre.map! {|item| item.strip}
			Movie.create( {name: movie.Title, slug: movie.slug, image: movie.Poster, genre: genre, plot: movie.Plot, title: movie.Title, year: movie.Year, runtime: movie.Runtime, director: movie.Director, actors: movie.Actors, metascore: movie.Metascore,imdbRating: movie.imdbRating,imdbVotes: movie.imdbVotes,tmdbvote_average: movie.TMDBvote_average, youtubeID: movie.YoutubeID, youtubeviews: movie.YoutubeViews.to_i, algorithm_score: movie.algorithm_score} )
		else
			movie = Movie.where(:slug => params[:slug]).first
		end
		current_user.usermovies.create({:slug => movie.slug })
		current_user.userwatchlists.destroy_all(:slug => movie.slug)
		render :json => { message: 'Watched updated' }
	end

	def remove_from_watched
		current_user ||= User.find(session[:user_id]) if session[:user_id]
		current_user.usermovies.destroy_all(:slug => params[:slug])
		render :json => { message: 'Watched updated' }
	end
end

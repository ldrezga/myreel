class UserController < ApplicationController
	include UserHelper

	def index
		@current_user ||= User.find(session[:user_id]) if session[:user_id]
		if !@current_user.blank?
			@movie_list = [ ]

			@count = Tmdbimdb.all.count

		end
	end

	def movies
		@current_user ||= User.find(session[:user_id]) if session[:user_id]
		if !@current_user.blank?
			@movie_list = [ ]

			@current_user.usermovies.each do |m|
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
end
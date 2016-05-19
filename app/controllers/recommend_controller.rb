class RecommendController < ApplicationController
	include RecommendHelper

	def genre
		@current_user ||= User.find(session[:user_id]) if session[:user_id]
		if !@current_user.blank?

			@movie_list = [ ]
			@fgenres = [ ]
			@recommended_genres = [ ]

			@movies_ren

			@current_user.usermovies.each do |m|
				@movie_list << Movie.where(slug: m.slug).first
			end
			
			fg = Hash.new

			@movie_list.delete_if {|x| x == nil}

			@movie_list.each do |m|
				m.genre.each do |g|
					if fg.key?(g) == false
						fg[g] = 1
					else
						fg[g] += 1
					end
				end
			end

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

			@favourite_genres = [ ]
			slugs = [ ]
			
			favg = fg.sort_by{|k,v| v}.reverse[0..2].to_h
			favg.each_pair do |key, value|
				@favourite_genres << key
			end

			@favourite_genres

			@genres = Genre.all

			@movie_list.each do |m|
				slugs << m.slug
			end

			@favourite_genres.each do |g|
				@fgenres << g.strip
			end

			Toptiy.where(:slug.nin => slugs).each do |m|
				counter = 0
				genre = m.Genre.split(',')
				genre.map! {|item| item.strip}
				genre.each do |g|
					if @fgenres.include?(g)
						counter += 1
					end
					if counter == 2
						@recommended_genres << m
					end
				end
			end

			@recommended_genres.uniq!
			@recommended_genres.first(20)
		end
	end

	def subgenre
		@current_user ||= User.find(session[:user_id]) if session[:user_id]
		if !@current_user.blank?

			@movie_list = [ ]

			@current_user.usermovies.each do |m|
				@movie_list << Movie.where(slug: m.slug).first
			end

			@movie_list.delete_if {|x| x == nil}

			fg = Hash.new

			@movie_list.each do |m|
				m.genre.each do |g|
					if fg.key?(g) == false
						fg[g] = 1
					else
						fg[g] += 1
					end
				end
			end

			@watchlist_slugs = [ ]
			@watched_slugs = [ ]
			@fgenres = [ ]
			@genre_movies = [ ]

			watchlist = @current_user.userwatchlists.all

			watchlist.each do |w|
				@watchlist_slugs << w.slug
			end

			watched = @current_user.usermovies.all

			watched.each do |wa|
				@watched_slugs << wa.slug
			end

			@favourite_genres = [ ]
			slugs = [ ]
			
			favg = fg.sort_by{|k,v| v}.reverse[0..2].to_h
			favg.each_pair do |key, value|
				@favourite_genres << key
			end

			@favourite_genres

			@genres = Genre.all

			@movie_list.each do |m|
				slugs << m.slug
			end

			@favourite_genres.each do |g|
				@fgenres << g
			end

			Toptiy.where(:slug.nin => slugs).each do |m|
				genre = m.Genre.split(',')
				genre.map! {|item| item.strip}
				genre.each do |g|
					if g == params[:name]
						@genre_movies << m
					end
				end
			end

			@genre_movies.uniq!
			@genre_movies.first(20)
		end

	end

	def filter

		@current_user ||= User.find(session[:user_id]) if session[:user_id]
		if !@current_user.blank?

			@genre_params = params[:genre]

			if @genre_params.nil?
				@genre_params = []
			else
				@genre_params = params[:genre].flatten
			end

			@movie_list = [ ]
			@fgenres = [ ]
			@movie_genres = [ ]
			@movies = [ ]

			@current_user.usermovies.each do |m|
				@movie_list << Movie.where(slug: m.slug).first
			end
			
			fg = Hash.new

			@movie_list.delete_if {|x| x == nil}

			@movie_list.each do |m|
				m.genre.each do |g|
					if fg.key?(g) == false
						fg[g] = 1
					else
						fg[g] += 1
					end
				end
			end

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

			@favourite_genres = [ ]
			slugs = [ ]
			tiy_genres = [ ]
			
			favg = fg.sort_by{|k,v| v}.reverse[0..2].to_h
			favg.each_pair do |key, value|
				@favourite_genres << key
			end

			@favourite_genres

			@genres = Genre.all

			@movie_list.each do |m|
				slugs << m.slug
			end

			@favourite_genres.each do |g|
				@fgenres << g
			end

			length = @genre_params.length

			if @genre_params.empty?
				@movies_other = Toptiy.all.limit(200)
			else
				Toptiy.where(:slug.nin => slugs).order(algorithm_score: :desc).each do |movie|
					genre = movie.Genre.split(',')
					genre.map! {|item| item.strip.downcase}

					genre.each do |ge|
						tiy_genres << ge
					end

					if (genre & @genre_params).length > length-1
						@movies << movie
					end
				end
			end

			@movies_other
			@movies
		end
	end

	def influencer
		@current_user ||= User.find(session[:user_id]) if session[:user_id]

		if !@current_user.blank?

			uid = [ ]
			imovies = [ ]
			movie_list = [ ]
			@friend_id = [ ]

			uid << @current_user.uid

			@influencers = User.where(:uid.nin => uid).order(influencer_score: :desc)

			friends = @current_user.userfriends.all
			friends.each do |f|
				@friend_id << f.user_id
			end
			@friend_id
		end

	end

	def single_influencer
		@current_user ||= User.find(session[:user_id]) if session[:user_id]
		if !@current_user.blank?

			@movie_list = [ ]
			@influencer_movies = [ ]

			@influencer = User.where(:uid => params[:uid]).first

			@current_user.usermovies.each do |m|
				@movie_list << Movie.where(slug: m.slug).first
			end

			@movie_list.delete_if {|x| x == nil}

			slugs = [ ]
			fbids = [ ]
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


			@movie_list.each do |m|
				slugs << m.slug
			end

			@influencer.usermovies.each do |m|
				@influencer_movies << Movie.where(slug: m.slug).first
			end

			@influencer_movies.delete_if {|x| x == nil}
			@influencer_movies.delete_if {|x| slugs.include? x.slug}
			@influencer_movies.uniq!
			@influencer_movies
		end
	end

	def friend
		@current_user ||= User.find(session[:user_id]) if session[:user_id]
		if !@current_user.blank?

			movie_list = [ ]
			slugs = [ ]
			uids = [ ]
			@friend_movies = [ ]
			@friend_movie_slugs = [ ]
			@recommended_movies = [ ]
			fl_count = 0

			@current_user.usermovies.each do |m|
				movie_list << Movie.where(slug: m.slug).first
			end

			movie_list.delete_if {|x| x == nil}

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

			movie_list.each do |m|
				slugs << m.slug
			end

			user_friends = @current_user.userfriends

			user_friends.each do |f|
				uids << f.user_id
			end

			@friends = User.where(:uid => {"$in" => uids})

			@friends.each do |f|
				f.usermovies.each do |m|
					@friend_movies << Movie.where(slug: m.slug).first
				end
			end

			@friend_movies.delete_if {|x| x == nil}
			@friend_movies.delete_if {|x| slugs.include? x.slug}

			@h = Hash.new(0)
			@friend_movies.each { | v | @h.store(v.slug, @h[v.slug]+1) }
			@h = @h.sort_by{|k,v| v}.reverse.to_h

			@h.each_pair do |key, value|
				@friend_movie_slugs << key
			end

			length = uids.length

			@h.each_pair do |key, value|
				temp_movie = Movie.where(:slug => key).first
				new_score = temp_movie.algorithm_score + value/length
				temp_movie.algorithm_score = new_score
				@recommended_movies << temp_movie
			end

			@recommended_movies.sort_by{|e| -e[:algorithm_score]}

		end

	end

end



















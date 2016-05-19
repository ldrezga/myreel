class User
	include Mongoid::Document
	include Mongoid::Timestamps::Created

	field :provider, :type => String
	field :uid, :type => String
	field :name, :type => String
	field :email, :type => String
	field :birthday, :type => String
	field :gender, :type => String
	field :hometown, :type => String
	field :influencer_score, :type => Integer
	embeds_many :usermovies
	embeds_many :userfriends
	embeds_many :userwatchlists

	def self.create_with_omniauth(auth)
		create! do |user|
			user.provider = auth.provider
			user.uid = auth.uid.to_i
			if auth.info
				user.name = auth.info.name || ""
				user.email = auth.info.email || ""
			end
			data = auth.extra.raw_info
			user.birthday = data.birthday
			user.gender = data.gender
			if !data.hometown.blank?
				user.hometown = data.hometown.name
			else
				user.hometown = nil
			end
		end
	end

	def get_influencer_score(user)
		movie_list = [ ]

		user.usermovies.each do |m|
			movie_list << Movie.where(fbmovie_id: m.fbmovie_id).first
		end

		movie_list.delete_if { |x| x == nil }

		slugs = [ ]

		movie_list.each do |m|
			slugs << m.slug
		end

		influencer_movies = [ ]

		self.usermovies.each do |m|
			influencer_movies << Movie.where(fbmovie_id: m.fbmovie_id).first
		end

		influencer_movies.delete_if {|x| x == nil}

		imdbscore = 0
		count = 0

		influencer_movies.each do |im|
			if im.imdbRating < 5.9
				imdbscore += 0.6 * im.imdbRating
			else
				imdbscore += im.imdbRating
			end
			count += 1
		end

		return (self.influencer_score / (10 - imdbscore / count)).round(2)
	end
end

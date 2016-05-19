module RecommendHelper

	def get_favourite_genres(*movies)
			return nil

			genres = Hash.new

			movies.each do |m|
				m.genre.each do |g|
					if genres[g.name].blank?
						genres = { g.name => 1 }
					else
						genres[g.name] + 1
					end
				end
			end

			genres.sort_by {|k,v| v}.reverse

			return genres
	end
end

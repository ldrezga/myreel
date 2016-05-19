class MasterController < ApplicationController
	def recalculate
		# movies = Movie.all

		# @imdb_votes_counter = 0

		# @movies_count = movies.count

		# movies.each do |m|
		# 	@imdb_votes_counter += m.imdbVotes
		# end

		# @imdb_votes_avg = @imdb_votes_counter / @movies_count

		# Movie.all.each do |mov|
		# 		if mov.imdbVotes > @imdb_votes_avg
		# 			alg_score = (1.2*mov.imdbRating.to_f+0.08*mov.metascore)/2
		# 		else
		# 			alg_score = (0.9*mov.imdbRating.to_f+0.09*mov.metascore)/2
		# 		end
		# 		Movie.where(:slug => mov.slug).update({algorithm_score: alg_score})
		# end

		

		# if General.only(:imdb_votes_avg).blank?
		# 	General.create({:imdb_votes_avg => @imdb_votes_avg})
		# else
		# 	General.update({:imdb_votes_avg => @imdb_votes_avg})
		# end

		# if General.only(:imdb_votes_avg).blank?
		# 	General.create({:imdb_votes_avg => @imdb_votes_avg})
		# else
		# 	General.update({:imdb_votes_avg => @imdb_votes_avg})
		# end

		# if General.only(:imdb_votes).blank?
		# 	General.create({:imdb_votes => @imdb_votes_counter})
		# else
		# 	General.update({:imdb_votes => @imdb_votes_counter})
		# end

		# if General.only(:movie_number).blank?
		# 	General.create({:movie_number => @movies_count})
		# else
		# 	General.update({:movie_number => @movies_count})
		# end
		
		General.create({:imdb_votes_avg => 33488.07, :avg_youtube => 3877284})
	end
end

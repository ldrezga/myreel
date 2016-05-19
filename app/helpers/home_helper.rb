module HomeHelper

	def get_trailer(mov_id)
		trailer = Movie.where(fbmovie_id: mov_id).first
	end
end

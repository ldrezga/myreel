module SessionsHelper

	def get_user_movies(auth)

		user_movies = [ ]

		if !auth.extra.raw_info.movies.blank?
			after_cursor = auth.extra.raw_info.movies.paging.cursors.after
		    next_cursor = auth.extra.raw_info.movies.paging.next
		    next_call = ""
		    if !next_cursor.blank?
			    temp_var = next_cursor.split("?")
			    next_call = temp_var[0] + "?access_token=" + auth.credentials.token + "&" + temp_var[1]
			end
		end

		flag = 0

	    while !next_call.blank? do
	    	response = HTTParty.get(next_call)
			datar = JSON.parse(response.body)
			if flag == 0
				user_movies_rest = datar["data"]
				flag = 1
			else
	    		user_movies_rest = user_movies_rest + datar["data"]
	    	end
	    	next_call = datar["paging"]["next"]
	    	after_cursor = datar["paging"]["cursors"]["after"]
	    	if !next_call.blank?
				temp_var = next_call.split("?")
		    	next_call = temp_var[0] + "?access_token=" + auth.credentials.token + "&pretty=0&limit=25&after=" + after_cursor
		    end
		end
		
	    first_call = "https://graph.facebook.com/v2.5/" + auth.uid + "/movies?access_token=" + auth.credentials.token + "&pretty=0&limit=25"

	    response1 = HTTParty.get(first_call)
		data = JSON.parse(response1.body)
		user_movies_first = data["data"]
		if !user_movies_rest.blank?
			user_movies = user_movies_first + user_movies_rest
		else
			user_movies = user_movies_first
		end

		return user_movies
	end

	def get_user_friends(auth)

		user_friends = [ ]

		if !auth.extra.raw_info.friends.paging.blank?
		    next_cursor = auth.extra.raw_info.friends.paging.next
		    next_call = ""
		    if !next_cursor.blank?
			    temp_var = next_cursor.split("?")
			    next_call = temp_var[0] + "?format=json&access_token=" + auth.credentials.token + "&" + temp_var[1]
			end
		end

		flag = 0

	    while !next_call.blank? do
	    	response = HTTParty.get(next_call)
			datar = JSON.parse(response.body)
			if flag == 0
				user_friends_rest = datar["data"]
				flag = 1
			else
	    		user_friends_rest = user_friends_rest + datar["data"]
	    	end
	    	next_call = datar["paging"]["next"]
	    	if !next_call.blank?
				temp_var = next_call.split("?")
		    	next_call = temp_var[0] + "?format=json?access_token=" + auth.credentials.token + "&" + temp_var[1]
		    end
		end
		
	    first_call = "https://graph.facebook.com/v2.5/" + auth.uid + "/friends?access_token=" + auth.credentials.token

	    response1 = HTTParty.get(first_call)
		data = JSON.parse(response1.body)
		user_friends_first = data["data"]
		if !user_friends_rest.blank?
			user_friends = user_friends_first + user_friends_rest
		else
			user_friends = user_friends_first
		end

		return user_friends
	end

end

class SessionsController < ApplicationController
	include SessionsHelper
	
      def create
            auth = request.env["omniauth.auth"]
            user = User.where(:provider => auth['provider'], :uid => auth['uid']).first || User.create_with_omniauth(auth)
            # user_movies = auth.extra.raw_info.movies.data

            user_movies = get_user_movies(auth)
            user_friends = get_user_friends(auth)

            if user.influencer_score.blank?
                  user.update({influencer_score: 0})
            end

            influencer_score = user.influencer_score

            if !user_friends.blank?
                  user_friends.each do |u|
                        if user.userfriends.where(:user_id => u["id"]).blank?
                              user.userfriends.create({name: u["name"], user_id: u["id"].to_i})
                        end
                  end
            end

            user_movies.each do |movie|
                  emovie = user.usermovies.where(:fbmovie_id => movie["id"]).first
                  movie["name"] = movie["name"].gsub(" Movie","")
                  if emovie.blank?
                        movie_slug=movie["name"].parameterize
                        enmovie2 = user.usermovies.where(:slug => movie_slug).first
                        if enmovie2.blank?
                              user.usermovies.create({fbmovie_id: movie["id"], slug: movie_slug})
                              influencer_score += 1
                        end
                  end
            end

            user_movies.each do |movie|
                  movie_slug=movie["name"].gsub(" Movie","").parameterize
            	emovie = Movie.where(:slug => movie_slug).first
            	if emovie.blank?
                        omdb_mov=movie_slug.gsub(/-/,'+')
                        movie_trailer = nil
                        movie_likes_response = HTTParty.get("https://graph.facebook.com/v2.5/"+movie["id"]+"?fields=likes&access_token="+ auth.credentials.token)
                        data_likes = movie_likes_response.parsed_response
                        movie_image = "https://graph.facebook.com/v2.5/"+movie["id"]+"/picture?type=large"
                        tiy = Tmdbimdb.where(:slug => movie_slug).first
                        if !tiy.blank?
                              genre = tiy.Genre.split(",")
                              genre.map! {|item| item.strip}
                              if tiy.Poster == "N/A"
                                    Movie.create( { fbmovie_id: movie["id"], name: movie["name"], slug: movie_slug, trailer: movie_trailer, image: movie_image, likes: data_likes["likes"], genre: genre, plot: tiy.Plot, title: tiy.Title, year: tiy.Year, runtime: tiy.Runtime, director: tiy.Director, actors: tiy.Actors, metascore: tiy.Metascore,imdbRating: tiy.imdbRating,imdbVotes: tiy.imdbVotes,tmdbvote_average: tiy.TMDBvote_average, youtubeID: tiy.YoutubeID, youtubeviews: tiy.YoutubeViews.to_i, algorithm_score: tiy.algorithm_score} )
                              else
                                    Movie.create( { fbmovie_id: movie["id"], name: movie["name"], slug: movie_slug, trailer: movie_trailer, image: tiy.Poster, likes: data_likes["likes"], genre: genre, plot: tiy.Plot, title: tiy.Title, year: tiy.Year, runtime: tiy.Runtime, director: tiy.Director, actors: tiy.Actors, metascore: tiy.Metascore,imdbRating: tiy.imdbRating,imdbVotes: tiy.imdbVotes,tmdbvote_average: tiy.TMDBvote_average, youtubeID: tiy.YoutubeID, youtubeviews: tiy.YoutubeViews.to_i, algorithm_score: tiy.algorithm_score} )
                              end
                        else 
                              omdb_response = HTTParty.get("http://www.omdbapi.com/?t=" + omdb_mov +"&type=movie&tomates=true&plot=long&r=json")
                              omdb_data = omdb_response.parsed_response
                              if omdb_data["Response"] == "True"
                                    if !omdb_data["imdbVotes"].blank?
                                          omdb_data["imdbVotes"] = omdb_data["imdbVotes"].gsub(/,/,'')
                                    end
                                    omdb_votes = omdb_data["imdbVotes"].to_i
                                    omdb_genres = omdb_data["Genre"].split(",")
                                    omdb_genres.each {|a| a.downcase.strip! if a.respond_to? :strip! }
                                    omdb_votes = omdb_data["imdbVotes"].gsub(",","").to_i
                                    imdb_votes_avg = General.only(:imdb_votes_avg).first
                                    if omdb_votes > imdb_votes_avg.imdb_votes_avg
                                          alg_score = (1.2*omdb_data["imdbRating"].to_f+0.08*omdb_data["Metascore"].to_f)/2
                                    else
                                          alg_score = (0.9*omdb_data["imdbRating"].to_f+0.09*omdb_data["Metascore"].to_f)/2
                                    end
                                    Movie.create( { fbmovie_id: movie["id"], name: movie["name"], slug: movie_slug, trailer: movie_trailer, image: movie_image, likes: data_likes["likes"], genre: omdb_genres, plot: omdb_data["Plot"], title: omdb_data["Title"], year: omdb_data["Year"], runtime: omdb_data["Runtime"], director: omdb_data["Director"], actors: omdb_data["Actors"], metascore: omdb_data["Metascore"],imdbRating: omdb_data["imdbRating"],imdbVotes: omdb_votes, algorithm_score: alg_score} )

                                    omdb_genres.each do |genre|
                                          if Genre.where(:name => genre.strip).first.blank?
                                                Genre.create({name: genre.strip})
                                          end
                                    end
                              else
                                    user.usermovies.destroy_all(:fbmovie_id => movie["id"])
                                    influencer_score -= 1
                              end
                        end
            	end
            end
            user.update({influencer_score: influencer_score})




		# user = User.create_with_omniauth(auth)
            session[:user_id] = user.id
            redirect_to user_profile_path, :notice => "Signed in!"
      end
	 
      def destroy
            session[:user_id] = nil
            redirect_to root_url
      end
end

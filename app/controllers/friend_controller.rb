class FriendController < ApplicationController
	def add_to_friends
		current_user ||= User.find(session[:user_id]) if session[:user_id]
		current_user.userfriends.create({:name => params[:name], :user_id => params[:fbid] })
		render :json => { message: 'Friends updated' }
	end

	def remove_from_friends
		current_user ||= User.find(session[:user_id]) if session[:user_id]
		current_user.userfriends.destroy_all(:user_id => params[:fbid])
		render :json => { message: 'Watched updated' }
	end

	def friends
		@current_user ||= User.find(session[:user_id]) if session[:user_id]

		if !@current_user.blank?

			uid = [ ]
			imovies = [ ]
			movie_list = [ ]
			@friend_id = [ ]
			@friends = [ ]

			@current_user.userfriends.each do |f|
				uid << f.user_id
			end

			friends = @current_user.userfriends.all
			friends.each do |f|
				@friend_id << f.user_id
			end
			@friend_id
			
			User.all.each do |u|
				if uid.include? u.uid.to_i
					@friends << u
				end
			end
			@friends
		end

	end
end

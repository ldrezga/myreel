OmniAuth.config.logger = Rails.logger

Rails.application.config.middleware.use OmniAuth::Builder do
  provider :facebook,'451333688399515', '3d3934ac6cc915f1f085bdd6925145d1', :scope => 'email,user_about_me,user_birthday,user_hometown,user_actions.video, user_likes, user_friends', :info_fields => 'name,email,birthday,gender,hometown,movies,friends'
end
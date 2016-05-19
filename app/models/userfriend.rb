class Userfriend
  include Mongoid::Document
  field :name, type: String
  field :user_id, type: Integer

  embedded_in :user, :inverse_of => :userfriends

end

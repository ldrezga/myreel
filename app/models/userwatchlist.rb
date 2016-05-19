class Userwatchlist
  include Mongoid::Document
  field :fbmovie_id, type: String
  field :slug, type: String

  embedded_in :user, :inverse_of => :userwatchlists

end
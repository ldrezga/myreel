class Movietrailer
  include Mongoid::Document
  field :fbmovie_id, type: String
  field :trailer, type: String

end

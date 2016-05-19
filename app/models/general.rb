class General
  include Mongoid::Document
  field :movie_number, type: Integer
  field :imdb_votes, type: Integer
  field :imdb_votes_avg, type: Float
  field :avg_youtube, type: Float

end
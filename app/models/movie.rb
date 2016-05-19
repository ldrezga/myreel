class Movie
  include Mongoid::Document
  field :fbmovie_id, type: String
  field :name, type: String
  field :slug, type: String
  field :trailer, type: String
  field :image, type: String
  field :likes, type: Integer
  field :genre, type: Array
  field :plot, type: String
  field :title, type: String
  field :year, type: String
  field :runtime, type: String
  field :director, type: String
  field :actors, type: String
  field :metascore, type: Integer
  field :imdbRating, type: Float
  field :imdbVotes, type: Integer
  field :tmdbvote_average, type: Float
  field :youtubeID, type: String
  field :youtubeviews, type: Integer
  field :algorithm_score, type: Float

end
class Tmdbimdb
  include Mongoid::Document
  field :Title, type: String
  field :Year, type: String
  field :Runtime, type: String
  field :Genre, type: String
  field :Director, type: String
  field :Actors, type: String
  field :Plot, type: String
  field :Poster, type: String
  field :Metascore, type: String
  field :imdbRating, type: String
  field :imdbVotes, type: String
  field :imdbID, type: String
  field :slug, type: String
  field :TMDBvote_average, type: Float
  field :YoutubeID, type: String
  field :YoutubeViews, type: String
  field :algorithm_score, type: Float

end
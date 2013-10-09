class Movie < ActiveRecord::Base
  def self.list_ratings
    Movie.select(:rating).group(:rating).collect { |movie| movie.rating }
  end
end

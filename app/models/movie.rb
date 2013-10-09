class Movie < ActiveRecord::Base
  def self.list_ratings
    Movie.group(:rating).collect { |movie| movie.rating }
  end
end

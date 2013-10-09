class Movie < ActiveRecord::Base
  def self.list_ratings
    Movie.unscoped.group(:rating).collect { |movie| movie.rating }
  end
end

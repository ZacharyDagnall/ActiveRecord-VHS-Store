class Genre < ActiveRecord::Base
    has_many :movie_genres
    has_many :movies, through: :movie_genres

    def self.most_popular

    end

    def self.longest_movies

    end

end
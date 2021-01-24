class Genre < ActiveRecord::Base
    has_many :movie_genres
    has_many :movies, through: :movie_genres

    def self.most_popular
        self.all.max_by(5){|genre| genre.movies.length}
    end

    def self.longest_movies
        self.all.max_by{|genre| genre.average_movie_length}
    end

    #helper method
    # 0.0 used to guard against integer division (roundoff)
    def average_movie_length
        if self.movies.length != 0 
            self.movies.sum(0.0){|movie| movie.length}/self.movies.length
        else
            0
        end
    end

end
class Movie < ActiveRecord::Base
    has_many :vhs
    has_many :movie_genres
    has_many :genres, through: :movie_genres
    has_many :rentals, through: :vhs

    def self.available_now
        Vhs.available_now.map{|vhs| vhs.movie} 
    end
    #incomplete
    def self.most_clients
        # Client.all.map{|client| client.movies.length} 
        all.max_by{|movie| movie.rentals.size} #this should return the most rented movie, but not necessarily the one rented by the most individual people because of repeats
        all.max{|movie| movie.rentals.max_by{|rental| rental.clients.size}} #trying to return the movie with the most clients by getting the rental with the largest array of clients. Does it work backwards like this? rentals belongs to clients, I can see how manny clients from each instance of rental I think?
    end

    def self.most_rentals
        all.max_by(3){|movie| movie.rentals.size}
    end

    def self.most_popular_female_director
        most = get_female_directed_movies.max_by{|movie| movie.rentals.size}
        most.director
    end

    def self.newest_first
        all.sort_by{|movie| movie.year}.reverse!
    end

    def self.longest
        all.sort_by{|movie| movie.length}.reverse!
    end

    def recommendation
       puts "#{title} #{get_emoji.sample} \n #{description} #{length} #{director} #{year}" #this is listed in the deliverable as an instance method but that seems silly, a recommendation when already in a movie instance?
    end

    def self.surprise_me
        movie = all.sample
        movie.recommendation
    end

    def report_stolen
        to_delete = vhs.map{|vhs| vhs.rentals.all?{|rental| rental.current == false}}.sample
        Vhs.destroy(to_delete)
        puts "THANK YOU FOR YOUR REPORT. WE WILL LAUNCH AN INVESTIGATION."
    end

    def self.get_female_directed_movies
        all.select{|movie| movie.female_director == true}
    end

    private_class_method :get_female_directed_movies

    private
    def get_emoji
       arr = [":)", ":D", ":P", "xD"]
    end

end


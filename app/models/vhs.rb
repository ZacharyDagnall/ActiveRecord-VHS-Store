class Vhs < ActiveRecord::Base
    has_many :rentals
    has_many :clients, through: :rentals
    belongs_to :movie
        
    after_initialize :add_serial_number

    #not sure if there's a way to slim this down. 
    def self.hot_from_the_press(title: , year: , length: , director: , description: , female_director: , genre: )
        a_movie = Movie.create(title: title, year: year, length: length, director: director, description: description, female_director: female_director)
        a_genre = Genre.find_or_create_by(name: genre)
        a_movie.genres << a_genre
        a_genre.movies << a_movie
        a_movie.save
        a_genre.save
        3.times do  
            Vhs.create({movie: a_movie})
        end
    end

    #should be good
    def self.most_used
        most_used_arr = self.all.max_by(3){|vhs| vhs.rentals.length}
        most_used_arr.each{|vhs| puts "serial number: #{vhs.serial_number} | title: #{vhs.movie.title}" }
    end

    #for each vhs, selects it if NONE of its rentals are CURRENT (therefore available)
    def self.available_now
        self.all.select{|vhs| vhs.rentals.none?{|rental| rental.current=true} }
    end

    #if i used just map instead of flat_map, we would get a list of lists (not what we want)
    def self.all_genres
        self.available_now.flat_map{|vhs| vhs.movie.genres}.uniq
    end


    private

    # generates serial number based on the title
    def add_serial_number
        serial_number = serial_number_stub
        # Converting to Base 36 can be useful when you want to generate random combinations of letters and numbers, since it counts using every number from 0 to 9 and then every letter from a to z. Read more about base 36 here: https://en.wikipedia.org/wiki/Senary#Base_36_as_senary_compression
        alphanumerics = (0...36).map{ |i| i.to_s 36 }
        13.times{|t| serial_number << alphanumerics.sample}
        self.update(serial_number: serial_number)
    end

    def long_title?
        self.movie.title && self.movie.title.length > 2
    end

    def two_part_title?
        self.movie.title.split(" ")[1] && self.movie.title.split(" ")[1].length > 2
    end

    def serial_number_stub
        return "X" if self.movie.title.nil?
        return self.movie.title.split(" ")[1][0..3].gsub(/s/, "").upcase + "-" if two_part_title?
        return self.movie.title.gsub(/s/, "").upcase + "-" unless long_title?
        self.movie.title[0..3].gsub(/s/, "").upcase + "-"
    end

end
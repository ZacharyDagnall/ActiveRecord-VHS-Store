class Client < ActiveRecord::Base
    has_many :rentals
    has_many :vhs, through: :rentals 
    has_many :movies,  through: :vhs
    
    def self.first_rental(vhs, name, home_address)
        client = Client.create(name: name, home_address: home_address)
        rental = Rental.create(current: true, client_id: client.id, vhs_id: vhs.id)

    end    

    def self.most_active
        clients = Client.all.sort { |a,b| a.rentals.where(current: false).length <=> b.rentals.where(current: false).length }
        clients[-5..-1]
    end

    def favorite_genre


        genre_count = Hash.new(0)
        rentals.each do |rental|
            genres = rental.vhs.movie.genre.pluck(:name)
            genres.each do |genre|
                genre_count[genre] += 1
            end
         end
         
          puts genre_count.max_by{|genre, number| number}
    end    
   
    def self.non_greta 
        clients = []
        Client.all.each do |client|
            client.rentals.where(current: true).each do |rental|
                if rental.due_date < Time.current 
                    clients.push(client)
                    break
                end
            end 

        end
        clients
    end    

    def self.paid_most
        most_paid = 0
        client_with_most_paid = nil
        Client.all.each do |client|
            money_spent = client.rentals.length * 5.35
            if money_spent > most_paid
                client_with_most_paid = client
                most_paid = money_spent 
            end
        end
        client_with_most_paid
    end    

    def self.total_watch_time

        Client.all.sum{|client| client.vhs.sum{|vhs| vhs.movie.length}}

    #     watch_time = 0
    #     Client.all.each do |client|
    #         client.rentals.each do |rental|
    #             watch_time += rental.vhs.movie.length
    #         end
    #     end
    #     watch_time
    end    


end
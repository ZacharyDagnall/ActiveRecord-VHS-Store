class Client < ActiveRecord::Base
    has_many :rentals
    has_many :vhs, through: :rental

    def Client.first_rental
        binding.pry
    end    

end
class Company
    attr_reader :name, :siren, :directors, :balance

    def initialize(name, siren, directors = [], balance = [])
        @name = name
        @siren = siren
        @directors = directors
    end

    def add_director(function,name)
        @directors[name] = function
    end

    def to_s
        "#{@name}: SIREN #{@siren}"
    end
end

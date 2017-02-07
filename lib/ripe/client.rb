require 'ripe/object'

module RIPE
  class Client

    def initialize(mode, password = nil)
      @mode = mode
      @password = password
    end

    def mode
      @mode
    end

    def password
      @password
    end

    def find(key, value)
      Object.find(self, key, value)
    end

    def new(key)
      Object.new(self, key)
    end

  end
end

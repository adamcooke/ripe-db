module RIPE
  class Attribute

    def initialize(client, attribute)
      @client = client
      @attribute = attribute
    end

    def name
      @attribute['name']
    end

    def value
      @attribute['value']
    end

    def referenced_type
      @attribute['referenced-type']
    end

    def referenced_object
      @referenced_object ||= referenced_type ?  @client.find(self.referenced_type, self.value) : nil
    end
    alias_method :object, :referenced_object

    def to_api_hash
      {
        'name' => @attribute['name'],
        'value' => @attribute['value']
      }
    end

  end
end

module RIPE
  class AttributeSet < Array

    def initialize(client, name)
      @client = client
      @name = name
      super([])
    end

    def name
      @name
    end

    def add(value)
      self << Attribute.new(@client, 'name' => @name, 'value' => value)
    end

    def update(values)
      clear
      values = [values] unless values.is_a?(Array)
      values.each { |value| add(value) }
    end

    def to_api_hash
      map(&:to_api_hash)
    end
  end
end

require 'ripe/http_request'
require 'ripe/attribute'
require 'ripe/attribute_set'

module RIPE
  class Object

    def self.find(client, type, key)
      request = HTTPRequest.new(client, type).lookup(key)
      self.new(client, type, request)
    end

    def initialize(client, type, data = nil)
      @client = client
      @type = type
      @data = data
    end

    def new?
      @data.nil?
    end

    def deleted?
      !!@deleted
    end

    def source
      @data['source']['id']
    end

    def link
      if @data['link'] && @data['link']['type'] == 'locator'
        @data['link']['href']
      end
    end

    def [](key)
      attributes[key]
    end

    def []=(key, value)
      attributes[key] = AttributeSet.new(key) if attributes[key].nil?
      attributes[key].update(value)
    end

    def primary_key
      if key = @data.dig('primary-key', 'attribute')&.first
        attributes[key['name']].first
      end
    end

    def to_api_hash
      {
        'objects' => {
          'object' => [
            {
              'source' => {
                'id' => @client.mode == :test ? 'test' : 'ripe'
              },
              'attributes' => {
                'attribute' => attributes.values.map(&:to_api_hash).flatten
              }
            }
          ]
        }
      }
    end

    def create
      if !new?
        raise RIPE::Error, "This object has already been created, it cannot be created again"
      end

      request = HTTPRequest.new(@client, @type).create(@client.password, self.to_api_hash)
      @data = request
      self
    end

    def update
      if new?
        raise RIPE::Error, "This object has not been created yet, it cannot be updated until it exists"
      end

      if key = primary_key&.value
        request = HTTPRequest.new(@client, @type).update(@client.password, key, self.to_api_hash)
        @data = request
        self
      else
        raise RIPE::Error, "Object does not have a primary key therefore cannot be updated"
      end
    end

    def delete(reason = nil)
      if key = primary_key&.value
        request = HTTPRequest.new(@client, @type).delete(@client.password, key, reason)
        @deleted = true
      else
        raise RIPE::Error, "Object does not have a primary key therefore cannot be deleted"
      end
    end

    private

    def attributes
      @attributes ||= new? ? {} : @data['attributes']['attribute'].each_with_object({}) do |attr, hash|
        hash[attr['name']] ||= AttributeSet.new(@client, attr['name'])
        hash[attr['name']] << Attribute.new(@client, attr)
      end
    end

  end
end

require 'uri'
require 'net/https'
require 'json'
require 'ripe/errors'

module RIPE
  class HTTPRequest

    def initialize(client, object_type)
      @client = client
      @object_type = object_type
    end

    def lookup(key)
      json = request(Net::HTTP::Get, "/#{key}")
      json.dig('objects', 'object').first
    end

    def create(password, object_hash)
      json = request(Net::HTTP::Post, '', :query => {:password => password}, :json => object_hash.to_json)
      json.dig('objects', 'object').first
    end

    def update(password, key, object_hash)
      json = request(Net::HTTP::Put, "/#{key}", :query => {:password => password}, :json => object_hash.to_json)
      json.dig('objects', 'object').first
    end

    def delete(password, key, reason = nil)
      request(Net::HTTP::Delete, "/#{key}", :query => {:password => password, :reason => reason})
    end

    private

    def request(request_type, path, options = {})
      http = Net::HTTP.new(@client.mode == :test ? 'rest-test.db.ripe.net' : 'rest.db.ripe.net', 443)
      http.use_ssl = true
      path = "/#{@client.mode == :test ? 'test' : 'ripe'}/#{@object_type}#{path}"

      if options[:query]
        path << "?"
        path << URI.encode_www_form(options[:query])
      end

      request = request_type.new(path)
      request['Accept'] = 'application/json'

      if options[:json]
        request.add_field 'Content-Type', 'application/json'
        request.body = options[:json]
      end

      response = http.request(request)
      case response
      when Net::HTTPOK
        JSON.parse(response.body)
      when Net::HTTPNotFound
        raise RIPE::NotFound, "No resource found at #{path}"
      when Net::HTTPUnauthorized
        raise RIPE::AccessDenied, "Access denied to #{path}"
      when Net::HTTPBadRequest
        if response['Content-Type'] == 'application/json'
          body = JSON.parse(response.body)
          errors = body.dig('errormessages', 'errormessage')
          raise ValidationError.new(errors)
        else
          puts response.body
          raise RIPE::BadRequest, "Invalid request to API #{path}"
        end
      else
        puts response.inspect
        false
      end
    end

  end
end

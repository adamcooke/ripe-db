require 'ripe/object_error'

module RIPE

  class Error < StandardError
  end

  class NotFound < Error
  end

  class BadRequest < Error
  end

  class AccessDenied < Error
  end

  class ValidationError < Error
    def initialize(errors)
      @errors = errors.map { |r| ObjectError.new(r) }
    end

    def errors
      @errors
    end

    def to_s
      @errors.map(&:text).join(', ')
    end
  end

end

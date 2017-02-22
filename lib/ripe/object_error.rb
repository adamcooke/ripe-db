module RIPE
  class ObjectError

    def initialize(hash)
      @hash = hash
    end

    def text
      @hash['text'] % args
    end

    def severity
      @hash['severity']
    end

    def attribute
      @hash['attribute']
    end

    def args
      if @hash['args'].is_a?(Array)
        @hash['args'].map { |a| a['value'] }
      else
        []
      end
    end

  end
end

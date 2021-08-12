module Key_Method
    def key()
        return extract_key.call @value
    end
end

class Heap_Element 
    @value
    @extract_key
    include Key_Method #module with the Key method (used to extend objects at runtime)

    attr_accessor :value
    attr_reader :extract_key

    def initialize(value = nil, extract_key = ->(val) {return val})
        @value = value
        self.extract_key= extract_key
    end

    #------ Setters
    def extract_key=(extract_key)
        raise TypeError, "Extract key has to be callable" unless extract_key.respond_to?(:call)
        @extract_key = extract_key
        return extract_key
    end

    def self.is_compatible? (node)
        return node.respond_to?(:extract_key) && node.respond_to?(:value)
    end
end

class Inner_Heap_Element #When an element is inserted into the heap it becomes unmutable, it can only be deleted or repositioned
    @INNER_ELEMENT          
    @update_container 

    def initialize(inner_element, update_container)
        raise TypeError, "Element not compatible" unless Heap_Element.is_compatible? inner_element
        @INNER_ELEMENT = inner_element 
        self.update_container= update_container
    end

    def update_container=(update_container)
        raise TypeError, "Update container has to be callable" unless update_container.respond_to?(:call)
        @update_container = update_container
    end
    
    def key()
        return @INNER_ELEMENT.key
    end

    def value()
        return @INNER_ELEMENT.value
    end

    def extract_key()
        return @INNER_ELEMENT.extract_key
    end
end

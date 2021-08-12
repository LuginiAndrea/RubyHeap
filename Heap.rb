require_relative 'InnerHeapElement'
require_relative 'HeapElement'

class Heap 
    include Enumerable

    @elements = [] #of Inner_Heap_Elements
    @capacity = -1 # -1 = infinite capacity
    @UPDATE_F #the update function passed to children

    attr_reader :capacity, :UPDATE_F

    def initialize(capacity = -1, update_f = ->(i){})
        raise TypeError, "Update container has to be callable" unless update_f.respond_to?(:call)
        @elements = []
        @capacity = capacity
        @UPDATE_F = update_f
    end

    def insert(new_node) 
        return false if @elements.size == @capacity && @capacity != -1 #Check if we exceed capacity 
        if Heap_Element.is_compatible? new_node
            new_node.extend(Key_Method) #If compatible add the key function at runtime
        else
            new_node = Heap_Element.new(new_node)
        end
        new_inner_node = Inner_Heap_Element.new(new_node, @UPDATE_F)
        @elements.push new_inner_node
        @UPDATE_F.call @elements.size-1
        return true
    end

    def <<(new_node)
        return self.insert new_node
    end

    def delete(start_index, end_index = nil)
        end_index = start_index if end_index.nil? #if end_index is nil it's a single position delete at position start_index
        if @elements[start_index..end_index] == @elements
            self.clear #if the whole array is selected the clear method is called
        else 
            for i in start_index...end_index
                self.delete_at i #delete for every position 
            end
        end
    end

    def clear()
        @elements = []
    end

    #---- Accessors
    def at(index) 
        return @elements[index]
    end

    def [](index)
        return self.at index
    end

    def search (value, start_index = 0)
        return @elements[start_index..-1].find_index { |node| node.value == value }
    end

    def each(&block) 
        @elements.each(&block)
    end

    # ----- Conversions 
    def to_array()
        ret_arr = @elements.map { |node| [node.value, node.extract_key] }
        return ret_arr
    end

    def self.from_array(array, capacity = -1, update_f = ->(i){})
        new_heap = Heap.new(capacity,update_f)
        array.each { |new_elem| new_heap << new_elem } 
        return new_heap
    end

    #------- Get functions
    def parent_index(i)
        return ((i-1) / 2).floor unless i == 0 
        return 0 
    end

    def children_indexes (i)
        left_child_index = i*2+1
        right_child_index = left_child_index + 1
        return [(left_child_index >= @elements.size) ? nil : left_child_index,
                (right_child_index >= @elements.size) ? nil : right_child_index]
    end

    def size()
        return @elements.size
    end

private

    def delete_at(index) #single delete func
        @elements[index] = @elements.last #the rightest leaf takes the place of the deleted element
        @elements.pop
        @UPDATE_F.call index #update the list
    end
end



module RBMusicTheory
  
  class ValuePrimitive
  
    attr_reader :value

     def initialize(val)
       @value = val
     end

     def eql?(other)
       @value == other.value
     end

     def hash
       #puts "hash was called"
       @value
     end
  
    def ==(other)
      @value == other.value
    end

    def plus_interval(interval)
      if interval.kind_of?(Fixnum)
        self.class.new(@value + interval)
      elsif interval.kind_of?(NoteInterval)
        self.class.new(@value + interval.value)
      else
        raise TypeError, "argument must be Fixnum or NoteInterval"
      end
    end
    alias + plus_interval

    def minus_interval(interval)
      if interval.kind_of?(Fixnum)
        self.class.new(@value - interval)
      elsif interval.kind_of?(NoteInterval)
        self.class.new(@value - interval.value)
      else
        raise TypeError, "argument must be Fixnum or NoteInterval"
      end
    end
    alias - minus_interval

    def <(other_interval) 
      self.value < other_interval.value
    end

    def >(other_interval)
      self.value > other_interval.value
    end

    def <=(other_interval)
      self.value <= other_interval.value
    end

    def <=>(other_interval)
      self.value <=> other_interval.value
    end

  end
end
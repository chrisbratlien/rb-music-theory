class NoteInterval
  
  attr_reader :value
  
  def initialize(val)
    @value = val
  end

  def eql?(other_ni)
    @value == other_ni.value
  end
  
  def hash
    #puts "hash was called"
    @value
  end

  def short_name
    names = ["1", "b2", "2", "b3", "3", "4", "b5", "5", "#5", "6", "b7", "7",
             "8", "b9", "9", "#9","10","11","#11","12","b13","13","#13"][@value]
  end
    
  def plus_interval(i)
    NoteInterval.new(@value + i.value)
  end
  
  def self.unison
    NoteInterval.new(0)
  end
  
  def self.min2 #minor_second
    NoteInterval.new(1)
  end
  def self.maj2 #major_second
    NoteInterval.new(2)
  end
  def self.min3 #minor_third
    NoteInterval.new(3)
  end
  def self.maj3 #major_third
    NoteInterval.new(4)
  end
  def self.per4 #perfect_fourth
    NoteInterval.new(5)
  end
  def self.aug4 #augmented_fourth
    NoteInterval.new(6)
  end  
  def self.dim5 #diminished_fifth
    NoteInterval.new(6)
  end  
  def self.b5
    NoteInterval.new(6)
  end
  
  def self.per5 #perfect_fifth
    NoteInterval.new(7)
  end
  
  def self.sharp5
    NoteInterval.new(8)
  end
  
  def self.min6 #minor_sixth
    NoteInterval.new(8)
  end
  
  def self.maj6 #major_sixth
    NoteInterval.new(9)
  end
  def self.bb7 #doubly flattened seventh (used in dim7 chord)
    NoteInterval.new(9)
  end

  def self.b7 # flattened seventh
    NoteInterval.new(10)
  end  
  def self.min7 #minor_seventh
    NoteInterval.new(10)
  end
  
  def self.maj7 #major_seventh
    NoteInterval.new(11)
  end
  def self.octave
    NoteInterval.new(12)
  end
  
  def self.b9  #flat ninth
    NoteInterval.new(13)
  end
      
  def self.maj9 #major_ninth
    NoteInterval.new(14)
  end
  def self.sharp9
    NoteInterval.new(15)
  end

  def self.maj11 #major_eleventh
    NoteInterval.new(17)
  end
  def self.maj13 #major_thirteenth
    NoteInterval.new(21)
  end
end

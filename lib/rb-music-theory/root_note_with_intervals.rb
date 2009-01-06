require 'set'

module RBMusicTheory
  
  class RootNoteWithIntervals
  
    attr_reader :root_note, :intervals
 
   def initialize(root_note,intervals)
     @root_note = root_note
     if intervals.kind_of?(Array)
       @intervals = SortedSet.new(intervals.to_set)
     elsif intervals.kind_of?(Set)
       @intervals = SortedSet.new(intervals)
     end
   end
 
   def notes
     @intervals.map{|i| @root_note.plus_interval(i)}
   end

   def note_names
     self.notes.map{|n| n.name}
   end
 
   def note_values
     self.notes.map{|n| n.value}
   end

   def interval_names
     @intervals.map{|i| i.short_name}
   end
 
   def interval_values
     @intervals.map{|i| i.value}
   end
  
   def nin_pairs
     # [NoteInterval,Note] pairs
     @intervals.map{|i| [i,@root_note.plus_interval(i)]}
   end

   def add(more)
     if more.kind_of?(Note)
       add_note(more)
     elsif more.kind_of?(NoteInterval)
       self.class.new(@root_note,@intervals + Set.new([more].to_set))
      elsif more.kind_of?(RootNoteWithIntervals)
        add_similar(more)
     else
       self.class.new(@root_note,@intervals + Set.new(more))
     end
   end
   alias + add
   alias add_intervals add
   alias add_interval add

  def add_note(note)
    self.class.new(@root_note,@intervals + Set.new([NoteInterval.new(@root_note.distance_to(note))].to_set))
  end

  def add_similar(other)
    self.class.new(@root_note,@intervals + other.notes.map{|n| NoteInterval.new(@root_note.distance_to(n))}.to_set )
  end


   #def add_interval(i)
  #   add_intervals([i].to_set)
  # end

   def remove(less)
     if less.kind_of?(Note)
       remove_note(less)
     elsif less.kind_of?(NoteInterval)
       self.class.new(@root_note,@intervals - Set.new([less].to_set))
     elsif less.kind_of?(RootNoteWithIntervals)
       remove_similar_by_note_names(less)
     else
       self.class.new(@root_note,@intervals - Set.new(less))
     end
   end
   alias - remove
   alias remove_intervals remove
   alias remove_interval remove
 
 
   def remove_note(note)
     self.class.new(@root_note,@intervals.reject{|i| @root_note + i == note})
   end
 
   def remove_similar_by_note_names(other)
     self.class.new(@root_note,@intervals.reject{|i| other.contains_note_names_of?(@root_note + i)})
   end
 
   def remove_similar_by_note_values(other)
     self.class.new(@root_note,@intervals.reject{|i| other.contains_note_values_of?(@root_note + i)})
   end
 
 
   #def remove_interval(i)
  #   remove_intervals([i])
  # end

   def replace_interval(o,n)
     remove_interval(o).add_interval(n)
   end


   def invert_with_new_tonic
     self.class.new(notes[1],NoteInterval.zero_set(NoteInterval.shift_to_top(@intervals)))
   end

   def old_invert_with_new_tonic
      # remove the first entry and append it to the end of the array as an octave higher than itself
      offset = notes[0].distance_to(notes[1])
      sorted = @intervals[1..-1].uniq.sort{|a,b| a.value <=> b.value}
      sorted = sorted << (@intervals[0] + 12)
      self.class.new(notes[1],sorted.map{|i| i - offset})
    end

    def invert_once
      self.class.new(@root_note,NoteInterval.shift_set(@intervals.to_a))
    end
  
    def invert_to_top
      self.class.new(@root_note,NoteInterval.shift_to_top(@intervals.to_a))
    end
    
    alias invert invert_to_top


    def contains_note_value?(val)
      self.note_values.include?(val)
    end

    def contains_note_values_of?(other)
      if other.kind_of?(Note)
        self.contains_note_value?(other.value)
      else
        self.note_values.to_set.superset?(other.note_values.to_set)
      end
    end
  
    def note_values_contained_by?(other)
      other.contains_note_values_of?(self)
    end


    def contains_note_names_of?(other)
     if other.kind_of?(Note)
       self.note_names.to_set.superset?(Set.new([other.name]))
     else
       self.note_names.to_set.superset?(other.note_names.to_set)
     end
    end
  
    def note_names_contained_by?(other)
      other.contains_note_names_of?(self)
    end
  
  end
end
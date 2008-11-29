class RootNoteWithIntervals
  
  attr_reader :root_note, :intervals
 
 def initialize(root_note,intervals)
   @root_note = root_note
   @intervals = intervals
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

 def add_intervals(more)
   sorted = (@intervals + more).uniq.sort{|a,b| a.value <=> b.value}
   self.class.new(@root_note,sorted)
 end

 def add_interval(i)
   add_intervals([i])
 end

 def remove_intervals(less)
   self.class.new(@root_note,@intervals - less)
 end
 
 def remove_interval(i)
   remove_intervals([i])
 end

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
    self.class.new(@root_note,NoteInterval.shift_set(@intervals))
  end
  
  def invert_to_top
    self.class.new(@root_note,NoteInterval.shift_to_top(@intervals))
  end
    
  alias invert invert_to_top
 
 def contains?(other)
   if other.kind_of?(Note)
     self.note_names.to_set.superset?(Set.new(other.name))
   else
     self.note_names.to_set.superset?(other.note_names.to_set)
   end
 end
  
 def contained_by?(other)
   other.contains?(self)
 end
  
end
 
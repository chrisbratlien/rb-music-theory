class Chord
  attr_reader :intervals, :notes
  
  def initialize(root_note,intervals)
    @root_note = root_note
    @intervals = intervals
  end
  
  def invert
    # remove the first entry and append it to the end of the array as an octave higher than itself
    #Chord.new(@root_note,@intervals[1..-1] << @intervals[0].plus_interval(NoteInterval.octave))
    replace_interval(@intervals[0],@intervals[0].plus_interval(NoteInterval.octave))
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
    @intervals.map{|i| [i,@root_note.plus_interval(i)]}
  end
  
  def add_intervals(more)
    sorted = (@intervals + more).uniq.sort{|a,b| a.value <=> b.value}
    Chord.new(@root_note,sorted)
  end

  def add_interval(i)
    add_intervals([i])
  end

  def remove_intervals(less)
    Chord.new(@root_note,@intervals - less)
  end
  
  def remove_interval(i)
    remove_intervals([i])
  end

  def replace_interval(o,n)
    remove_interval(o).add_interval(n)
  end
  
end  

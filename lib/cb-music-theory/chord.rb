class Chord < RootNoteWithIntervals
    
  def invert
    # remove the first entry and append it to the end of the array as an octave higher than itself
    offset = notes[0].distance_to(notes[1])
    sorted = @intervals[1..-1].uniq.sort{|a,b| a.value <=> b.value}
    sorted = sorted << (@intervals[0] + 12)
    Chord.new(notes[1],sorted.map{|i| i - offset})
  end

  # i'm testing to see if I want an inversion to truly change the root note of the chord.

  # the older versions of invert only invert the intervals and leave the root_note alone
  
  def old_invert
    #replace_interval(@intervals[0],@intervals[0].plus_interval(NoteInterval.octave))
  end
  
  def old_invert2
    #Chord.new(@root_note,@intervals[1..-1] << @intervals[0].plus_interval(NoteInterval.octave))    
  end
  
  
  
  
end  

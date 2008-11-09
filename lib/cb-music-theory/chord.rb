class Chord < RootNoteWithIntervals


  # i'm testing to see if I want an inversion to truly change the root note of the chord.

  # the older versions of invert only invert the intervals and leave the root_note alone
  
  def old_invert
    #replace_interval(@intervals[0],@intervals[0].plus_interval(NoteInterval.octave))
  end
  
  def old_invert2
    #Chord.new(@root_note,@intervals[1..-1] << @intervals[0].plus_interval(NoteInterval.octave))    
  end
  
  
  
  
end  

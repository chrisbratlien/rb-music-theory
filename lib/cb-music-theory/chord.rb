class Chord < RootNoteWithIntervals
    
  def invert
    # remove the first entry and append it to the end of the array as an octave higher than itself
    #Chord.new(@root_note,@intervals[1..-1] << @intervals[0].plus_interval(NoteInterval.octave))
    replace_interval(@intervals[0],@intervals[0].plus_interval(NoteInterval.octave))
  end
  
  
  
end  

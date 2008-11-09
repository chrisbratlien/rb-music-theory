class Scale < RootNoteWithIntervals
    
  def interval_for_degree(pos)
    count = @intervals.size
    octaves = (pos - 1) / count
    degrees = pos % count
    total_interval = NoteInterval.new(octaves*12)
    total_interval = total_interval.plus_interval(@intervals[degrees-1])
  end
    
  def degree(pos)
    interval = interval_for_degree(pos)
    @root_note.plus_interval(interval)
  end
  
  def degree_triad(deg)
    self.harmonized_chord(1,[1,3,5])
  end
    
  def all_degree_triads
    (1..@intervals.size).to_a.map{|d| self.degree_triad(d)}
  end
  
  def harmonized_chord(start_degree,degrees)
    intervals = degrees.map{|n|  NoteInterval.new(self.degree(start_degree).distance_to(self.degree(start_degree + n - 1)))}
    Chord.new(self.degree(start_degree),intervals)
  end

  def all_harmonized_chords(degrees)
    (1..@intervals.size).to_a.map{|d| self.harmonized_chord(d,degrees)}
  end
  
end


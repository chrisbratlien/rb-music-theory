class Scale < RootNoteWithIntervals
  
  def self.chromatic_scale(root_note)
    Scale.new(root_note,(0..11).to_a.map{|n| NoteInterval.new(n)})
  end
  
  def self.major_scale(root_note)
    Scale.new(root_note,
      [
        NoteInterval.unison,
        NoteInterval.maj2,
        NoteInterval.maj3,
        NoteInterval.per4,
        NoteInterval.per5,
        NoteInterval.maj6,
        NoteInterval.maj7
      ])
  end
  
  def self.natural_minor_scale(root_note)
    Scale.new(root_note,
      [
        NoteInterval.unison,
        NoteInterval.maj2,
        NoteInterval.min3,
        NoteInterval.per4,
        NoteInterval.per5,
        NoteInterval.min6,
        NoteInterval.min7
        ])
  end

  def self.harmonic_minor_scale(root_note)
    Scale.new(root_note,
      [
        NoteInterval.unison,
        NoteInterval.maj2,
        NoteInterval.min3,
        NoteInterval.per4,
        NoteInterval.per5,
        NoteInterval.min6,
        NoteInterval.maj7
        ])
  end

  def self.melodic_minor_scale(root_note)
    Scale.new(root_note,
      [
        NoteInterval.unison,
        NoteInterval.maj2,
        NoteInterval.min3,
        NoteInterval.per4,
        NoteInterval.per5,
        NoteInterval.maj6,
        NoteInterval.maj7
        ])
  end



  
  def interval_for_degree(pos)
    octaves = (pos - 1) / 7
    degrees = pos % 7
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
    [1,2,3,4,5,6,7].map{|d| self.degree_triad(d)}
  end
  
  def harmonized_chord(start_degree,degrees)
    intervals = degrees.map{|n|  NoteInterval.new(self.degree(start_degree).distance_to(self.degree(start_degree + n - 1)))}
    Chord.new(self.degree(start_degree),intervals)
  end

  def all_harmonized_chords(degrees)
    [1,2,3,4,5,6,7].map{|d| self.harmonized_chord(d,degrees)}
  end
  
end


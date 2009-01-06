module RBMusicTheory
  
  class Scale < RootNoteWithIntervals
    
    def interval_for_degree(pos)
      count = @intervals.size
      octaves = (pos - 1) / count
      degrees = pos % count
      total_interval = NoteInterval.new(octaves*12)
      total_interval = total_interval.plus_interval(@intervals.to_a[degrees-1])
    end
    
    def degree(pos)
      interval = interval_for_degree(pos)
      @root_note.plus_interval(interval)
    end
  
    def degree_triad(deg)
      self.harmonized_chord(deg,:major_chord)
    end
    
    def all_degree_triads
      (1..@intervals.size).to_a.map{|d| self.degree_triad(d)}
    end
    
    def harmonized_chord(start_degree,chord_name)
      root_chord = @root_note.send(chord_name)
      if self.contains_note_names_of?(root_chord)
  
        degrees = (1..@intervals.size*2).to_a.select{|d| root_chord.contains_note_values_of?(self.degree(d))}
        #puts "-----=="
        #puts degrees
        #puts "----=="
        intervals = degrees.map{|n|  NoteInterval.new(self.degree(start_degree).distance_to(self.degree(start_degree + n - 1)))}.sort
        #puts intervals
        Chord.new(self.degree(start_degree),intervals)        
      else
        "#{chord_name} is an invalid chord for this scale"
      end
    end

    def all_harmonized_chords(chord_name)
      (1..@intervals.size).to_a.map{|d| self.harmonized_chord(d,chord_name)}
    end

    def valid_chord_names_for_degree(d)
      Note.chord_methods.select{|m| self.contains_note_names_of?(self.degree(d).send(m)) }
    end
  end
end
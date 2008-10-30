class Scale
  
  attr_reader :intervals
  
  def initialize(root_note,intervals)
    @root_note = root_note
    @intervals = intervals
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
    # build a triad using deg as the root note, and then skip a degree to pick the next two notes of the triad
      intervals = [deg,deg+2,deg+4].map{|n|
        NoteInterval.new(self.degree(deg).distance_to(self.degree(n)))
      }
    Chord.new(self.degree(deg),intervals)
  end
  
  def all_degree_triads
    [1,2,3,4,5,6,7].map{|d| self.degree_triad(d)}
  end
  
end


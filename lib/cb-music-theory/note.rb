
class Note
  
  attr_reader :value

  def self.twelve_tones
    ["C","C#","D","D#","E","F","F#","G","G#","A","A#","B"]
  end

  def initialize(val)
    @value = val
  end

  def ==(other_note)
    @value == other_note.value
  end
  

  def self.from_name(n)
    #default to octave #4 (see MIDI reference at http://www.harmony-central.com/MIDI/Doc/table2.html)
    Note.new(Note.twelve_tones.index(n) + 60)
  end
  
  
  def plus_interval(interval)
    Note.new(@value + interval.value)
  end

  def distance_to(interval)
    interval.value - @value
  end

  def octave
    (@value / 12) - 1
  end
  
  def name
    Note.twelve_tones[@value % 12]
  end
    
  def major_scale
    Scale.major_scale(self)
  end
  
  def chord_methods
    self.methods.select{|m| m =~ Regexp.new(/chord$/)}
  end
  
  def scale_methods
    self.methods.select{|m| m =~ Regexp.new(/scale$/)}
  end
  
  def major_chord
    Chord.new(self,[NoteInterval.unison,NoteInterval.maj3,NoteInterval.per5])
  end
  
  def minor_chord
    Chord.new(self,[NoteInterval.unison,NoteInterval.min3,NoteInterval.per5])
  end
  
  def dim_chord
    Chord.new(self,[NoteInterval.unison,NoteInterval.min3,NoteInterval.dim5])
  end
  
  def aug_chord
    Chord.new(self,[NoteInterval.unison,NoteInterval.maj3,NoteInterval.sharp5])
  end
      
  def fifth_chord
    Chord.new(self,[NoteInterval.unison,NoteInterval.per5])
  end
    
  def sus2_chord
    fifth_chord.add_interval(NoteInterval.maj2)
  end

  def sus4_chord
    fifth_chord.add_interval(NoteInterval.per4)
  end
  
  def dim7_chord
    dim_chord.add_interval(NoteInterval.bb7)
  end
  
  def half_dim_chord
    dim_chord.add_interval(NoteInterval.b7)
  end
  
  def seventh_chord
    major_chord.add_interval(NoteInterval.b7)
  end
  alias dom7_chord seventh_chord
  
  def min7_chord
    minor_chord.add_interval(NoteInterval.min7)
  end

  def maj7_chord
    major_chord.add_interval(NoteInterval.maj7)
  end
    
  def minmaj7_chord
    minor_chord.add_interval(NoteInterval.maj7)
  end

  def seventh_sus2_chord
    sus2_chord.add_interval(NoteInterval.b7)
  end

  def seventh_sus4_chord
    sus4_chord.add_interval(NoteInterval.b7)
  end
  
  def add2_chord
    major_chord.add_interval(NoteInterval.maj2)
  end
  
  def add9_chord
    major_chord.add_interval(NoteInterval.maj9)
  end
  
  def add4_chord
    major_chord.add_interval(NoteInterval.per4)
  end
  
  def sixth_chord
    major_chord.add_interval(NoteInterval.maj6)
  end
  
  def min6_chord
    minor_chord.add_interval(NoteInterval.maj6)
  end
  
  def six_nine_chord
    sixth_chord.add_interval(NoteInterval.maj9)
  end
  
  def ninth_chord
    seventh_chord.add_interval(NoteInterval.maj9)
  end
  
  def min9_chord
    min7_chord.add_interval(NoteInterval.maj9)
  end
  
  def maj9_chord
    maj7_chord.add_interval(NoteInterval.maj9)
  end
  
  def eleventh_chord
    ninth_chord.add_interval(NoteInterval.maj11)
  end
  
  def min11_chord
    min9_chord.add_interval(NoteInterval.maj11)
  end

  def maj11_chord
    maj9_chord.add_interval(NoteInterval.maj11)
  end

  def thirteenth_chord
    eleventh_chord.add_interval(NoteInterval.maj13)
  end
  
  def min13_chord
    min11_chord.add_interval(NoteInterval.maj13)
  end
  
  def maj13_chord
    maj11_chord.add_interval(NoteInterval.maj13)
  end
  
  def seventh_sharp9_chord
    seventh_chord.add_interval(NoteInterval.sharp9)
  end

  def seventh_b9_chord
    seventh_chord.add_interval(NoteInterval.b9)
  end

  def seventh_sharp5_chord
    seventh_chord.replace_interval(NoteInterval.per5,NoteInterval.sharp5)
  end

  def seventh_b5_chord
    seventh_chord.replace_interval(NoteInterval.per5,NoteInterval.b5)
  end

end

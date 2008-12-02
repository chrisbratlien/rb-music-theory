module CBMusicTheory
  
  class Note < ValuePrimitive

    # define a bunch of scale instance methods  (ex: Note.major_scale)
    NoteInterval::SCALE_SETS.each do |symbol,value|
      method_name = symbol.to_s + '_scale'
      Note.send :define_method, method_name.to_sym do
        intervals = NoteInterval.locate_it(symbol,NoteInterval::SCALE_SETS).map{|n| NoteInterval.new(n)}          
        Scale.new(self,intervals)
      end
    end

    # define a bunch of chord instance methods  (ex: Note.min7_chord)
    NoteInterval::CHORD_SETS.each do |symbol,value|
      method_name = symbol.to_s + '_chord'
      Note.send :define_method, method_name.to_sym do          
        intervals = NoteInterval.locate_it(symbol,NoteInterval::CHORD_SETS).map{|n| NoteInterval.new(n)}          
        Chord.new(self,intervals)
      end
    end
  
    def self.twelve_tones
      ["C","C#","D","D#","E","F","F#","G","G#","A","A#","B"]
    end

    def self.flat_twelve_tones
      ["C","Db","D","Eb","E","F","Gb","G","Ab","A","Bb","B"]
    end

    def initialize(var = nil)
      if var.kind_of?(String)
        @value = Note.value_from_name(var)
      else
        @value = var
      end
    end

  
    def self.value_from_name(name)
      #The octave isn't supplied, so 
      #default to octave #4 (see MIDI reference at http://www.harmony-central.com/MIDI/Doc/table2.html)
      result = Note.twelve_tones.index(name) || Note.flat_twelve_tones.index(name)
      result += 60
    end

    def self.name_from_value(v)
      Note.twelve_tones[v % 12]
    end

    def distance_to(other)
      other.value - @value
    end

    def octave
      (@value / 12) - 1
    end
  
    def name
      Note.name_from_value(@value)
    end    

    def self.chord_methods
      Note.instance_methods.select{|m| m =~ Regexp.new(/chord$/)}
    end
  
    def self.scale_methods
      Note.instance_methods.select{|m| m =~ Regexp.new(/scale$/)}
    end
  
    def self.random_scale_method
      (Note.scale_methods - ["chromatic_scale"]).pick
    end
  
    def self.random_chord_method
      Note.chord_methods.pick
    end

    def self.random_chord_or_scale_method
      [Note.random_chord_method,Note.random_scale_method].pick
    end

  end
end
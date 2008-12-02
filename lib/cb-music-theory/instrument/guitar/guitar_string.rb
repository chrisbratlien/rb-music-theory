module CBMusicTheory
  
  class GuitarString
    attr_reader :fretted,:intervals
  
    def initialize(open_note)
      @open_note = open_note
      @fretted = []
      @intervals = []
      24.times { 
        @fretted << nil
        @intervals << nil
      }
    end

    def note_at_fret(num)
      @open_note.plus_interval(NoteInterval.new(num))
    end
  
    def interval_at_fret(num)
      @intervals[num]
    end
  
  
    def be_fretted_at(num)
      @fretted[num] = true
    end
  
    def fret_this_note(note)
      0.upto(24) {|f|
        if note.name == note_at_fret(f).name
          be_fretted_at(f)
        end
      }
    end
  
    def fret_these_notes(notes)
      notes.each{|n| fret_this_note(n)}
    end
  
    def fret_this_nin_pair(pair)
      interval = pair[0]
      note = pair[1]    
      0.upto(24) {|f|
        if note.name == note_at_fret(f).name
          be_fretted_at(f)
          @intervals[f] = interval
        end
      }
    end
  
    def fret_these_nin_pairs(pairs)
      pairs.each{|np| fret_this_nin_pair(np) }
    end

  
    def is_fretted_at?(num)
      @fretted[num]
    end
  
  end
end


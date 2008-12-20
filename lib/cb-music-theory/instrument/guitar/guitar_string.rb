module CBMusicTheory
  
  class GuitarString
    attr_reader :fretted,:intervals, :open_note
  
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
      @open_note + num
    end
    
    def frets_for_note_name(n,not_below_fret = 0)
      (not_below_fret..24).to_a.select{|f| note_at_fret(f).name == n}
    end
    
    def first_fret_for_note_name(n,not_below_fret = 0)
      frets_for_note_name(n,not_below_fret).first
    end
    
    def interval_at_fret(num)
      @intervals[num]
    end
  
    def be_fretted_at!(num,interval = nil)
      @fretted[num] = true
      @intervals[num] = interval
    end
  
    def fret_this_note!(note)
      0.upto(24) {|f|
        if note.name == note_at_fret(f).name
          be_fretted_at(f)
        end
      }
    end
        
    def fret_these_notes!(notes)
      notes.each{|n| fret_this_note!(n)}
    end
  
    def fret_this_nin_pair!(pair)
      interval = pair[0]
      note = pair[1]    
      0.upto(24) {|f|
        if note.name == note_at_fret(f).name
          be_fretted_at!(f,interval)
        end
      }
    end
  
    def fret_these_nin_pairs!(pairs)
      pairs.each{|np| fret_this_nin_pair!(np) }
    end

    def fretted?
      @fretted.detect{|x| x}
    end
  
    def is_fretted_at?(num)
      @fretted[num]
    end
  
    def be_unfretted!
      @fretted = @fretted.map{|x| nil}
      @intervals = @intervals.map{|x| nil}
    end
    
    def fretted_interval
      result = @intervals.detect{|x| x}
    end

  end
end


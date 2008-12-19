module CBMusicTheory
  class Guitar

    def initialize
      @strings = []
      open_string_pitches = [64,59,55,50,45,40]
      open_string_pitches.each{|pitch|
        @strings << GuitarString.new(Note.new(pitch))
      }
    end
  
    def string(num)
      @strings[num-1]
    end
  
    def fret_these_notes(notes)
      @strings.each{|s| s.fret_these_notes(notes)}
    end
  
    def fret_these_nin_pairs(pairs)
      @strings.each{|s| s.fret_these_nin_pairs(pairs)}
    end
    
    def fret_this_chord(chord)

      root_note = chord.root_note
      low_note = chord.notes[0]
      med_note = chord.notes[1]
      high_note  = chord.notes[2]
            
      #so far, assuming the root note is on 5th string
      
      low_note_fret = @strings[4].first_fret_for_note_name(low_note.name)
      window_low = low_note_fret - 0
      if window_low < 0
        window_low = 0
      end
      window_high = low_note_fret + 2

      #puts '---'
      #puts chord.nin_pairs.map{|x,y| x.short_name}
      #puts '---'
      
      done = {}
      chord.intervals.each {|i|
        n = chord.root_note + i
        @strings.each{|s|
          (window_low..window_high).to_a.each{|f|
            if !s.fretted? and !done[n] and f == s.first_fret_for_note_name(n.name)
              s.be_fretted_at(f,i)
              done[n] = true
            end
            }
          }
        }

      ##fret on string 5
      ##chord.notes.each{|n| @strings.each{|s| s.fret_just_this_nin_pair([n,chord.interval_for_note(n)]}}
    end
    
  end  

end
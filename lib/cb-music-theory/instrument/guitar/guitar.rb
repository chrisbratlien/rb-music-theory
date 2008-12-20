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
  
    def fret_these_notes!(notes)
      @strings.each{|s| s.fret_these_notes(notes)}
    end
  
    def fret_these_nin_pairs!(pairs)
      @strings.each{|s| s.fret_these_nin_pairs!(pairs)}
    end
    
    def fretted_intervals
      @strings.map{|s| s.fretted_interval}
    end
    
    def interval_is_fretted?(i)
      interval_fretted_count(i) > 0
    end
    
    def interval_fretted_count(i)
      fretted_intervals.select{|fi| fi == i}.size
    end


    def foo(chord,target_strings,window_low,window_high)
      (1..3).to_a.each{|pass|
        chord.intervals.each {|i|
          n = chord.root_note + i
          (window_low..window_high).to_a.each{|f|
            target_strings.each{|s|
              if s.frets_for_note_name(n.name).to_set.include?(f)
                if !s.fretted? or (s.fretted? and !interval_is_fretted?(i) and interval_fretted_count(s.fretted_interval) > 1)
                  if s.fretted? 
                    puts "pass #{pass} trying interval #{i.short_name} note #{n.name} on #{s.open_note.name} string fret #{f} and undoing #{s.fretted_interval.short_name}"
                  end
                  s.be_unfretted!
                  if pass > 1
                    puts "pass > 1 *hit*"
                    puts "pass #{pass} trying interval #{i.short_name} note #{n.name} on #{s.open_note.name} string fret #{f}"
                  end
                  s.be_fretted_at!(f,i)
                end
              end
            }
          }
        }
      }
    end

    
    def fret_this_chord!(chord,not_below_fret = 0)

      root_note = chord.root_note
      low_note = chord.notes[0]
      low_interval = chord.intervals.to_a.first
      
      #so far, assuming the root note is on 5th string
      
      low_note_fret = string(5).first_fret_for_note_name(low_note.name,not_below_fret)
  
      string(5).be_fretted_at!(low_note_fret,low_interval)
      foo(chord,(1..4).map{|s| string(s)},[low_note_fret - 0,0].max,low_note_fret + 2)


      #todo, in trying alternative frettings, consider:
        #- number of notes vs available strings
        #- size of fret window
        #- what would calling a root_6 chord look like
        # - it involves refactoring the start_at_fret assumption in fretboard_with_harmonized_scale template
        
        
        
      strays = chord.intervals.select{|i| !interval_is_fretted?(i)}
      if !strays.empty?
         puts "retry 2"
         self.be_unfretted!  #the whole guitar tells each string to be unfretted        
         string(5).be_fretted_at!(low_note_fret,low_interval)
         foo(chord,(1..4).map{|s| string(s)},[low_note_fret - 1,0].max,low_note_fret + 1)
       end
 
  
    strays = chord.intervals.select{|i| !interval_is_fretted?(i)}
    if !strays.empty?
       puts "retry 3"
       self.be_unfretted!  #the whole guitar tells each string to be unfretted        
       string(5).be_fretted_at!(low_note_fret,low_interval)
       foo(chord,(1..4).map{|s| string(s)},[low_note_fret - 1,0].max,low_note_fret + 2)
     end

        strays = chord.intervals.select{|i| !interval_is_fretted?(i)}
        if !strays.empty?
          puts "retry 4"
           self.be_unfretted!  #the whole guitar tells each string to be unfretted        
           string(5).be_fretted_at!(low_note_fret,low_interval)
           foo(chord,(1..4).map{|s| string(s)},[low_note_fret - 2,0].max,low_note_fret + 0)
         end



    strays = chord.intervals.select{|i| !interval_is_fretted?(i)}
    if !strays.empty?
      puts "retry 5"
      self.be_unfretted!  #the whole guitar tells each string to be unfretted        
      string(5).be_fretted_at!(low_note_fret,low_interval)
      foo(chord,(1..4).map{|s| string(s)},[low_note_fret - 2,0].max,low_note_fret + 1)
    end

    strays = chord.intervals.select{|i| !interval_is_fretted?(i)}
    if !strays.empty?
    puts "STILL stranded "
    puts "#{chord.note_names} #{strays.map{|si| si.short_name}.join(',') }"
    end
             
    #puts done.inspect
      ##fret on string 5
      ##chord.notes.each{|n| @strings.each{|s| s.fret_just_this_nin_pair([n,chord.interval_for_note(n)]}}
    end
    
  end  

  def be_unfretted!
    @strings.each{|s| s.be_unfretted!}
  end

end
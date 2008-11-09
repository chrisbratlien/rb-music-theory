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
  
  
end  
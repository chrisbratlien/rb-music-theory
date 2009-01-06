module RBMusicTheory
  
  class NoteInterval < ValuePrimitive
  
    def short_name
      names = ["1", "b2", "2", "b3", "3", "4", "b5", "5", "#5", "6", "b7", "7",
               "8", "b9", "9", "#9","10","11","#11","12","b13","13","#13","14","15"][@value]
    end

    INTERVAL_NAMES = {
      :unison => 0,
      :min2   => 1,
      :maj2   => 2,
      :min3   => 3,
      :maj3   => 4,
      :per4   => 5,
      :aug4   => 6, 
      :dim5 => :aug4, 
      :b5 => :aug4,
      :per5   => 7,
      :sharp5 => 8, 
      :aug5 => :sharp5, 
      :min6 => :sharp5, 
      :maj6 => 9, 
      :bb7 => :maj6,
      :min7 => 10, 
      :b7 => :min7,
      :maj7 => 11,
      :octave => 12,
      :min9 => 13, 
      :b9 => :min9,
      :maj9 => 14,
      :aug9 => 15, 
      :sharp9 => :aug9,    
      :min11 => 16, 
      :b11 => :min11,
      :maj11 => 17,
      :sharp11 => 18,
      :maj12 => 19,
      :min13 => 20, 
      :b13 => :min13,
      :maj13 => 21,
      :sharp13 => 22,
      :maj14 => 23
    }

   SCALE_SETS = {
     :chromatic               => [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11],
     :ionian                  => [0, 2, 4, 5, 7, 9, 11],
     :major                   => :ionian,
     :dorian                  => [0, 2, 3, 5, 7, 9, 10],
     :phrygian                => [0, 1, 3, 5, 7, 8, 10],
     :lydian                  => [0, 2, 4, 6, 7, 9, 11],
     :mixolydian              => [0, 2, 4, 5, 7, 9, 10],
     :aeolian                 => [0, 2, 3, 5, 7, 8, 10],
     :natural_minor           => :aeolian,
     :locrian                 => [0, 1, 3, 5, 6, 8, 10],
     :harmonic_minor          => [0, 2, 3, 5, 7, 8, 11],
     :melodic_minor           => [0, 2, 3, 5, 7, 9, 11],
     :whole_tone              => [0, 2, 4, 6, 8, 10],
     :diminished              => [0, 2, 3, 5, 6, 8, 9, 11],
     :major_pentatonic        => [0, 2, 4, 7, 9],
     :minor_pentatonic        => [0, 3, 5, 7, 10],
     :minor_major_pentatonic  => [0, 2, 3, 4, 5, 7, 9, 10],
     :enigmatic               => [0, 1, 4, 6, 8, 10, 11],
     :major_neapolitan        => [0, 1, 3, 5, 7, 9, 11],
     :minor_neapolitan        => [0, 1, 3, 5, 7, 8, 11],
     :minor_hungarian         => [0, 2, 3, 6, 7, 8, 11]
   }

   CHORD_SETS = {
      :major    => [0,4,7],
      :maj7     => [0,4,7,11],
      :maj9     => [0,4,7,11,14],
      :maj11    => [0,4,7,11,14,17],
            
      :maj_add2 => [0,2,4,7],
      :maj_add4 => [0,4,5,7],
      :maj_add9 => [0,4,7,14],
      :add2     => :maj_add2,
      :add4     => :maj_add4,
      :add9     => :maj_add9,

      :minor      => [0,3,7],
      :min6       => [0,3,7,9],
      :min7       => [0,3,7,10],
      :minmaj7    => [0,3,7,11],
      :min9       => [0,3,7,10,14],
      :min11      => [0,3,7,10,14,17],
      :min13      => [0,3,7,10,14,17,21],
      :min7_flat5 => [0,3,6,10],
      :min7_b5    => :min7_flat5,

      :aug      => [0,4,8],
      :aug_maj7 => [0,4,8,11],
      :aug7     => [0,4,8,10],
      :aug_min7 => :aug7,

      :dim      => [0,3,6],
      :dim7     => [0,3,6,9],
      :half_dim => [0,3,6,10],

      :sixth    => [0,4,7,9],
      :six_nine => [0,4,7,9,14],

      :seventh        => [0,4,7,10], 
      :dom7           => :seventh,
      :ninth          => [0,4,7,10,14],
      :eleventh       => [0,4,7,10,14,17],
      :thirteenth     => [0,4,7,10,14,17,21],
      
      :seventh_sharp9 => [0,4,7,10,15],
      :seventh_flat9  => [0,4,7,10,13],
      :seventh_b9     => :seventh_flat9,
      :seventh_sharp5 => :aug7,
      :seventh_flat5  => [0,4,6,10],
      :seventh_b5     => :seventh_flat5,

      :seventh_sus2 => [0,2,7,10],
      :seventh_sus4 => [0,5,7,10],

      :fifth =>  [0,7],
      :sus2 =>   [0,2,7],
      :sus4 =>   [0,5,7],
   }
 
   def self.locate_it(key,set)
     result = set[key]
     if result.kind_of?(Symbol)
       NoteInterval.locate_it(result,set)
     else
       result
     end
   end

   INTERVAL_NAMES.each do |symbol,value|
      self.class.send :define_method, symbol.to_sym do
        NoteInterval.new(NoteInterval.locate_it(symbol,INTERVAL_NAMES))
      end
    end

   SCALE_SETS.each do |symbol,value|     
     full_method_name = (symbol.to_s + '_set').to_sym     
      self.class.send :define_method, full_method_name.to_sym do
        NoteInterval.locate_it(symbol,SCALE_SETS).map{|n| NoteInterval.new(n)}
      end
    end
    
   CHORD_SETS.each do |symbol,value|     
     full_method_name = (symbol.to_s + '_chord').to_sym     
      self.class.send :define_method, full_method_name.to_sym do
        NoteInterval.locate_it(symbol,CHORD_SETS).map{|n| NoteInterval.new(n)}
      end
    end
 
 
    def self.zero_set(set)
      set.map{|n| n - set[0]}
    end
  
    def self.shift_set(set)
      set[1..-1] << set[0] + 12
    end
  
    def self.shift_to_top(set)
      n = set[0]
      top = set[-1]
      while n <= top
        n += 12
      end
    
      set[1..-1] << n
    end
  
  
    def self.shift_and_zero_set(set)
      NoteInterval.zero_set(NoteInterval.shift_set(set))
    end
  
  end
end
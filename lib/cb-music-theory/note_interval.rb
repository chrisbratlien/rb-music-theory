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

    INTERVAL_NAMES.each do |method_name,value|
       self.class.send :define_method, method_name.to_sym do
         if value.kind_of?(Symbol)
           NoteInterval.new(INTERVAL_NAMES[value])
         else
           NoteInterval.new(value)
         end
       end
     end


 
 SCALE_ARRAYS = {
   :chromatic_set               => (0..11).to_a,
   :ionian_set                  => [0,2,4,5,7,9,11],
   :major_set                   => :ionian_set,
   :dorian_set                  => [0, 2, 3, 5, 7, 9, 10],
   :phrygian_set                => [0, 1, 3, 5, 7, 8, 10],
   :lydian_set                  => [0, 2, 4, 6, 7, 9, 11],
   :mixolydian_set              => [0, 2, 4, 5, 7, 9, 10],
   :aeolian_set                 => [0, 2, 3, 5, 7, 8, 10],
   :natural_minor_set           => :aeolian_set,
   :locrian_set                 => [0, 1, 3, 5, 6, 8, 10],
   :harmonic_minor_set          => [0, 2, 3, 5, 7, 8, 11],
   :melodic_minor_set           => [0, 2, 3, 5, 7, 9, 11],
   :whole_tone_set              => [0, 2, 4, 6, 8, 10],
   :diminished_set              => [0, 2, 3, 5, 6, 8, 9, 11],
   :major_pentatonic_set        => [0, 2, 4, 7, 9],
   :minor_pentatonic_set        => [0, 3, 5, 7, 10],
   :minor_major_pentatonic_set  => [0,2,3,4,5,7,9,10],
   :enigmatic_set               => [0,1,4,6,8,10,11],
   :major_neapolitan_set        => [0,1,3,5,7,9,11],
   :minor_neapolitan_set        => [0,1,3,5,7,8,11],
   :minor_hungarian_set         => [0,2,3,6,7,8,11]
 }
 
 SCALE_ARRAYS.each do |method_name,value|
    self.class.send :define_method, method_name.to_sym do
      if value.kind_of?(Symbol)
        SCALE_ARRAYS[value].map{|n| NoteInterval.new(n)}
      else
        value.map{|n| NoteInterval.new(n)}
      end
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

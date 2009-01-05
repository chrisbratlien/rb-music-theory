#improv sets
players = {}

players[:peggy] = L { |notes,dur| 
  #peggy likes to play arpeggios
  (notes - [notes.last] + notes.reverse).each{|note|  midi.play note, 0.1 * dur }  
}

players[:tap_up] = L { |notes,dur| 
  notes.each{|note| midi.play note, 0.075 * dur }  
}

players[:tap_up_double_stop] = L { |notes,dur| 
  notes.each{|note|  midi.play [note,note+12], 0.075 * dur }  
}

players[:tap_up_high] = L { |notes,dur| 
  notes.each{|note|  [note,note+12].each{|n| midi.play n, 0.075 * dur} }  
}

players[:tap_down] = L { |notes,dur| 
  notes.reverse.each{|note| midi.play note, 0.075 * dur}  
}

players[:tap_down_double_stop] = L { |notes,dur| 
  notes.reverse.each{|note|  midi.play [note,note+12], 0.075 * dur }  
}

players[:tap_down_high] = L { |notes,dur| 
  notes.reverse.each{|note|  [note,note+12].each{|n| midi.play n, 0.075 * dur} }  
}

players[:fencepost] = L { |notes,dur| midi.play [notes[0],notes[-1]], 0.4 * dur }

players[:rest1] = L {|notes,dur| sleep 0.5 * dur }
players[:rest2] = L {|notes,dur| sleep 1 * dur }

players[:bassguy1] = L { |notes,dur| 
  [[0,0.4],[1,0.2],[0,0.2]].each{|i,d| midi.play notes[i],d * dur}
}
players[:bassguy2] = L { |notes,dur| 
  [[0,0.4],[1,0.1],[0,0.1],[1,0.2]].each{|i,d| midi.play notes[i],d * dur}
}
players[:george] = L { |notes,dur| midi.play notes, 0.4 * dur }

players[:calmer] = L { |notes,dur| 
  [notes,notes.first].each{ |i| midi.play i, 0.4 * dur}  
}

players[:inward_a] = L { |notes,dur|
 tmp = notes.clone
 while !tmp.empty?
   midi.play tmp.pop, 0.2 * dur
   tmp.reverse!
  end
}

players[:inward_b] = L { |notes,dur|
 tmp = notes.clone.reverse
 while !tmp.empty?
   midi.play tmp.pop, 0.2 * dur
   tmp.reverse!
 end
}
players[:outward_a] = L { |notes,dur|
  pivot = notes.size / 2
  tmp = notes[0,pivot].reverse + notes[pivot..-1].reverse
  while !tmp.empty?
    midi.play tmp.pop, 0.2 * dur
    tmp.reverse!
  end  
}
players[:outward_b] = L { |notes,dur|
  pivot = notes.size / 2
  tmp = notes[0,pivot].reverse + notes[pivot..-1].reverse
  tmp.reverse!
  while !tmp.empty?
    midi.play tmp.pop, 0.2 * dur
    tmp.reverse!
  end  
}

players[:tony] = L { |notes,dur|
  pivot = -1 * [3, notes.size-1].min
  midi.play notes[0..pivot], 0.4 * dur
  notes[pivot+1..-1].each{|note| midi.play note, 0.1 * dur}
}

players[:clifton] = L { |notes,dur|
  pivot = -1 * [4, notes.size-1].min
  midi.play notes[0..pivot], 0.4 * dur
  notes[pivot+1..-1].each{|note| midi.play note, 0.1 * dur}
}

players
alias :L :lambda

require 'rubygems'
require 'midiator'
require 'cb-music-theory' #git clone git://github.com/chrisbratlien/cb-music-theory.git
 
midi = MIDIator::Interface.new
midi.autodetect_driver
#midi = MIDIator::Interface.new
#midi.use :dls_synth


include MIDIator::Notes

def perform(attributes = {})	
  %w{root_note scale_name chord_picker progression improv improv_set logging}.each do |attribute|
    eval("@#{attribute} = attributes[:#{attribute}]")
  end

  rn = @root_note[]
  sn = @scale_name[rn]
  scale = rn.send(sn)
  prog = @progression[sn]
 
  # it's up to the chord_picker to use or ignore this
  root_cn = scale.valid_chord_names_for_degree(1).pick

  if @logging
    puts "perform: #{rn.name} #{sn} on the progression #{prog.join(',')} \n"
  end
  first_improv_pick = @improv_set.keys.pick
  
  prog.each{ |degree| 
	(chord,chord_text) = @chord_picker[scale,degree,root_cn] 
	improv_key = @improv[first_improv_pick,@improv_set]
    if @logging
      puts "playing #{chord_text} on degree #{degree}  improv: #{improv_key}"
    end
    base_duration = 1.4
	@improv_set[improv_key][chord.note_values,base_duration]  #picking a player lambda and then invoking it 
  }
  sleep(2)
end

def bend_note(midi,start,finish,sd=0.2,bd=0.1,fd=0.7)  
  st = finish - start
  my_note = start
		
  midi.driver.pitch_bend(0,0x3f) #return to center
  midi.driver.note_on(my_note,0,100)
  sleep(sd)

	w_start = 0x3f
	w_stop = { -2 => 0x00, -1 => 0x1f, 0 => 0x3f, 1 =>0x5f, 2 => 0x7f}[st]
	tot_w = w_stop - w_start
	tot_dur = bd	
	bend_steps = 12
	bend_dx = tot_w/bend_steps
	dur_dx = tot_dur / bend_steps
	w_start.step(w_stop,bend_dx) { |x|
		midi.driver.pitch_bend(0,x)
		sleep(dur_dx)
	}

  sleep(fd)	
  midi.driver.note_off(my_note,0,0)
  midi.driver.pitch_bend(0,0x3f) #return to center
end

=begin
#improv sets
players = {}
experimental = {}
hammett = {}

players[:peggy] = L { |notes,dur| 
  #peggy likes to play arpeggios
  (notes - [notes.last] + notes.reverse).each{|note|  midi.play note, 0.1 * dur }  
}

players[:tap_up] = L { |notes,dur| 
  #hammett likes to play arpeggios like those guitar finger tappers
  (notes * [1,2].pick).each{|note| midi.play note, 0.075 * dur }  
}

players[:tap_up_double_stop] = L { |notes,dur| 
  #hammett likes to play arpeggios like those guitar finger tappers
  (notes * [1,2].pick).each{|note|  midi.play [note,note+12], 0.075 * dur }  
}

players[:tap_up_high] = L { |notes,dur| 
  #hammett likes to play arpeggios like those guitar finger tappers
  (notes * [1,2].pick).each{|note|  [note,note+12].each{|n| midi.play n, 0.075 * dur} }  
}

players[:tap_down] = L { |notes,dur| 
  #hammett likes to play arpeggios like those guitar finger tappers
  (notes.reverse * [1,2].pick).each{|note| midi.play note, 0.075 * dur}  
}

players[:tap_down_double_stop] = L { |notes,dur| 
  #hammett likes to play arpeggios like those guitar finger tappers
  (notes.reverse * [1,2].pick).each{|note|  midi.play [note,note+12], 0.075 * dur }  
}

players[:tap_down_high] = L { |notes,dur| 
  #hammett likes to play arpeggios like those guitar finger tappers
  (notes.reverse * [1,2].pick).each{|note|  [note,note+12].each{|n| midi.play n, 0.075 * dur} }  
}


players[:rest1] = L {|notes,dur| sleep 0.5 * dur }
players[:rest2] = L {|notes,dur| sleep 1 * dur }

hammett[:maybe_bend] = L {|notes,dur|

  s = 0.1 * dur #start
  b = 0.1 * dur #bend
  g = 0.0 * dur #glue
  f = 0.1 * dur #finish


  nx = notes[1]
  if nx - notes[0] < 4
   
	bend_note(midi,nx,nx-=1,s,b,g)
	while nx > notes[0]
	  if nx - notes[0] == 1
	    bend_note(midi,nx,nx-=1,g,b,f)
	  else
	    bend_note(midi,nx,nx-=2,g,b,g)
	  end
	end
  end
}

#experimental[:hammett_dive_bomb] = L {|notes,dur|
hammett[:dive_bomb_down] = L {|notes,dur|

  s = 0.05 * dur #start
  b = 0.02 * dur #bend
  g = 0.0 * dur #glue
  f = 0.05  * dur #finish

	nx = notes.last + 12
	bend_note(midi,nx,nx-=1,s,b,g)
	while nx > notes[0]
	  if nx - notes[0] == 1
	    bend_note(midi,nx,nx-=1,g,b,f)
	  else
	    bend_note(midi,nx,nx-=2,g,b,g)
	  end
	end
}


hammett[:dive_bomb_up] = L {|notes,dur|

  s = 0.05 * dur #start
  b = 0.02 * dur #bend
  g = 0.0 * dur #glue
  f = 0.05 * dur #finish

	nx = notes[0]
	bend_note(midi,nx,nx+=1,s,b,g)
	while nx < notes.last + 12
	  if nx - notes[0] == 1
	    bend_note(midi,nx,nx+=1,g,b,f)
	  else
	    bend_note(midi,nx,nx+=2,g,b,g)
	  end
	end
}



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

=end



# map degrees to their next "allowed" degrees
# DANGER, THIS CHORD LADDER IS TOO SIMPLE, FORMULAIC, RIGID, ETC, AND NOT MEANT TO BE FOR EVERY TYPE OF SCALE
# BUT IT'S ALL I HAVE AT THIS POINT
ladders = {}
Note.scale_methods.each{|m| ladders[m] = {}
	# i know, cheesy default
	(1..20).each{|d| ladders[m][d] = [1]}

	ladders[m][1] = [3,4,5,6]
	ladders[m][2] = [5,7]
	ladders[m][3] = [6]
	ladders[m][4] = [5,7]
	ladders[m][5] = [1,6]
	ladders[m][6] = [2,4]
	ladders[m][7] = [1,6]
}

ladders[:major_scale] = {}
ladders[:major_scale][1] = [3,4,5,6] #pulled out of my ass
ladders[:major_scale][2] = [5,7]
ladders[:major_scale][3] = [6]
ladders[:major_scale][4] = [5,7]
ladders[:major_scale][5] = [1,6]
ladders[:major_scale][6] = [2,4]
ladders[:major_scale][7] = [1,6]

#get the next octave in (assuming 7-degree scales)
(8..15).each{|n| ladders[:major_scale][n] = ladders[:major_scale][n-7]}  


puts "If you have Propellerhead Reason, try picking one of these:"
puts "Combinator->Piano and Keyboard->Accoustic Piano->Concert Piano"
puts "Combinator->Combinator Patches->Guitar and Plucked->Misc Guitar and Plucked->Whale Calls"
puts
puts
puts "first, a few canned examples"


# chord progression

#perform(Note.new("C"), :phrygian_scale, :min7_chord, prog,tony)
#perform(Note.new(54), :mixolydian_scale, :eleventh_chord, prog,clifton)
#perform(Note.new("F"), :major_scale, :maj9_chord, prog,peggy)

#perform(Note.new("F"), :major_scale, :maj9_chord, prog,inward_a)
#perform(Note.new("F"), :major_scale, :maj9_chord, prog,inward_b)
#perform(Note.new("F"), :major_scale, :maj9_chord, prog,outward_a)
#perform(Note.new("F"), :major_scale, :maj9_chord, prog,outward_b)
  

def next_degree(start,ladder)
  # also may pick from next octave (assuming 7-degree scales)
  ladder[start].map{|deg| [deg,deg + 7] }.flatten.pick
end
  
def generate_progression(ladder)

  intro = [1]
  3.times { intro << [1,4,5].pick}
  verse = [1]
  3.times { verse << [next_degree(verse.last,ladder),verse.last].pick}
  verse << [1,4,5].pick
  2.times { verse << [next_degree(verse.last,ladder),verse.last].pick}
  verse << [4,5].pick
  
  chorus = [1] 
  2.times { chorus << [next_degree(chorus.last,ladder),verse.last].pick}
  chorus << [4,5].pick
  
  prog = []
  prog = intro + verse + chorus  + verse + chorus + intro + [1]


  #new_prog = [rand(7) +1] #initial degree
  #new_prog = [1]
  #(rand(8) + 48).times { new_prog << next_degree(new_prog.last,ladder) }	
  #new_prog
  prog
end


harmonized_root_chord_picker = L {|scale,degree,root_chord_name|
  chord = scale.harmonized_chord(degree,root_chord_name)
  [chord,'harmonized ' + root_chord_name]
}  
  
degree_chord_picker = L {|scale,degree,root_chord_name| 
  chord_name = scale.valid_chord_names_for_degree(degree).pick
  chord = scale.degree(degree).send(chord_name) || scale.degree_triad(degree)
	[chord,chord_name]
}

50.times {
    
  	perform(
		:root_note => L {Note.new(rand(20) + 40)},
		:scale_name => L {|root_note| Note.random_scale_method},		
		:chord_picker => harmonized_root_chord_picker,
		#:chord_picker => degree_chord_picker,
		:progression => L {|scale_name| generate_progression(ladders[scale_name])},
		#:progression => L {[1,4,5,2,8,4,8,4,9,7,2,5,1,3,6,9,5,7,2,5,6,2,7,5,8,4,1,7,8]},
		#:improv => L{|orig,set| orig}, #picks one improv at beginning to use on all chords of progression 
		:improv => L{|orig,set| set.keys.pick}, #pick an improv at every chord change in the progression
		#:improv => L{|orig,set| :calmer}, #only this player, always, period!
		#:improv => L{|orig,set| set.keys.select{|x| x.to_s =~ /hammett/}.pick }, #at every chord, pick any improv containing the regex
		:improv_set => eval(File.read("improv_set_players.rb")),
		:logging => true,
		:ignore_this => 'I said ignore this!')
}

#shush
(0..127).each{|n| midi.driver.note_off(n,0,0) }
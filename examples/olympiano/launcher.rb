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
  %w{midi root_note scale_name chord_picker progression improv improv_set logging}.each do |attribute|
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

  queue = []
  
  prog.each{ |degree| 
	  (chord,chord_text) = @chord_picker[scale,degree,root_cn] 
	  improv_key = @improv[first_improv_pick,@improv_set]
    if @logging
      puts "queueing #{chord_text} on degree #{degree}  improv: #{improv_key}"
    end
    base_duration = 1.5

	  @improv_set[improv_key][chord.note_values,base_duration,queue]  #picking an improv lambda and then invoking it 
  }

  #puts queue.inspect.to_s

  queue.each{|n,dur| @midi.play n, dur}

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
  [chord,'harmonized I ' + root_chord_name]
}  
  
degree_chord_picker = L {|scale,degree,root_chord_name| 
  chord_name = scale.valid_chord_names_for_degree(degree).pick
  if !chord_name
    #fall back to the other call
    chord,chord_name = harmonized_root_chord_picker[scale,degree,root_chord_name]
  else
    chord = scale.degree(degree).send(chord_name)
  end
  [chord,chord_name]
}

50.times {
    
  	perform(
  	:midi => midi,
		:root_note => L {Note.new(rand(20) + 40)},
		#:scale_name => L {|root_note| Note.random_scale_method},		
		:scale_name => L {|root_note| "minor_pentatonic_scale"},		
		#:chord_picker => harmonized_root_chord_picker,
		:chord_picker => degree_chord_picker,
		:progression => L {|scale_name| generate_progression(ladders[scale_name])},
		#:progression => L {[1,4,5,2,8,4,8,4,9,7,2,5,1,3,6,9,5,7,2,5,6,2,7,5,8,4,1,7,8]},
		:improv => L{|orig,set| orig}, #picks one improv at beginning to use on all chords of progression 
		#:improv => L{|orig,set| set.keys.pick}, #pick an improv at every chord change in the progression
		#:improv => L{|orig,set| :inward_b}, #only this player, always, period!
		#:improv => L{|orig,set| set.keys.select{|x| x.to_s =~ /hammett/}.pick }, #at every chord, pick any improv containing the regex
		:improv_set => eval(File.read("improv_set_players.rb")),
		:logging => true,
		:ignore_this => 'I said ignore this!')
}

#shush
(0..127).each{|n| midi.driver.note_off(n,0,0) }
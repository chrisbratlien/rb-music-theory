alias :L :lambda
require 'rubygems'
require 'midiator'
require 'cb-music-theory'

class PianoRoll

  attr_reader :next, :root_note,:scale_name, :scale, :roll, :chord, :degree_picker
  
  def initialize(attributes = {})	
    puts "FELLAS I'M READY TO GETUP AND DO #{self} THANG"
    %w{midi next root_note scale_name degree chord_picker roll queue logging}.each do |attribute|
      eval("@#{attribute} = attributes[:#{attribute}]")
    end 
    
    @degree_picker = L {|prev| [nil,3,5,6,nil,1,2,][prev]} 
    #@degree_picker = L {|prev| [nil,4,5,6,7,1,2,3][prev]}
    #@degree_picker = L {|prev| [nil,4,nil,nil,5,1][prev]}

    @scale = @root_note.send(@scale_name)
    @chord, @chord_name = @chord_picker[@scale,@degree,@scale.valid_chord_names_for_degree(1).pick]
    @roll = {} # improv*note*step  (each improv lambda gets its own 2-d piano roll to paint with probys)
    @improv = {} #to contain different improv strategies i guess.. i only have @improv[:chords] right now.
    puts "#{@root_note.name} #{@scale_name}, degree #{@degree},  #{@chord_name}"
  end
  
  def go         
    @next = PianoRoll.new(:midi => @midi,
                          :next => nil,
                          :root_note => @root_note,
                          :scale_name => @scale_name,
                          :degree => @degree_picker[@degree],
                          :chord_picker => @chord_picker,
                          :roll => {},
                          :logging => @logging)

    evolve_probs
      
    (1..4).each do |measure|
      #puts "\a" if measure == 1
      (0..3).each do |step|
        collect_for_this_step = []
        (60..72).each do |note|
          if rand < @roll[:chords][note][step]
            collect_for_this_step << note
          end
        end
        puts "#{measure}.#{step+1} #{collect_for_this_step.inspect.to_s}"
        @midi.play collect_for_this_step, 0.25
      end
    end
    puts
    
    @next.go
    # Ahh! a cliff!  
  end

  def evolve_probs
    
    #improv lambdas which can paint the piano roll however they want.
    #the piano roll has a @next pointing to the next measure's piano roll, whose
    # root_note, scale, and chord are known and accessible data at this point.
    #I'm thinking a bassline improv lambda could ask what the next measure's
    # piano roll's chord is and then decide how best to walk towards it as it
    # paints the current piano roll.  sort-of sight-reading
    
    match_by_name = L {|chord,note| chord.contains_note_names_of?(Note.new(note))}
    match_by_value = L {|chord,note| chord.contains_note_value?(note)}
    
    @improv[:chords] = L{ |pr,name,test|
      spark = [1.0,1.0,1.0,0.0]
      if !pr.roll.has_key?(name)
        pr.roll[name] = {}
      end          
      (60..84).each do |note|  
        if !pr.roll[name].has_key?(note)
          pr.roll[name][note] = [0.0] * 4
        end
        if test[chord,note] #pr.chord.contains_note_value?(note)
          pr.roll[name][note] = spark.map{|n| n + rand(5)*0.1}
        end
      end
    }   
    
    @improv[:chords][self,:chords,match_by_value]
    
    #TODO: add another improv lambda for either lead or bassline.  provide functions like
    # aggregate row and column density so lambdas can decide to "fill in the gaps" a little.
    # especially the :lead improv because melodies are more like the plotted line, and less
    # like the x-axis.  the key vs the pins and tumblers,
    # also, what about a :kamikaze lambda whose performance is to dodge the obstacles in
    # the current measure, survivng long enough to crash into an obstacle at the beginning
    # of the next measure  (ok that's just a walking bassline stated more dramatically)
  end
end

midi = MIDIator::Interface.new
midi.autodetect_driver
#midi = MIDIator::Interface.new
#midi.use :dls_synth
#include MIDIator::Notes

favorite_scales = L{Note.random_scale_method}
generate_scale = L{|note,scale_name| note.send(scale_name)}

generate_chord = L{|scale,degree| 
  cn = scale.valid_chord_names_for_degree(degree).pick
  scale.degree(degree).send(cn) 
}
harmonized_root_chord_picker = L {|scale,degree,root_chord_name|
  chord = scale.harmonized_chord(degree,root_chord_name)
  [chord,'harmonized I ' + root_chord_name]
}  
  
degree_chord_picker = L {|scale,degree,root_chord_name| 
  chord_name = scale.valid_chord_names_for_degree(degree).pick
  if !chord_name
    chord,chord_name = harmonized_root_chord_picker[scale,degree,root_chord_name]
  else
    chord = scale.degree(degree).send(chord_name)
  end
  [chord,chord_name]
}

favorite_scales = L {["mixolydian_scale",  "major_scale", "lydian_scale","natural_minor_scale"].pick}
    #"dorian_scale", "harmonic_minor_scale",,"melodic_minor_scale","locrian_scale", "hangman_scale"
  
rollo = PianoRoll.new(
          :midi => midi,
          :next => nil,
          :root_note => Note.new(rand(20) + 45),
          :scale_name => favorite_scales[],
          :degree => 1,
      		:chord_picker => degree_chord_picker,
      		#:chord_picker => harmonized_root_chord_picker,
      		#:chord_picker => [degree_chord_picker,harmonized_root_chord_picker].pick,
          :roll => {},
          :queue => [60,63,60,60,64,60,58],
          :cloner => L{|pr| pr = pr.next},
          :logging => true)

rollo.go
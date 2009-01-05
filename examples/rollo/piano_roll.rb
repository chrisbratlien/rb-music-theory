alias :L :lambda
require 'rubygems'
require 'midiator'
require 'cb-music-theory'
require 'pp'

class PianoRoll

  attr_reader :next, :roll, :chord, :degree_picker
  
  def initialize(attributes = {})	
    %w{midi next scale degree chord_picker roll queue cloner logging}.each do |attribute|
      eval("@#{attribute} = attributes[:#{attribute}]")
    end 
    @chord = @chord_picker[@scale,@degree]

    @degree_picker = L {|prev| [nil,3,5,6,nil,1,2,][prev]}
  end
  
  def go
    while true      
      @next = PianoRoll.new(:midi => @midi,
                            :next => nil,
                            :scale => @scale,
                            :degree => degree_picker[@degree],
                            :chord_picker => @chord_picker,
                            :roll => {},
                            :cloner => @cloner,
                            :logging => @logging)
      
      puts "here"
      @queue << concretize
      @cloner[self]
      puts @queue.inspect.to_s
      
      #@queue.each{|note,dur,vel,time| @midi.play note,dur,vel }                                                
    end
  end

  def concretize
    @roll = {}
    @improv = {}

    @igniter = L do |prob,pr,name|
      (36..45).each do |note|  
        if !pr.roll[name].has_key?(note)
          pr.roll[name][note] = []
        end 
        pr.roll[name][note] = prob.map{|n| n + rand(5)*0.1}
      end
    end
    
    @improv[:chords] = L{|pr,name|
      spark = [1.0,0.0,1.0,0.0]
      puts spark.inspect.to_s
      if !pr.roll.has_key?(name)
        pr.roll[name] = {}
      end    
    @igniter[spark,pr,name]
    }


    @improv[:chords][self,"chords"]
    puts @roll.inspect.to_s
    []
  end


end


midi = MIDIator::Interface.new
midi.autodetect_driver
#midi = MIDIator::Interface.new
#midi.use :dls_synth
#include MIDIator::Notes

generate_scale = L{ Note.new("C").major_scale}
generate_chord = L{|scale,degree| 
  cn = scale.valid_chord_names_for_degree(degree).pick
  scale.degree(degree).send(cn) 
}
  
rollo = PianoRoll.new(
          :midi => midi,
          :next => nil,
          :scale => generate_scale[],
          :degree => 1,
          :chord_picker => generate_chord,
          :roll => {},
          :queue => [60,63,60,60,64,60,58],
          :cloner => L{|pr| pr = pr.next},
          :logging => true)

rollo.go
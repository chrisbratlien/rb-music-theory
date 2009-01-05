#improv sets
#TODO: rethink bend_note now that I'm queueing instead of calling midi.play in the lambda
hammett = {}


hammett[:maybe_bend] = L {|notes,dur,q|

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

#experimental[:hammett_dive_bomb] = L {|notes,dur,q|
hammett[:dive_bomb_down] = L {|notes,dur,q|

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


hammett[:dive_bomb_up] = L {|notes,dur,q|

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

hammett
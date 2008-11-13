class NoteInterval
  def self.hangman_set
    # not sure if there's already a common name for this pattern.
    [0,1,3,4,7,8,10].map{|i| NoteInterval.new(i)}
  end
end

class Note
  def hangman_scale
    Scale.new(self,NoteInterval.hangman_set)
  end
end

  
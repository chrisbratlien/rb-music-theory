
describe Note do
  
  
  it "should produce octaves with plus_interval correctly" do
    Note.twelve_tones.each do |tone_name|
      orig_note = Note.new(tone_name)
      high_note = orig_note.plus_interval(NoteInterval.octave)
      high_note.name.should == orig_note.name
      high_note.value.should == orig_note.value + 12
    end
  end

  it "plus_interval should fail when passed another Note" do
    proc { Note.new("C").plus_interval(Note.new("C")) }.should raise_error(TypeError)
  end
    
end


describe NoteInterval do
  
  it "dorian set should equal a shifted ionian set" do
      NoteInterval.dorian_set.map{|i| i.value}.should == NoteInterval.shift_set(NoteInterval.ionian_set).map{|i| i.value}
  end
  
  it "phrygian mode should equal shifted dorian mode" do
    NoteInterval.phrygian_set.map{|i| i.value}.should == NoteInterval.shift_set(NoteInterval.dorian_set).map{|i| i.value}
  end

  it "lydian mode should equal shifted phrygian mode" do
    NoteInterval.lydian_set.map{|i| i.value}.should == NoteInterval.shift_set(NoteInterval.phrygian_set).map{|i| i.value}
  end

  it "mixolydian mode should equal shifted lydian mode" do
    NoteInterval.mixolydian_set.map{|i| i.value}.should == NoteInterval.shift_set(NoteInterval.lydian_set).map{|i| i.value}
  end

  it "aeolian mode should equal shifted mixolydian mode" do
    NoteInterval.aeolian_set.map{|i| i.value}.should == NoteInterval.shift_set(NoteInterval.mixolydian_set).map{|i| i.value}
  end

  it "locrian mode should equal shifted aeolian mode" do
    NoteInterval.locrian_set.map{|i| i.value}.should == NoteInterval.shift_set(NoteInterval.aeolian_set).map{|i| i.value}
  end
end


describe Chord do
  it "should produce a major chord" do
    Note.new("C").major_chord.note_names.should == ["C", "E", "G"]
  end
  
  it "chord inversion should have the same note names" do
    c1 = Note.new("C").major_chord
    c2 = c1.invert
    c3 = c2.invert
    c2.note_names.sort.should == c1.note_names.sort
    c3.note_names.sort.should == c2.note_names.sort
  end
end

describe Scale do

  before(:all) do
    @c_maj_scale = Note.new("C").major_scale
    @c_maj_scale_note_names = ["C", "D", "E", "F", "G", "A", "B"]
  end
  

  it "should produce a chromatic scale" do
    Note.new("C").chromatic_scale.note_names.should == ["C","C#","D","D#","E","F","F#","G","G#","A","A#","B"]
  end

  it "should produce a major scale with correct note names" do
    @c_maj_scale.note_names.should == @c_maj_scale_note_names
  end

  it "should have the correct major scale degrees" do
    (1..7).to_a.map{|d| @c_maj_scale.degree(d).name }.should == @c_maj_scale_note_names
  end

  it "should produce a correct A natural minor scale" do
    Note.new("A").natural_minor_scale.note_names.should == ["A", "B", "C", "D", "E", "F", "G"]
  end

  it "should produce a correct A harmonic minor scale" do
    Note.new("A").harmonic_minor_scale.note_names.should == ["A", "B", "C", "D", "E", "F", "G#"]
  end

  it "should produce a correct A melodic minor scale" do
    Note.new("A").melodic_minor_scale.note_names.should == ["A", "B", "C", "D", "E", "F#", "G#"]
  end




end

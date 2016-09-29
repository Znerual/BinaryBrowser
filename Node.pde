class Node {
  float duration;
  int midi;
  float amplitude;
  float attackTime = 0.01;
float sustainLevel = 0.2;
float releaseTime = 0.1;
  public Node(float dur, int mid, float amp) {
    this.duration = dur;
    this.midi = mid;
    this.amplitude = amp;
  }
  public Node(byte input) {
   this.midi = round(round(input / 11.5)*1.5 + 40);
   this.duration = round(input / 12.5)/10.0;
   this.amplitude =  0.5 +round(5.0 / input)/100.0;
  }
  public Node(byte[] input) {
    this.midi = round(round(input[0] / 11.5)*1.5 + 40);
    this.duration = round(input[1] / 12.5)/10.0;
   this.amplitude =  0.5 + round(input[1] / 5.0)/100.0;
  }
  public boolean isEmpty() {
    return this.duration == 0;
  }
  public void play(TriOsc triOsc, Env env) {
    if (this.duration != 0) {
      triOsc.play(midiToFreq(this.midi), this.amplitude * 2);
    
      env.play(triOsc, attackTime, this.duration, sustainLevel * 2, releaseTime);
    }   
  }
  public void play(Pulse triOsc, Env env) {
    if (this.duration != 0) {
      triOsc.play(midiToFreq(this.midi), this.amplitude * 2);
    
      env.play(triOsc, attackTime, this.duration, sustainLevel * 2, releaseTime);
    }   
  }
  public void play(SawOsc triOsc, Env env) {
    if (this.duration != 0) {
      triOsc.play(midiToFreq(this.midi), this.amplitude / 2);
    
      env.play(triOsc, attackTime, this.duration, sustainLevel / 2, releaseTime);
    }   
  }
  public void play(SqrOsc triOsc, Env env) {
    if (this.duration != 0) {
      triOsc.play(midiToFreq(this.midi), this.amplitude / 2);
    
      env.play(triOsc, attackTime, this.duration, sustainLevel / 2, releaseTime);
    }   
  }
  public float getDuration() { return this.duration * 1000;}
  private float midiToFreq(int note) {
    return (pow(2, ((note-69)/12.0)))*440;
  }
}
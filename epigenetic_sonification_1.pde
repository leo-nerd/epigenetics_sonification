int FrameRate = 5 ;

import ddf.minim.*;
import ddf.minim.signals.*;
import ddf.minim.ugens.*;

Minim minim;
AudioOutput out;

String[] currentLine ;
String[] previousLine ;
String[] lines ;
String test0 = "<0" ;
String test1 = "1" ;
int lineNum = 1 ;

Oscil[] sines = new Oscil[9] ;

float amplitude = 0.5 ;
float attack = 0.01;
float decay = 0.001;
float sustain = amplitude ;
float release = attack ;
float befAmp = 0 ;
float aftAmp = 0 ;

ADSR[] adsr = new ADSR[9] ;
Summer sum = new Summer() ;

void setup()
{
  frameRate(FrameRate) ;
  size(512, 200) ;

  minim = new Minim(this);
  // get a line out from Minim, default bufferSize is 1024, default sample rate is 44100, bit depth is 16
  out = minim.getLineOut(Minim.STEREO);


  lines = loadStrings("markers_simplified_table.txt") ;
  previousLine = split(lines[0], ' ') ;
  println("AHAHAHA" + previousLine) ;

  // create a sine wave Oscillator, set to 440 Hz, at 0.5 amplitude, sample rate from line out

  sines[0] = new Oscil(200, amplitude, Waves.SINE);
  sines[1] = new Oscil(250, amplitude, Waves.SINE);
  sines[2] = new Oscil(300, amplitude, Waves.SINE);
  sines[3] = new Oscil(550, amplitude, Waves.SINE);
  sines[4] = new Oscil(600, amplitude, Waves.SINE);
  sines[5] = new Oscil(350, amplitude, Waves.SINE);
  sines[6] = new Oscil(400, amplitude, Waves.SINE);
  sines[7] = new Oscil(450, amplitude, Waves.SINE);
  sines[8] = new Oscil(500, amplitude, Waves.SINE);

  for (int ii = 0; ii < 9; ii++) {
    adsr[ii] = new ADSR(amplitude, attack, decay, amplitude, release, befAmp, aftAmp) ;
    
    println(previousLine[ii]) ;
    sines[ii].patch(adsr[ii]) ;
    adsr[ii].patch(out) ;
    
    adsr[ii].noteOn() ;
  }
  //sum.patch(out) ;
}

void draw()
{
  
  background(0);
  println(lineNum) ;
  currentLine = split(lines[lineNum], ' ') ;

  for ( int ii = 0; ii < 9; ii++ ) {
    if ( !currentLine[ii].equals(previousLine[ii]) ) {
      switchState(sines[ii], previousLine[ii], adsr[ii]) ;
    }
  }

  previousLine = currentLine ;
  lineNum++ ;
}

void stop()
{
  out.close();
  minim.stop();

  super.stop();
}

void switchState(Oscil sin, String state, ADSR adsr)
{
  if (state.equals(test1)) {
    sin.unpatch(adsr) ;
    adsr.noteOff() ;
  } else {
    sin.patch(adsr) ;
   adsr.noteOn() ;
  }
}


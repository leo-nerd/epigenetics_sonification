/**
 *  This sketch demonstrates how to use a <code>SineWave</code> with an <code>AudioOutput</code>.<br />
 *  Move the mouse up and down to change the frequency, left and right to change the panning.<br />
 *  <br />
 *  <code>SineWave</code> is a subclass of <code>Oscillator</code>, which is an abstract class that implements the 
 *  interface <code>AudioSignal</code>.<br />
 *  This means that it can be added to an <code>AudioOutput</code> and the <code>AudioOutput</code> will call 
 *  one of the two <code>generate()</code> functions, depending on whether the AudioOutput is STEREO or MONO. 
 *  Since it is an 
 *  abstract class, it can't be directly instantiated, it merely provides the functionality of 
 *  smoothly changing frequency, amplitude and pan. In order to have an <code>Oscillator</code> that actually 
 *  produces sound, you have to extend <code>Oscillator</code> and define the value function. This function 
 *  takes a <b>step</b> value and returns a sample value between -1 and 1. In the case of the SineWave,
 *  the value function returns this: <b>sin(freq * TWO_PI * step)</b><br />
 *  <b>freq</b> is the current frequency (in Hertz) of the <code>Oscillator</code>. It is multiplied by <b>TWO_PI</b> to
 *  set the period of the sine wave properly and then that sine wave is sampled at <b>step</b>.
 */

import ddf.minim.*;
import ddf.minim.signals.*;

Minim minim;
AudioOutput out;

String[] currentLine ;
String[] previousLine ;
String[] lines ;
String test0 = "0" ;
String test1 = "1" ;
int lineNum = 1 ;
SineWave[] sines = new SineWave[9] ;

void setup()
{
  frameRate(5) ;
  size(512, 200);

  minim = new Minim(this);
  // get a line out from Minim, default bufferSize is 1024, default sample rate is 44100, bit depth is 16
  out = minim.getLineOut(Minim.STEREO);


  lines = loadStrings("markers_simplified_table.txt") ;
  previousLine = split(lines[0], ' ') ;
  println("AHAHAHA" + previousLine) ;

  // create a sine wave Oscillator, set to 440 Hz, at 0.5 amplitude, sample rate from line out
  
  sines[0] = new SineWave(100, 0.5, out.sampleRate());
  sines[1] = new SineWave(150, 0.5, out.sampleRate());
  sines[2] = new SineWave(250, 0.5, out.sampleRate());
  sines[3] = new SineWave(400, 0.5, out.sampleRate());
  sines[4] = new SineWave(600, 0.5, out.sampleRate());
  sines[5] = new SineWave(850, 0.5, out.sampleRate());
  sines[6] = new SineWave(1100, 0.5, out.sampleRate());
  sines[7] = new SineWave(2000, 0.5, out.sampleRate());
  sines[8] = new SineWave(3000, 0.5, out.sampleRate());

  for (int ii = 0; ii < 9; ii++) {

    println(previousLine[ii]) ;
    out.addSignal(sines[ii]) ;
    
    if ( previousLine[ii].equals(test1) ) {
      //println("enabled signal", ii) ;
      out.enableSignal(ii) ;
    }
    if ( previousLine[ii].equals(test0) ) {
      out.disableSignal(ii) ;
      //println("disabled signal", ii) ;
    }
  }
  
}

void draw()
{
  background(0);
  println(lineNum) ;
  currentLine = split(lines[lineNum], ' ') ;
  
  for ( int ii = 0; ii < 9; ii++ ) {
//    if ( currentLine[ii].equals(test1)) {
//      if ( out.isEnabled(sines[ii]) == false ) {
//        out.enableSignal(ii);
//        //println("activated sinewave number", ii) ;
//      }
//    } 
//    if ( currentLine[ii].equals(test0)) {
//      if ( out.isEnabled(sines[ii]) == true) {
//        out.disableSignal(ii) ;
//        //println("deactivated sinewave number", ii) ;
//      }
//    }
//    
    if ( !currentLine[ii].equals(previousLine[ii]) ) {
      switchState(sines[ii]) ;
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

void switchState(SineWave sin)
{
  if(out.isEnabled(sin)){
    out.disableSignal(sin) ;
  }
  
  else {
    out.enableSignal(sin) ;
  }
}

///////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////
//////////////  Inspired by Sunset Lover from PETIT BISCUIT  //////////////
//////////////          --- Sound Visualization --           //////////////
//////////////       For projection and entertainment        //////////////
///////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////

//Sun and horizon
int radius = 100;
float nScale = 200;
float noiseMulti = 8;

//Weave
float weave, coloring;

//Sound library
import ddf.minim.*;
import ddf.minim.analysis.*;

Minim minim;
AudioPlayer player;
AudioMetaData meta;
BeatDetect beat;

////Cloudysky&sea////
//Space between lines in pixels
int spacing = 48; 
//Cloudysky&sea top, left, right, bottom border
int border = spacing/2; 
//Frequency amplification factor
int circleamplification = 3; 
int y = spacing;
//Number of lines in y direction
float ySteps; 

void setup() {
      //Set background to black
      background(0); 
      size(900, 900, P2D);
     
      //Sunset beat detector
      smooth();
      minim = new Minim(this);
      player = minim.loadFile("PETIT BISCUIT - Sunset Lover.mp3");
      player.loop();
      meta = player.getMetaData();
      beat = new BeatDetect(player.bufferSize(), player.sampleRate());
      beat.setSensitivity(300);
      
      stroke(random(255), random(50), random(30));
      strokeWeight(1.25);
    }
    

void draw() {
       
        //Cloudysky(circles)
         int screenSize = int((width-2*border)*(height-1.5*border)/spacing);
         int song = int(map(player.position(), 0, player.length(), 0, screenSize));
         ySteps = song/(width-2*border); // calculate amount of lines
         song -= (width-2*border)*ySteps; // set new x position for each line
         float frequency = player.mix.get(int(song))*spacing*circleamplification;
         float freqMix = player.mix.get(int(song));
         float size = freqMix * spacing * circleamplification;
         noStroke();
         fill(coloring, 95, 168, random(5,35));
         ellipse(song+border, y*ySteps+border, size, size);
         ellipse(song+border, y*ySteps+border, frequency, frequency);
         
        //Set weave and sunset at the center
        translate(width/2, height/2);
        //Sunset and horizon beat detacting
        stroke(1);
        fill(0);       
        beat.detect(player.mix);
        if (beat.isKick()) {
          noiseMulti = 100;
          nScale = 200;
        } else {
          if (nScale > 100) nScale *= random(0.7,1.75);
          noiseMulti *= 0.5;
        }
        
        //Sunset and horizon movement    
        stroke(225, random(223), 68, random(10,30));
        for (int lat = -90; lat < 90; lat+=2) {
        for (int lng = -180; lng < 180; lng+=2) {
        float _lat = radians(lat);  
        float _lng = radians(lng);  
        //Noise
        float n = noise(_lat * noiseMulti / 100, _lng * noiseMulti / 100 + millis() );
        float x = (radius + n * nScale) * cos(_lat) * cos(_lng);
        float y = (radius + n * nScale) * sin(_lat) * (-1);
        float z = (radius + n * nScale) * cos(_lat) * sin(_lng);
        point(x, y, z);
          }
        }  
 
      // Set the color of the weave
      stroke(coloring, 142, 255, 60);
      line(x(weave), y(weave), x1(weave), y1(weave));
      line(x(weave), y(weave), x2(weave), y2(weave));
      weave += random (0.1, 0.5);
      coloring += 0.25;
      if (coloring > 255) coloring = random(255);
      if (weave > 1000) {
        background(0);
        weave=0;
      }       
   }
   
    //Set the angle, position and density of the weave
    float x (float weave) {
      return sin(weave/20)*100;
    }
    
    float y (float weave) {
      return cos(weave/20)*100;
    }
    
    float x1 (float weave) {
      return sin(weave/30)*300;
    }
    
    float y1 (float weave) {
      return cos(weave/10)*300;
    }
    
    float x2 (float weave) {
      return sin(weave/60)*650;
    }
    
    float y2 (float weave) {
      return cos(weave/10)*300;
    }

    
//Music stop and repeat
void stop(){
    player.close();
    minim.stop();
    super.stop();
    }

import processing.sound.*;

SoundFile music;
int scl, cols, rows, backgroundColor, backgroundColorIncrement;
boolean whiteBackground;
float inc, zinc, zoff;
Particle[] particles;
PVector[] flowField;
StopWatch sw;

void setup() {
  //Display params
  colorMode(HSB);
  background(255);
  // uncomment size to set fixed window size
  //size(800, 600);
  // comment out this line if you use fixed window size
  fullScreen(P2D);
  frameRate(30);

  //Variables
  scl = 40;
  inc = 0.1;
  zinc = 0.0001;
  zoff = 0;
  backgroundColor = 255;
  backgroundColorIncrement = 5;
  whiteBackground = true;

  //Field grid
  cols = int(width/scl);
  rows = int(height/scl);

  //flowfield and particles
  particles = new Particle[5000];
  flowField = new PVector[cols*rows];
  CreateParticles();

  //Timekeeper
  sw = new StopWatch();
  sw.Start();

  //Music
  music = new SoundFile(this, "musicmono.mp3");
  music.amp(0.045);
  music.loop();
}

void Reset() {
  //background(back);
  for (Particle p : particles) {
    p.Reset();
  }
  sw.Restart();
  whiteBackground = !whiteBackground;
}

void draw() {
  //for debug
  //background(255);

  float yoff = 0;
  for (int y = 0; y<rows; y++) {
    float xoff=0;
    for (int x = 0; x<cols; x++) {
      int index = x+y*cols;
      float angle = noise(xoff, yoff, zoff)*TWO_PI*4;
      PVector v = PVector.fromAngle(angle).setMag(1);
      flowField[index] = v;
      xoff+= inc;

      //use for debug
      //stroke(0);
      //pushMatrix();
      //strokeWeight(1);
      //translate(x*scl, y*scl);
      //rotate(v.heading());
      //line(0, 0, scl, 0);
      //popMatrix();
    }
    yoff +=inc;
    zoff +=zinc;
  }
  FlowFieldParticles(flowField);

  //fade background loop
  if (sw.GetSeconds() >= 90) {
    if (whiteBackground && backgroundColor > 0) {
      backgroundColor += -backgroundColorIncrement;
    } else if (!whiteBackground && backgroundColor < 255) {
      backgroundColor += backgroundColorIncrement;
    } else if (backgroundColor == 255 || backgroundColor == 0) {
      Reset();
    }
    background(backgroundColor);
    FlowFieldParticles(flowField);
  }
}

void CreateParticles() {
  for (int i=0; i<particles.length; i++) {
    particles[i] = new Particle();
  }
}

void FlowFieldParticles(PVector[] flowField) {
  for (Particle p : particles) {
    p.FollowFlow(flowField);
    p.Update();
    p.EdgeCheck();
    p.Show();
  }
}
int scl, cols, rows;
float inc, zinc, zoff;
Particle[] particles;
PVector[] flowField;
StopWatch sw;

void setup() {
  colorMode(HSB);
  background(255);
  size(1920, 1080);
  
  //Variables
  scl = 30;
  inc = 0.09;
  zinc = 0.0001;
  zoff = 0;
  
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
}

void Reset() {
  background(255);
  for (Particle p : particles) {
    p.Reset();
  }
  sw.Restart();
}

void draw() {
  println(frameRate);
  //for debug
  //background(255);

  if (sw.GetSeconds() > 90) {
    Reset();
  }

  float yoff = 0;
  for (int y = 0; y<rows; y++) {
    float xoff=0;
    for (int x = 0; x<cols; x++) {
      int index = x+y*cols;
      float angle = noise(xoff, yoff, zoff)*TWO_PI*5;
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
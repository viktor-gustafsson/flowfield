import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.File; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException; 

public class perlin extends PApplet {

int scl = 30;
int cols, rows;
float inc = 0.09f;
float zinc = 0.0001f;
float zoff = 0;
Particle[] particles = new Particle[5000];
PVector[] flowField;
StopWatch sw;

public void setup() {
  colorMode(HSB);
  background(255);
  

  cols = PApplet.parseInt(width/scl);
  rows = PApplet.parseInt(height/scl);


  flowField = new PVector[cols*rows];
  CreateParticles();
  sw = new StopWatch();
  sw.Start();
}

public void Reset() {
  background(255);
  for (Particle p : particles) {
    p.Reset();
  }
  sw.Restart();
}

public void draw() {
  //for debug
  //background(255);

  if (sw.GetMinutes() >= 2) {
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

public void CreateParticles() {
  for (int i=0; i<particles.length; i++) {
    particles[i] = new Particle();
  }
}

public void FlowFieldParticles(PVector[] flowField) {
  for (Particle p : particles) {
    p.FollowFlow(flowField);
    p.Update();
    p.EdgeCheck();
    p.Show();
  }
}
class StopWatch {
  private int startTime = 0, stopTime = 0;
  private boolean running = false;  

  public void Start() {
    startTime = millis();
    running = true;
  }
  public void Stop() {
    stopTime = millis();
    running = false;
  }
  private int GetElapsedTime() {

    if (running) {
      return (millis() - startTime);
    }
    return (stopTime - startTime);
  }
  public int GetSeconds() {
    return (GetElapsedTime() / 1000) % 60;
  }
  public int GetMinutes() {
    return (GetElapsedTime() / (1000*60)) % 60;
  }
  public int GetHours() {
    return (GetElapsedTime() / (1000*60*60)) % 24;
  }
  public void Restart(){
  startTime = millis();
  }
}
class Particle {

  private PVector pos = new PVector(random(width), random(height));
  private PVector vel = new PVector(0, 0);
  private PVector acc = new PVector(0, 0);
  private float maxspeed = 4;

  private PVector prevPos = pos.copy();

  public void Reset() {
    vel.x = 0;
    vel.y = 0;
    acc.x = 0;
    acc.y = 0;
    NewParticlePos();
  }

  public void Update() {
    pos.add(vel);
    vel.add(acc);
    vel.limit(maxspeed);
    acc.mult(0);
  }

  private void ApplyForce(PVector force) {
    acc.add(force);
  } 

  public void Show() {
    stroke(0, 3);
    strokeWeight(1);
    line(pos.x, pos.y, prevPos.x, prevPos.y);
    UpdatePrevious();
  }

  private void NewParticlePos() {
    pos.x = random(width);
    pos.y = random(height);
    UpdatePrevious();
  }
  //keep particles inside edges of window
  public void EdgeCheck() {
    if (pos.x > width ||pos.x < 0) {    
      NewParticlePos();
    }
    if (pos.y > height || pos.y < 0 ) { 
      NewParticlePos();
    }
  }


  public void UpdatePrevious() {
    prevPos.x = pos.x;
    prevPos.y = pos.y;
  }

  public void FollowFlow(PVector[] vectors) {
    int x = PApplet.parseInt(floor(pos.x-1))/scl;
    int y = PApplet.parseInt(floor(pos.y-1))/scl;
    int index = x+y*cols;
    ApplyForce(vectors[index]);

    //debug for vector array
    //if (ind >= vectors.length) {
    //  println(cols);
    //  println(x + " " + y);
    //  println(ind);
    //  println("PROBLEMAS");
    //}
  }
}
  public void settings() {  size(1920, 1080); }
  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "--present", "--window-color=#666666", "--stop-color=#cccccc", "perlin" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}

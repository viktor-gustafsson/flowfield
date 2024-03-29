class Particle {

  private PVector pos;
  private PVector vel;
  private PVector acc;
  private float maxspeed;
  private boolean particleColorWhite;
  private boolean forward;
  private float h;

  private PVector prevPos;

  Particle() {
    h=0;
    pos = new PVector(random(width), random(height));
    vel = new PVector(0, 0);
    acc = new PVector(0, 0);
    prevPos = pos.copy();
    maxspeed = 4;
    forward = false;
  }

  void Reset() {
    vel.x = 0;
    vel.y = 0;
    acc.x = 0;
    acc.y = 0;
    NewParticlePos();
    particleColorWhite = !particleColorWhite;
  }

  void Update() {
    pos.add(vel);
    vel.add(acc);
    vel.limit(maxspeed);
    acc.mult(0);
  }

  private void ApplyForce(PVector force) {
    acc.add(force);
  } 

  void Show() {
    if (particleColorWhite) {
      stroke(255, 3);
    } else if (!particleColorWhite) {
      stroke(0, 3);
    }
    // this is RGB coloration of the particles. Uncomment to activate RGB coloration
    //if (h == 255) {
    //  forward = false;
    //} 
    //if (h==0) {
    //  forward = true;
    //}
    //if (forward) {
    //  h = h+0.5;
    //} 
    //if (!forward) {
    //  h = h-0.5;
    //}
    //stroke(h, 255, 255, 3);
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
  void EdgeCheck() {
    if (pos.x > width ||pos.x < 0) {    
      NewParticlePos();
    }
    if (pos.y > height || pos.y < 0 ) { 
      NewParticlePos();
    }
  }


  void UpdatePrevious() {
    prevPos.x = pos.x;
    prevPos.y = pos.y;
  }

  void FollowFlow(PVector[] vectors) {
    int x = int(floor(pos.x-1))/scl;
    int y = int(floor(pos.y-1))/scl;
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
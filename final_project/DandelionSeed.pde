class DandelionSeed {
  float xpos;
  float ypos;
  boolean update;
  boolean active;
  float updateX = 0;
  float updateY = 0;
  float keepAngle; 
  float vol;
  boolean idleUpdate = false;
  
  DandelionSeed(float x, float y, boolean u, boolean a) {
    xpos = x;
    ypos = y;
    update = u;
    active = a;
  }
  
  void seed(int y, int offset, int offseti) {
    pushMatrix();
    
    if(!update){
      keepAngle = rot*offseti+offset*10;
      rotate(rot*offseti+offset*10); //sets the initial position
    } else {
      //if update is true, move the seeds
      translate(xpos*10, ypos*3);
      rotate((rot*offseti+offset*10)); //keep their original rotation
    }
    
    //seeds and stalks
    strokeWeight(2);
    fill(0, 50);
    ellipse(0,-25,5,-25);
    noFill();
    bezier(0, -35, -10, -90, 10, -110, 10, y); 

    //fluff
    for (int i = 0; i < 7; i++) {
       pushMatrix();       
       translate(10, y);
       
       beginShape();
         //end point
         vertex(30*cos(radians(i*25+20)), -30*sin(radians(i*25+20)));
         //amount of bend
         bezierVertex(0, 25, 0, 0, 0, 0); 
         //end point dots
         circle(35*cos(radians(i*25+20)), -35*sin(radians(i*25+20)), 1);
       endShape();
       popMatrix();
    }
    
    popMatrix();
  }
}

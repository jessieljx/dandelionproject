import ddf.minim.*;
Minim minim;
AudioInput input;
PImage bg;

float angle = 10;
float rot = TWO_PI/18;
int y = -130; //y should be negative
int inactiveCount = 0; // Counter for inactive DandelionSeeds

ArrayList<DandelionSeed> dandelionList;

void setup() {
  size(1600, 1000);
  //generate list to keep all dandelions
  dandelionList = new ArrayList<DandelionSeed>();
  for (int i = 0; i < 18*3; i++) {
    dandelionList.add(new DandelionSeed(0, 0, false, true));
  }
  
  minim = new Minim(this);
  input = minim.getLineIn(Minim.MONO, width, 44100, 16);
  bg = loadImage("grad.png"); 
}

void draw() {
  image(bg, 0,0);
  stroke(0, 80);
  float vol = input.mix.level();
  translate(500, 400);
  
  if (round(millis()/100) % 300 == 0) {
    for (int i = 0; i < 15; i++) {
      DandelionSeed updateSeed = dandelionList.get(int(random(dandelionList.size()-1)));
      updateSeed.update = true;
      updateSeed.idleUpdate = true;
      updateSeed.vol = random(0.05, 0.3);
    } 
  }

  if (vol > 0.043) {
    DandelionSeed updateSeed = dandelionList.get(int(random(dandelionList.size()-1)));
    updateSeed.update = true;
  }
  
  
  //make the stalk sway 
  translate(sin(frameCount*noise(0.2)/20)*4,sin(frameCount*noise(0.2)/20)*4);
  strokeWeight(5);
  bezier(0, 15, -20, 300, 30, 300, 0, 600);
  ellipse(0,0, 30, 30);
  
  //make the head sway
  rotate(sin(frameCount*noise(0.2)/20)*0.05);

  for (int i = 0; i < dandelionList.size(); i++) {
    //this is to set the seeds into different levels
    int offset = 0;
    if (i >= 18 && i < 36) {
       offset = 1;
    } else if (i >=36 && i < dandelionList.size()) {
       offset = 2;
    }
    //generate the seed
    if (dandelionList.get(i).active) {
      dandelionList.get(i).seed(y+-40*offset, offset, i);
    } else {
      //generate new seed when the previous one is out
      if (inactiveCount == 500){
        dandelionList.set(i, new DandelionSeed(0, 0, false, true));
        inactiveCount = 0;
      }
      inactiveCount++; // Increment the counter for inactive DandelionSeeds
    }
          
    if (dandelionList.get(i).update & dandelionList.get(i).active) {
      
      if (dandelionList.get(i).idleUpdate) {
        dandelionList.get(i).updateX += random(50,100) * 0.04 * dandelionList.get(i).vol*10;
        dandelionList.get(i).updateY -= noise(0.2) * 3 * random(50,100)/100 * dandelionList.get(i).vol*10;
        
        dandelionList.get(i).xpos = dandelionList.get(i).updateX;
        dandelionList.get(i).ypos = dandelionList.get(i).updateY;
        
      } else {
        dandelionList.get(i).updateX += random(50,100) * 0.04;
        dandelionList.get(i).updateY -= noise(0.2) * 3 * random(50,100)/100;
        
        dandelionList.get(i).xpos = dandelionList.get(i).updateX;
        dandelionList.get(i).ypos = dandelionList.get(i).updateY;
      }
    }
    
    if (abs(dandelionList.get(i).updateX) > 200) { //if the seed is outside of frame = inactive
      dandelionList.get(i).active = false;
    }
  }
}

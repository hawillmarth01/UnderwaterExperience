//CSCI 5611 PROJECT 1
//Underwater Experience
//(Hannah Willmarth)

//Background color variables
color bottom;
color top;

//Fish data/ variables 
static int numFish = 300; //total # of fish
Object fish;
//speed/ force bounds (TUNE)
float maxForce = 0.1;
float maxSpeed = 10.0;
float targetSpeed = 10.0; 

//arrays to keep track of location/movement components of fish
Vec3 position[] = new Vec3[numFish];
Vec3 velocity[] = new Vec3[numFish];
Vec3 acceleration[] = new Vec3[numFish];

//Shark data/ variables
Object shark;
float sharkSpeed = 60.0; //TUNE
Vec3 spaceVel = new Vec3(0,0,sharkSpeed); //initial forward movement (from center)

//vectors to keep track of shark location/movement
Vec3 position_shark = new Vec3(400,350,-200);
Vec3 velocity_shark = new Vec3(0,0,0);

//SET-UP
void setup(){
  size(900, 700, P3D); //frame set-up
  
  //Background Set-up (TUNE)
  top = color(153, 204, 255);
  bottom = color(0,102,204);
  
  //FISH SET-UP
  fish = new Object("Fish2.obj");
  fish.position = new Vec3(0,0,0);
  fish.rotation = new Vec3(0,180,180);
  fish.size = 3.0;
  
  initFish(); //initialize fish arrays
  
  //SHARK SET-UP
  shark = new Object("Shark.obj");
  shark.position = new Vec3(0,0,0);
  shark.rotation = new Vec3(180,180,0);
  shark.size = 20.0; 
}

//Initialize fish positions and velocities
void initFish(){
  //populate arrays
  for (int f = 0; f < numFish; f ++){
    position[f] = new Vec3(600,500,350); //TUNE: coming from bottom left corner
    velocity[f] = new Vec3(cos(random(TWO_PI)), sin(random(TWO_PI)), sin(random(TWO_PI))); //TUNE
    
    velocity[f].normalize();
    velocity[f].mul(maxSpeed); //scale
  }   
}

//Rendering-- add lighting
//Note: Used BallLit3D Ex. as reference for this
void renderScene(){
  specular(100, 100, 200);  //set-up
  ambientLight(150,150,150); lightSpecular(255,255,255); //brighten
  directionalLight(125, 125, 250, 0, 1, -1); //add directional light (i.e. attempt to make deeper = darker)
}

//UPDATE SHARK/FISH POSITIONS
void update(){
  for (int f = 0; f < numFish; f++){
    float dt = 0.12; //TUNE-- change in time
    
    //update velocity
    velocity[f] = velocity[f].plus(acceleration[f].times(dt));
    //keep in speed bound
    if (velocity[f].length() > maxSpeed){
      velocity[f] = velocity[f].normalized().times(maxSpeed);
    }
    
    //update position
    position[f] = position[f].plus(velocity[f].times(dt));
    
    //FRAME BORDERS
    //when fish exit frame, recreate them
    float fish_sz = 10.0; // TUNE
    if (position[f].x < -fish_sz) position[f].x = width + fish_sz;
    if (position[f].x > width + fish_sz) position[f].x = -fish_sz;
    if (position[f].y < -fish_sz) position[f].y = height + fish_sz;
    if (position[f].y > height + fish_sz) position[f].y = -fish_sz;
    //if (position[f].z > fish_sz) position[f].z = 0;
    //if (position[f].z < -700) position[f].z = 0;
   
    //OBTACLE AVOIDANCE-- fish avoid shark
    float shark_sz = 150; //TUNE 
    //Note: Week2 in class activity was referenced for this.
    //check if too close to shark
    if (position[f].distanceTo(position_shark) < (shark_sz)){
      Vec3 positionNorm = (position[f].minus(position_shark)).normalized();
      position[f] = position_shark.plus(positionNorm.times(shark_sz).times(1.01));
      Vec3 velocityNorm = positionNorm.times(dot(velocity[f], positionNorm));
      velocity[f].subtract(velocityNorm.times(1 + fish_sz));
    }
    
    //reset acceleration each cycle
    acceleration[f].times(0); 
  }
 
  //USER-INTERACTION-- Shark
  //description further down
  velocity_shark = new Vec3(0,0,0);
  float dt = 1.0/frameRate;
  
  //reset to bottom left corner
  if (reset_l){
    shark.rotation = new Vec3(160,60,0);
    position_shark = new Vec3(10,500,400);
    spaceVel = new Vec3(sharkSpeed, -sharkSpeed/4, -sharkSpeed/3); //forward movement
  }
  //reset to bottom right corner
  if (reset_r){
    shark.rotation = new Vec3(180,300,0);
    position_shark = new Vec3(720,500,461);
    spaceVel = new Vec3(-sharkSpeed, -sharkSpeed/4, -sharkSpeed/3); //forward movement
  }
  //reset to center
  if (reset_c){
    shark.rotation = new Vec3(180,180,0);
    position_shark = new Vec3(400,350,-200);
    spaceVel = new Vec3(0, 0, sharkSpeed); //forward movement
  }
  //Key Updates:
  if (space) velocity_shark.add(spaceVel);
  if (up) velocity_shark.add(new Vec3(0,-sharkSpeed, 0));
  if (down) velocity_shark.add(new Vec3(0,sharkSpeed, 0));
  if (right) velocity_shark.add(new Vec3(sharkSpeed,0, 0));
  if (left) velocity_shark.add(new Vec3(-sharkSpeed,0, 0));
  //update shark velocity
  velocity_shark.clampToLength(sharkSpeed);
  position_shark.add(velocity_shark.times(dt));
}

//DRAW FRAME
void draw(){
  //background(0,100,155); //blue background
  //gradient background-- deeper = darker
  gradient(width, height, top, bottom); 
  
  renderScene();
 
  //SHARK-- draw
  pushMatrix();
  translate(position_shark.x, position_shark.y, position_shark.z);
  shark.draw();
  popMatrix();
  
  //FISH -- draw
  for (int f = 0; f < numFish; f++){
    pushMatrix();
    translate(position[f].x, position[f].y, position[f].z);
    
    //rotate towards direction of motion
    //Note: Referenced processing forum mentioned in write-up for rotation angle calculations
    float rotX = -atan2(position[f].y, position[f].x);
    float rotY = atan2(position[f].x, sqrt((position[f].y*position[f].y) + (position[f].z*position[f].z)));
    rotateX(rotX);
    rotateY(rotY); 
    
    fish.draw();
    popMatrix();
  }
  
  //go through all fish -- ADD 3 FORCES TO ACCELERATION
  for (int f = 0; f < numFish; f++){
    acceleration[f] = new Vec3(0,0,0);
    
    //SEPARATION
    Vec3 sF = separate(f);
    acceleration[f].add(sF);
    
    //COHESION
    Vec3 avePosition = cohesion(f);
    Vec3 cF = toTarget(avePosition, f);
    cF.mul(2.5); //weight
    acceleration[f].add(cF); 
    
    //ALIGNMENT
    Vec3 aF = alignment(f);
    aF.mul(4.5); //weight
    acceleration[f].add(aF); 
    
    //Extra "wander" force
    Vec3 wanderForce = new Vec3(1-random(2),1-random(2), 1-random(2)); //TUNE
    acceleration[f] = acceleration[f].plus(wanderForce.times(3.0)); //TUNE  
  }
  
  update();
}

//Creates gradient background 
//(Note: Referenced Linear Gradient  Ex. on processing.org)
void gradient(float wid, float heigh, color c1, color c2){
  // dark to light (from bottom to top)
  for (int i = 0; i <= heigh; i++) {
      float interpolate = map(i, 0, heigh, 0, 1); //maps val from one range to another: value, start1, stop1, start2, stop2
      color currColor = lerpColor(c1, c2, interpolate);
      stroke(currColor);
      line(0, i, wid, i); //left edge to right edge
    }
}

//SEPARATION-- given fish and neighbor, return separation force vector
//(ensure fish don't get too close to neighbors)
Vec3 separate(int fish){
    Vec3 separationForce = new Vec3(0,0,0); //vector to store separation force
    int count = 0;
    float separationBound = 5.0; //TUNE
    
    //iterate through neighbors
    for (int n = 0; n < numFish; n++){
      float distance = position[fish].distanceTo(position[n]); //distance between fish and neighbor
      if ((distance > 0) && (distance < separationBound)){ //if positive distance less than separation bound
        //vector to point away from neighbor = fish position - neighbor position (normalized)
        Vec3 away = position[fish].minus(position[n]);
        away.normalize();
        away.mul(1.0/distance); //divide by distance between 
        separationForce.add(away);
        count ++;
      }
    }
    if (count > 0){
      separationForce.mul(1.0/count); //average
    }
    
    return separationForce;
}

//COHESION-- given fish, return average position vector
//(move towards average position of neighbors)
Vec3 cohesion(int fish){
  Vec3 avePosition = new Vec3(0,0,0); //vector to store average position
  int count = 0;
  float neighborDistance = 30; //TUNE
  
  //iterate through neighbors
  for (int n = 0; n < numFish; n++){
    float distance = position[fish].distanceTo(position[n]); //distance between fish and neighbor 
    if ((distance < neighborDistance) && (distance > 0.0)){ 
      avePosition.add(position[n]); //add neighbor position
      count ++;
    }
  }
  if (count > 0){
    avePosition.mul(1.0/count); //average
    
    return avePosition;
  }
  else{
    return new Vec3(0,0,0);
  }  
}
//Steering force (used with cohesion force)
Vec3 toTarget(Vec3 avePosition, int fish){
  //make vector from current location to target
  Vec3 steerTo = avePosition.minus(position[fish]);
  steerTo.normalize();
  steerTo.mul(maxSpeed); //scale
  
  //steering = target - velocity 
  steerTo.subtract(velocity[fish]);
  steerTo.clampToLength(maxForce);
  
  return steerTo;
}

//ALIGNMENT-- given fish, return average velocity vector 
//(try to match velocity of neighbors)
Vec3 alignment(int fish){
  Vec3 aveVelocity = new Vec3(0,0,0); //vector to store average velocity
  int count = 0;
  float neighborDistance = 10; //TUNE
  
  //iterate through neighbors
  for (int n = 0; n <  numFish; n++){ 
      float distance = position[fish].distanceTo(position[n]); //distance between fish and neighbor
      if ((distance < neighborDistance) && (distance > 0)){ 
        aveVelocity.add(velocity[n]);
        count ++;
      }
   }
   if (count > 0){
      aveVelocity.mul(1.0/count); //average
      aveVelocity.clampToLength(maxForce); //force bound
   }
   
   return aveVelocity;
}

//USER-INTERACTION (Shark controls)
//Moving shark: space = foward, left/right/up/down = as expected
//Once reach end of frame: can reset shark in lower left('l')/ right ('r') corners or center('c'). 
//(Shark starts in center)

boolean left, right, down, space, up, reset_l, reset_r, reset_c;
void keyPressed(){
  if (keyCode == ' ') space = true;
  if ( keyCode == UP ) up = true;
  if(keyCode == DOWN) down = true;
  if ( keyCode == RIGHT ) right = true;
  if ( keyCode == LEFT) left = true;
  if (key == 'l') reset_l = true;
  if (key == 'r') reset_r = true;
  if (key == 'c') reset_c = true;
}

void keyReleased(){
  if (keyCode == ' ') space = false;
  if ( keyCode == UP  ) up = false;
  if (keyCode == DOWN) down = false;
  if ( keyCode == RIGHT ) right = false;
  if ( keyCode == LEFT    ) left = false;
  if (key == 'l') reset_l = false;
  if (key == 'r') reset_r = false;
  if (key == 'c') reset_c = false;
}

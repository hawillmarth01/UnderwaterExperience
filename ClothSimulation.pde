//CLOTH SIMULATION

//Rope Variables
//float node_radius = 3; 
//int numRopes = 3; 
//Rope [] ropes = new Rope[numRopes];

//Cloth Variables
Vec3 position[][];
Vec3 velocity[][];
Vec3 accel[][];

//Reminder: Start with 3x3 cloth!!
int x_nodes = 20; //cloth width
int y_nodes = 10; //cloth height

//Constant variables
Vec3 gravity = new Vec3(0,250,0); //TUNE?
float ksv = 250; //TUNE- spring constant vertical
float ksh = 300; //TUNE- spring constant horizontal
float kd = 50; //TUNE- damp
float restLength = 10; 
float mass = 1; 

//Ball Variables
float radius = 45;
Vec3 ball_position = new Vec3(300,385,-70);
float ballSpeed = 30;
Vec3 ballVel;

//Camera Object
Camera camera;

void setup() {
  size(650, 500, P3D);
  
  //Camera intialization
  camera = new Camera();
 
  //Rope system initialization
  //for (int r = 0 ; r < numRopes; r++){
  //  ropes[r] = new Rope();
  //  ropes[r].SetRoot(20*r+150, 100,0); //0 for Z?
  //  ropes[r].InitializeNodes((r*-5)+15); //TUNE --factor
  //}
  
  //Cloth initialization
  position = new Vec3[x_nodes][y_nodes];
  velocity = new Vec3[x_nodes][y_nodes];
  accel = new Vec3[x_nodes][y_nodes];
  
  //set intial node positions to give cloth inital swing
  for (int x_curr = 0; x_curr < x_nodes; x_curr++){
    for (int y_curr = 0; y_curr < y_nodes; y_curr++){ 
      position[x_curr][y_curr] = new Vec3(0,0,0);
      
      //set z
      position[x_curr][y_curr].z = (x_curr)*-10; //TUNE- 3D
      
      if (y_curr == 0){ //top row
        position[x_curr][y_curr].x = 250;
        position[x_curr][y_curr].y = 250;
      }
      else{
        //make each node a little lower than the one above
        //set x
        float x_factor = 3; //TUNE
        position[x_curr][y_curr].x = position[x_curr][y_curr-1].x + (y_curr*x_factor); 
        
        //set y
        //float y_factor = 3; //TUNE
        position[x_curr][y_curr].y = position[x_curr][y_curr-1].y + restLength; // + (y_curr*y_factor);
      }
      
      //intialize velocity and acceleration
      velocity[x_curr][y_curr] = new Vec3(0,0,0); 
      accel[x_curr][y_curr] = new Vec3(0,0,0);
     }
   }  
}

void update(float dt){
  //Rope system Update
  //for (int r = 0; r < numRopes; r++){
  //  ropes[r].update(dt);
  //}
  
  //Ball Update
  //User-controlled: '<' makes the ball move to the left and '>' makes the ball move to the right
  ballVel = new Vec3(0,0,0);
  if (left) ballVel.add(new Vec3 (-ballSpeed,0,0)); //move left
  if (right) ballVel.add(new Vec3(ballSpeed,0,0)); //move right
  ballVel.clampToLength(ballSpeed);
  ball_position.add(ballVel.times(dt));
  
  //Cloth Update
  //Vec3 new_velocity[][] = velocity; //in progress velocity vector
  //reset accelerations
  for (int i = 0; i < x_nodes; i++){
    for (int j = 0; j < y_nodes; j++){
     accel[i][j] = new Vec3(0,0,0);
     accel[i][j].add(gravity);
    }
  }
  //horizontal nodes
  for (int x_curr = 0; x_curr < x_nodes-1; x_curr++){
    for (int y_curr = 0; y_curr < y_nodes; y_curr++){
      Vec3 dist = position[x_curr+1][y_curr].minus(position[x_curr][y_curr]);
      float e_length = dist.length(); //save length val
      Vec3 strDirection = dist.normalized(); //normalize distance
      float sprForce = -ksh*(e_length - restLength); //spring force
      
      float vel1 = dot(velocity[x_curr][y_curr], strDirection);
      float vel2 = dot(velocity[x_curr+1][y_curr], strDirection);
      float dampForce = -kd*(vel2 - vel1); //damping force
      
      Vec3 forceThread = strDirection.times(sprForce + dampForce); //total force
      //add force to accelerations of current/next nodes
      accel[x_curr][y_curr].add(forceThread.times(-1.0/mass));
      accel[x_curr+1][y_curr].add(forceThread.times(1.0/mass)); 
    }  
  }
  //vertical nodes
  for (int x_curr = 0; x_curr < x_nodes; x_curr++){
    for (int y_curr = 0; y_curr < y_nodes-1; y_curr++){
      Vec3 dist = position[x_curr][y_curr + 1].minus(position[x_curr][y_curr]);
      float e_length = dist.length(); //save length val
      Vec3 strDirection = dist.normalized(); //normalize distance
      float sprForce = -ksv*(e_length - restLength); //spring force
      
      float vel1 = dot(velocity[x_curr][y_curr], strDirection);
      float vel2 = dot(velocity[x_curr][y_curr+1], strDirection);
      float dampForce = -kd*(vel2-vel1); //damping force
      
      Vec3 forceThread = strDirection.times(sprForce + dampForce); //total force
      //add force to accelerations of current/next nodes
      accel[x_curr][y_curr].add(forceThread.times(-1.0/mass));
      accel[x_curr][y_curr+1].add(forceThread.times(1.0/mass));
    }
  }
 
  //Eulerian Integration --- TUNE if time
  for (int x_curr = 0; x_curr < x_nodes; x_curr++){
    //Note: top row is fixed
    for (int y_curr = 1; y_curr < y_nodes; y_curr++){ 
        velocity[x_curr][y_curr].add(accel[x_curr][y_curr].times(dt)); //update velocity
        position[x_curr][y_curr].add(velocity[x_curr][y_curr].times(dt)); //update position
    }
  }
   
   //Ball-Collision Detection
   float COR = 0.1; //TUNE coefficient of restitution
   for (int x_curr = 0; x_curr < x_nodes; x_curr++){
    for (int y_curr = 1; y_curr < y_nodes; y_curr++){
      float dist = ball_position.distanceTo(position[x_curr][y_curr]);
      //check if colliding with ball
      if (dist < radius + 0.9){ //TUNE 0.9
        //position update
        Vec3 position_normal = (position[x_curr][y_curr].minus(ball_position)).normalized();
        position[x_curr][y_curr] = ball_position.plus(position_normal.times(radius+0.9)); 
        
        //velocity update
        Vec3 velocity_normal = position_normal.times(dot(velocity[x_curr][y_curr],position_normal));
        velocity[x_curr][y_curr].subtract(velocity_normal.times(1+COR));
      }
    }
   }
}

void draw(){
  //Load/use field image for background
  PImage img;
  img = loadImage("field.jpg");
  img.resize(width, height);
  background(img);
  //background(255,255,255); //white background
  
  //Update Camera
  camera.Update(1/(frameRate));
  
  //Update ropes
  //for (int r = 0; r < numRopes; r++){
  //  ropes[r].draw();
  //}
  
  //Update Cloth
  //update 20x -- TUNE
  int j = 0;
  while (j < 20){
    update(1/(20*frameRate)); //TUNE
    j++;
  }
  
  //Draw Clothesline
  //clothesline
  strokeWeight(2);
  stroke(139,69,19); //brown
  line(position[0][0].x,position[0][0].y,position[0][0].z+50,position[x_nodes-1][0].x,position[x_nodes-1][0].y,position[x_nodes-1][0].z-50);
  //poles
  strokeWeight(4);
  stroke(153); //gray
  line(position[0][0].x,position[0][0].y,position[0][0].z+50,position[0][0].x,position[0][0].y+150,position[0][0].z+50);
  line(position[x_nodes-1][0].x,position[x_nodes-1][0].y,position[x_nodes-1][0].z-50, position[x_nodes-1][0].x,position[x_nodes-1][0].y+150,position[x_nodes-1][0].z-50);
  
  //Draw Cloth
  boolean stripe = true; //when true, is drawing part of colored vertical stripe
  for (int x_curr = 0; x_curr < x_nodes-1; x_curr++){
    for (int y_curr = 0; y_curr < y_nodes-1; y_curr++){
      if(stripe){ fill(170,240,209); } //mint
      else{ fill(255,255,255); } //white
      //fill in between nodes
      noStroke();
      beginShape();
      vertex(position[x_curr][y_curr].x, position[x_curr][y_curr].y, position[x_curr][y_curr].z);
      vertex(position[x_curr][y_curr+1].x, position[x_curr][y_curr+1].y, position[x_curr][y_curr+1].z);
      vertex(position[x_curr+1][y_curr+1].x, position[x_curr+1][y_curr+1].y, position[x_curr+1][y_curr+1].z);
      vertex(position[x_curr+1][y_curr].x, position[x_curr+1][y_curr].y, position[x_curr+1][y_curr].z);
      endShape(CLOSE);
    }
    stripe = !(stripe); //switch colors
  }
  
  //Draw Ball
  //rendering(lighting)
  shininess(60);
  lights();
  directionalLight(255, 255, 255, -0.5, 0.5, 0.5);
  
  //sphere
  fill(237,67,55); //red
  pushMatrix();
  translate(ball_position.x, ball_position.y, ball_position.z);
  sphere(radius); //ball
  popMatrix();
}

//KEYBOARD COMMANDS FOR BALL AND CAMERA
//Ball: '<' to move left, '>' to move right
//Camera: 'up arrow' to move away, 'down arrow' to move closer,
//'left arrow' to rotate left, 'right arrow' to rotate right
//'r'/'R' to reset view

boolean left, right; //ball command variables
void keyPressed(){
  //camera commands
  camera.HandleKeyPressed();
  
  //ball commands
  if (keyCode == ',') left = true;
  if (keyCode == '.') right = true;
}

void keyReleased(){
  //camera commands
  camera.HandleKeyReleased(); 
  
  //ball commands
  if (keyCode == ',') left = false;
  if (keyCode == '.') right = false;
}

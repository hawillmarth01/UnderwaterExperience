//Class used for system of ropes
//Note: Only used as a "conceptual starting place", is now commented out in code
class Rope{
  //each rope has position, velocity, and acceleration
  Vec3 position[];
  Vec3 velocity[];
  Vec3 accel[];
  Vec3 ropeRoot;
  int numNodes = 10; //TUNE
  
  Vec3 gravity = new Vec3(0,400,0); //CHECK???
  //TUNE
  float node_radius = 3; 
  float restLength = 10; 
  float mass = 0.3; 
  
  float k = 80;
  float kv = 2;
  
  public Rope(){ //pass in root position (top)
    ropeRoot = new Vec3(0, 0, 0);
    position = new Vec3[numNodes];
    velocity = new Vec3[numNodes];
    accel = new Vec3[numNodes];
  } 
  
  void SetRoot(float x_root, float y_root, float z_root){
    ropeRoot = new Vec3(x_root, y_root, z_root);
  }
  
  //initialize position, velocity and acceleration vectors for X ropes
  void InitializeNodes(float factor){
    for (int i = 0; i < numNodes; i++){
      position[i] = new Vec3(0,0,0);
      position[i].x = ropeRoot.x - (factor*i); //TUNE
      
      //make each node a little further down
      position[i].y = ropeRoot.y + (8*i) + (5*i); //TUNE
    
      //Z POSITION?
      
      velocity[i] = new Vec3(0,0,0);  
    }
  }
  
  void update(float dt){
    //reset accelerations
    for (int i = 0; i < numNodes; i++){
      accel[i] = new Vec3(0,0,0);
      accel[i].add(gravity);
    }
  
    //Hooke's Law-- damped force per node
    for (int i = 0; i < numNodes-1; i ++){
      Vec3 dist = position[i+1].minus(position[i]); //difference between current and next node
      float strForce = -k*(dist.length() - restLength);
      
      Vec3 strDirection = dist.normalized(); 
      //compute velcoity in direction of thread
      float projectVB = dot(velocity[i], strDirection); //velocity bottom
      float projectVT = dot(velocity[i+1], strDirection); //velocity top
      float dampForce = -kv*(projectVT - projectVB);
      
      Vec3 totalForce = strDirection.times(strForce + dampForce); //TUNE //.minus(velocity[i].time(0.09));
      
      //add forces to accelerations
      accel[i].add(totalForce.times(-1.0/mass)); //divide by mass, *-1 for direction
      accel[i+1].add(totalForce.times(1.0/mass)); //divide by mass, *+1 for direction
    }
    
    //Eulerian Integration---TUNE
    for (int i = 1; i < numNodes; i++){
      velocity[i].add(accel[i].times(dt));
      position[i].add(velocity[i].times(dt));
    }
  
  }
  
  void draw(){
    fill(0,0,0); //black nodes
  
    for (int i = 0; i < numNodes-1; i++){ 
      pushMatrix();
      line(position[i].x, position[i].y, position[i+1].x, position[i+1].y); //connector
      translate(position[i+1].x, position[i+1].y); //node placement
      sphere(node_radius); //node
      popMatrix();
    }
  }
};

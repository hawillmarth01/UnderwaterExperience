//3D VECTOR LIBRARY
public class Vec3 {
  public float x, y, z;
  
  //Construct a new vector
  public Vec3(float x, float y, float z){
    this.x = x; //x component
    this.y = y; //y component
    this.z = z; //z component
  }
  
  //Prints 3D vector
  public String toString(){
    return "(" + x + ", " + y + ", "+ z + ")";
  }
  
  //Return the length of this vector
  public float length(){
    float length = sqrt((this.x * this.x) + (this.y * this.y) + (this.z * this.z)); //magnitude
    return length;
  }
  
  //Return the square of the length of this vector
  public float lengthSqr(){
    float lengthSqr = (this.x * this.x) + (this.y * this.y) + (this.z * this.z); //squared, takes away square root
    return lengthSqr;
  }
  
  //Return a new vector with the value of this vector plus the rhs vector
  public Vec3 plus(Vec3 rhs){
    float newX = this.x + rhs.x; //new x
    float newY = this.y + rhs.y; //new y
    float newZ = this.z + rhs.z; //new z
    
    return new Vec3(newX, newY, newZ);
  }
  
  //Add the rhs vector to this vector
  public void add(Vec3 rhs){
    this.x += rhs.x; //modified x
    this.y += rhs.y; //modified y
    this.z += rhs.z; //modified z
  }
  
  //Return a new vector with the value of this vector minus the rhs vector
  public Vec3 minus(Vec3 rhs){
    float newX = this.x - rhs.x; //new x
    float newY = this.y - rhs.y; //new y
    float newZ = this.z - rhs.z; //new z
    
    return new Vec3(newX, newY, newZ);
  }
  
  //Subtract the vector rhs from this vector
  public void subtract(Vec3 rhs){
    this.x -= rhs.x; //modified x
    this.y -= rhs.y; //modified y
    this.z -= rhs.z; //modified z
  }
  
  //Return a new vector that is this vector scaled by rhs
  public Vec3 times(float rhs){
    float newX = this.x * rhs; //new x
    float newY = this.y * rhs; //new y
    float newZ = this.z * rhs; //new z
    
    return new Vec3(newX, newY, newZ);
  }
  
  //Scale this vector by rhs
  public void mul(float rhs){
    this.x *= rhs; //modified x
    this.y *= rhs; //modified y
    this.z *= rhs; //modidied z
  }
  
  //Rescale this vector to have a unit length
  public void normalize(){
    float length = this.length(); //magnitude
    this.x /= length; //modified x
    this.y /= length; //modified y
    this.z /= length; //modified z
  }
  
  //Return a new vector in the same direction as this one, but with unit length
  public Vec3 normalized(){
    float length = this.length(); //magnitude
    float newX = this.x / length; //new x
    float newY = this.y / length; //new y
    float newZ = this.z / length; //new z
    
    return new Vec3(newX, newY, newZ);
  }
  
  //If the vector is longer than maxL, shrink it to be maxL otherwise do nothing
  public void clampToLength(float maxL){
    if (this.length() > maxL) {
      float shrinkScalar = maxL / this.length();
      this.x *= shrinkScalar; //modified x
      this.y *= shrinkScalar; //modified y
      this.z *= shrinkScalar; //modified z
    }
    //else do nothing
  }
  
  //Grow or shrink the vector have a length of newL
  public void setToLength(float newL){
    float setScalar = newL / this.length();
    this.x *= setScalar; //modified x
    this.y *= setScalar; //modified y
    this.z *= setScalar; //modifed z
  }
  //Interepret the two vectors (this and the rhs) as points. How far away are they?
  public float distanceTo(Vec3 rhs){
    float x_comp = (this.x - rhs.x) * (this.x - rhs.x); //(x1-x2)^2
    float y_comp = (this.y - rhs.y) * (this.y - rhs.y); //(y1-y2)^2
    float z_comp = (this.z -rhs.z) * (this.z - rhs.z); //(z1-z2)^2
    float distance = sqrt(x_comp + y_comp + z_comp); 
    
    return distance; 
  }
}

//Interpolation of vector components
 float interpolate(float a, float b, float t){
   return a + ((b-a)*t);
 }
 
Vec3 interpolate(Vec3 a, Vec3 b, float t){
  float newX = interpolate(a.x, b.x, t); //new x
  float newY = interpolate(a.y, b.y, t);; //new y
  float newZ = interpolate(a.z, b.z, t);; //new z
  
  return new Vec3(newX, newY, newZ);
}

//Dot product of vector a and vector b
float dot(Vec3 a, Vec3 b){
  float dotProduct = (a.x * b.x) + (a.y * b.y)+ (a.z * b.z); 
    
  return dotProduct;
}

//Cross product of vector a and vector b
Vec3 cross(Vec3 a, Vec3 b){
  float newX = (a.y*b.z) - (a.z*b.y); //new x
  float newY = (a.z*b.x) - (a.x*b.z); //new y
  float newZ = (a.x*b.y) - (a.y*b.x); //new z
  
  return new Vec3(newX, newY, newZ);
}

//Projection of vector a onto vector b
Vec3 projAB(Vec3 a, Vec3 b){
  float projScalar = (dot(a, b)) / b.lengthSqr(); 
  float newX = b.x * projScalar; //new x
  float newY = b.y * projScalar; //new y
  float newZ = b.z * projScalar; //new z
   
  //prevent -0.0
  if (newX == -0.0){newX = 0.0;}
  if (newY == -0.0){newY = 0.0;}
  if (newZ == -0.0){newZ = 0.0;}
   
  return new Vec3(newX, newY, newZ);
 
}

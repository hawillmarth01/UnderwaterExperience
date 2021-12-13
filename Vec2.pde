//Vector Library [2D]
//CSCI 5611 Vector 2 Library [Complete]

//Instructions: Implement all of the following vector operations--

public class Vec2 {
  public float x, y;
  
  //Construct a new vector (ie set x and y)
  public Vec2(float x, float y){
    this.x = x; //x component
    this.y = y; //y component
  }
  
  //Prints 2D vector
  public String toString(){
    return "(" + x+ ", " + y +")";
  }
  
  //Return the length of this vector
  public float length(){
    float length = sqrt((this.x * this.x) + (this.y * this.y)); //magnitude
    return length;
  }
  
  //Return the square of the length of this vector
  public float lengthSqr(){
    float lengthSqr = (this.x * this.x) + (this.y * this.y); //squared, takes away square root
    return lengthSqr;
  }
  
  //Return a new vector with the value of this vector plus the rhs vector
  public Vec2 plus(Vec2 rhs){
    float newX = this.x + rhs.x; //new x
    float newY = this.y + rhs.y; //new y
    
    return new Vec2(newX, newY);
  }
  
  //Add the rhs vector to this vector
  public void add(Vec2 rhs){
    this.x += rhs.x; //modified x
    this.y += rhs.y; //modified y
  }
  
  //Return a new vector with the value of this vector minus the rhs vector
  public Vec2 minus(Vec2 rhs){
    float newX = this.x - rhs.x; //new x
    float newY = this.y - rhs.y; //new y
    
    return new Vec2(newX, newY);
  }
  
  //Subtract the vector rhs from this vector
  public void subtract(Vec2 rhs){
    this.x -= rhs.x; //modified x
    this.y -= rhs.y; //modified y
  }
  
  //Return a new vector that is this vector scaled by rhs
  public Vec2 times(float rhs){
    float newX = this.x * rhs; //new x
    float newY = this.y * rhs; //new y
    
    return new Vec2(newX, newY);
  }
  
  //Scale this vector by rhs
  public void mul(float rhs){
    this.x *= rhs; //modified x
    this.y *= rhs; //modified y
  }
  
  //Rescale this vector to have a unit length
  public void normalize(){
    float length = this.length(); //magnitude
    this.x /= length; //modified x
    this.y /= length; //modified y
    
  }
  
  //Return a new vector in the same direction as this one, but with unit length
  public Vec2 normalized(){
    float length = this.length(); //magnitude
    float newX = this.x / length; //new x
    float newY = this.y / length; //new y
    
    return new Vec2(newX, newY);
  }
  
  //If the vector is longer than maxL, shrink it to be maxL otherwise do nothing
  public void clampToLength(float maxL){
    if (this.length() > maxL) {
      float shrinkScalar = maxL / this.length();
      this.x *= shrinkScalar; //modified x
      this.y *= shrinkScalar; //modified y
    }
    //else do nothing
  }
  
  //Grow or shrink the vector have a length of newL
  public void setToLength(float newL){
    float setScalar = newL / this.length();
    this.x *= setScalar; //modified x
    this.y *= setScalar; //modified y
  }
  
  //Interepret the two vectors (this and the rhs) as points. How far away are they?
  public float distanceTo(Vec2 rhs){
    float x_comp = (this.x - rhs.x) * (this.x - rhs.x); //(x1-x2)^2
    float y_comp = (this.y - rhs.y) * (this.y - rhs.y); //(y1-y2)^2
    float distance = sqrt(x_comp + y_comp); 
    
    return distance; 
  }
}
  
 ////Interpolation of vector components
 //float interpolate(float a, float b, float t){
 //  return a + ((b-a)*t);
 //}
  
 ////Interpolated vector given vector a and vector b
 //Vec2 interpolate(Vec2 a, Vec2 b, float t){
 //  float newX = interpolate(a.x, b.x, t); //new x
 //  float newY = interpolate(a.y, b.y, t);; //new y
    
 //  return new Vec2(newX, newY);
 //}
  
 //Dot product of vector a and vector b
 float dot(Vec2 a, Vec2 b){
   float dotProduct = (a.x * b.x) + (a.y * b.y); 
    
   return dotProduct;
 }
  
 //Projection of vector a onto vector b
 Vec2 projAB(Vec2 a, Vec2 b){
   float projScalar = (dot(a, b)) / b.lengthSqr(); 
   float newX = b.x * projScalar; //new x
   float newY = b.y * projScalar; //new y
   
   //prevent -0.0
   if (newX == -0.0){newX = 0.0;}
   if (newY == -0.0){newY = 0.0;}
   
   return new Vec2(newX, newY);
 }

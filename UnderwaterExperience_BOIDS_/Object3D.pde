//HELPER CLASS FOR 3D OBJECTS
//Note: Used CameraExample for reference

class Object{
  //Aspects of 3D object
  public Vec3 position;
  public Vec3 rotation;
  public float size;
  
  //Use PShape to load mesh file
  public PShape object;
  
  //Constructor-- given filename of mesh (path)
  public Object(String path){
    object = loadShape(path);
    
    position = new Vec3(0,0,0); //x,y,z
    rotation = new Vec3(0,0,0); //x rotation, y rotation, z rotation
    size = 10.0; //TUNE
  }
  
  //Create 3D object w/ given aspects
  private void updateObject(Vec3 updatePos, Vec3 updateRot, float updateSize){
    pushMatrix();
    translate(updatePos.x, updatePos.y, updatePos.z);
    rotateX(updateRot.x * PI /180.0); //convert to radians
    rotateY(updateRot.y * PI / 180.0); //convert to radians
    rotateZ(updateRot.z * PI / 180.0); //convert to radians
    scale(updateSize, updateSize, updateSize); //scale on all axes
    shape(object); //draw
    popMatrix();
  }
  
  //Draw 3D object
  public void draw(){
    updateObject(this.position, this.rotation, this.size);
  }
}

class Sprite{
  PImage img;
  float center_x, center_y;
  float change_x, change_y;
  float w,h;
  
  Sprite(String filename, float scale, float x, float y){
    img=loadImage(filename);
    w=img.width*scale;
    h=img.height*scale;
    center_x=x;
    center_y=y;
    change_x=0;
    change_y=0;
  }
  Sprite(String filename, float scale){
    this(filename,scale,0,0);
  }
  Sprite(PImage mg, float scale){
    img=mg;
    w=img.width*scale;
    h=img.height*scale;
    center_x=0;
    center_y=0;
    change_x=0;
    change_y=0;
  }
    
  void display(){
    image(img,center_x,center_y,w,h);
  }
  void update(){
    center_x+=change_x;
    center_y+=change_y;
  }
  float getLeft(){
    return center_x-w/2;
  }
  float getRight(){
    return center_x+w/2;
  }
  float getTop(){
    return center_y-h/2;
  }
  float getBottom(){
    return center_y+h/2;
  }
  void setLeft(float newLeft){
    center_x=newLeft+w/2;
  }
  void setRight(float newRight){
    center_x=newRight-w/2;
  }
  void setBottom(float newBottom){
    center_y=newBottom-h/2;
  }
  void setTop(float newTop){
    center_y=newTop+h/2;
  }
}

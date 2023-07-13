class AnimatedSprite extends Sprite{
  PImage[] currentImages;
  PImage[] standNeutral;
  PImage[] moveLeft;
  PImage[] moveRight;
  int direction;
  int index;
  int frame;
  AnimatedSprite(PImage img, float scale){
    super(img,scale);
    direction=NEUTRAL_FACING;
    index=0;
    frame=0;
  }
  void updateAnimation(){
    frame++;
    if(frame%5==0){
      selectDirection();
      selectCurrentImages();
      advanceToNextImage();
    }
  }
  void selectDirection(){
    if(change_x>0){
      direction=RIGHT_FACING;
    }
    else if(change_x<0){
      direction=LEFT_FACING;
    }
    else{
      direction=NEUTRAL_FACING;
    }
  }
  void selectCurrentImages(){
    if(direction==RIGHT_FACING){
      currentImages=moveRight;
    }
    else if(direction==LEFT_FACING){
      currentImages=moveLeft;
    }
    else{
      currentImages=standNeutral;
    }
  }
  void advanceToNextImage(){
    index++;
    if(index>=currentImages.length){
      index=0;
    }
    img=currentImages[index];
  }
  
}

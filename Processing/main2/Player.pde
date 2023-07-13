class Player extends AnimatedSprite{
  int lives;
  boolean onPlatform, inPlace;
  PImage[] standLeft;
  PImage[] standRight;
  PImage[] jumpLeft;
  PImage[] jumpRight;
  Player(PImage img, float scale){
    super(img,scale);
    lives=3;
    direction=RIGHT_FACING;
    onPlatform=true;
    inPlace=true;
    standLeft=new PImage[1];
    standLeft[0]=loadImage("data/rani_stand_left.png");
    standRight=new PImage[1];
    standRight[0]=loadImage("data/rani_stand_right.png");
    jumpLeft=new PImage[1];
    jumpLeft[0]=loadImage("data/rani_jump_left.png");
    jumpRight=new PImage[1];
    jumpRight[0]=loadImage("data/rani_jump_right.png");
    moveLeft=new PImage[1];
    moveLeft[0]=loadImage("data/rani_walk_left1.png");
    
    moveRight=new PImage[1];
    moveRight[0]=loadImage("data/rani_walk_right1.png");
    currentImages=standRight;
  }
  @Override
  public void updateAnimation(){
    onPlatform=isOnPlatforms(this,platforms);
    inPlace=change_x==0 && change_y==0;
    super.updateAnimation();
  }
  @Override
  public void selectDirection(){
    if(change_x>0){
      direction=RIGHT_FACING;
    }
    else if(change_x<0){
      direction=LEFT_FACING;
    }
  }
  @Override
  public void selectCurrentImages(){
    if(direction==RIGHT_FACING){
      if(inPlace){
        currentImages=standRight;
      }
      else if(!onPlatform){
        currentImages=jumpRight;
      }
      else{
        currentImages=moveRight;
      }
    }
    if(direction==LEFT_FACING){
      if(inPlace){
        currentImages=standLeft;
      }
      else if(!onPlatform){
        currentImages=jumpLeft;
      }
      else{
        currentImages=moveLeft;
      }
    }
  }
}

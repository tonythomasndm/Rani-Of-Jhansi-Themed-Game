class Enemy extends AnimatedSprite{
  float boundaryLeft, boundaryRight;
  Enemy(PImage img, float scale, float bLeft, float bRight){
    super(img,scale);
    moveLeft=new PImage[3];
    moveLeft[0]=loadImage("data/british_left.png");
    moveLeft[1]=loadImage("data/british_left.png");
    moveLeft[2]=loadImage("data/british_left.png");
    moveRight=new PImage[3];
    moveRight[0]=loadImage("data/british_right.png");
    moveRight[1]=loadImage("data/british_right.png");
    moveRight[2]=loadImage("data/british_right.png");
    currentImages=moveRight;
    direction=RIGHT_FACING;
    boundaryLeft=bLeft;
    boundaryRight=bRight;
    change_x=2*1.5;
  }
  void update(){
    super.update();
    if(getLeft()<=boundaryLeft){
      setLeft(boundaryLeft);
      change_x*=-1;
     }
     else if(getRight()>=boundaryRight){
       setRight(boundaryRight);
       change_x*=-1;
     }
  }
}

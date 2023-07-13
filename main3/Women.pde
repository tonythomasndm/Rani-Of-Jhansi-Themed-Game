class Women extends AnimatedSprite{
  Women(PImage img, float scale){
    super(img,scale);
    standNeutral=new PImage[2];
    standNeutral[0]=loadImage("data/women1.png");
    standNeutral[1]=loadImage("data/women2.png");
    currentImages=standNeutral;
  }
  @Override
  void updateAnimation(){
    frame++;
    if(frame%20==0){
      selectDirection();
      selectCurrentImages();
      advanceToNextImage();
    }
  }
}

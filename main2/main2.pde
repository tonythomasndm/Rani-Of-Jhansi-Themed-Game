final static float MOVE_SPEED=5*1.5;
final static float SPRITE_SCALE=50.0*1.5/900;
final static float SPRITE_SIZE=50*1.5;
final static float GRAVITY= 0.6*1.5;
final static float JUMP_SPEED=14*1.5;

final static int NEUTRAL_FACING=0;
final static int RIGHT_FACING=1;
final static int LEFT_FACING=2;

final static float RIGHT_MARGIN=400*1.5;
final static float LEFT_MARGIN=60*1.5;
final static float VERTICAL_MARGIN=40*1.5;

final static float WIDTH=SPRITE_SIZE*16;
final static float HEIGHT=SPRITE_SIZE*12;
final static float GROUND_LEVEL=HEIGHT-SPRITE_SIZE;
PImage background;
Player p;
PImage grass, ground,crate,red_brick, brown_brick, gold, british, player,men;
ArrayList<Sprite> platforms;
ArrayList<Sprite> coins;
ArrayList<Sprite> enemies;
ArrayList<Sprite> genders;

boolean isGameOver;
int numCoins;
float view_x;
float view_y;
void setup(){
  size(1200,900);
  //p=new Sprite("data/ranitoon.png",0.55,150,450);
  player=loadImage("data/rani_stand_right.png");
  p=new Player(player,0.055*1.5);
  p.setBottom(GROUND_LEVEL);
  p.center_x=100*1.5;
  isGameOver=false;
  imageMode(CENTER);
  background=loadImage("data/background.jpg");
  grass=loadImage("data/grass2.png");
  crate=loadImage("data/crate.png");
  red_brick=loadImage("data/red_brick.png");
  brown_brick=loadImage("data/brown_brick.png");
  gold=loadImage("data/gold1.png");
  british=loadImage("data/british_right.png");
  men=loadImage("data/men_right.png");
  coins=new ArrayList<Sprite>();
  enemies=new ArrayList<Sprite>();
  genders=new ArrayList<Sprite>();
  p.change_x=0;
  p.change_y=0;
  numCoins=0;
  platforms=new ArrayList<Sprite>();
  createPlatforms("data/map.csv");
  view_x=0;
  view_y=0;
}
void draw(){
   image(background,1280/2,720/2,2000,1150);
   //early so it can be relative
   scroll();
   displayAll();
   if(!isGameOver){
   updateAll();}
   //enemy.display();
   
}
void displayAll(){
  p.display();
   //p.update();
   for(Sprite s:platforms)
   {
     s.display();
   }
   for(Sprite c: coins){
     c.display();
   }
   for(Sprite e:enemies)
   {
     e.display();
   }
   for(Sprite g:genders)
   {
     g.display();
   }
   //fill(255,0,0);
   textSize(32);
   text("Durga Dal :"+numCoins,50*1.5+view_x,50*1.5+view_y);
   textSize(32);
   text("Lives :"+p.lives,50*1.5+view_x,100*1.5+view_y);
   if(isGameOver){
     fill(255,255,255);
     text("GAME OVER!", view_x+width/2-100,view_y+height/2);
     if(p.lives==0)
     text("You lose!",view_x+width/2-100,view_y+height/2+50);
     else
     text("You win!",view_x+width/2-100,view_y+height/2+50);
     text("Press ENTER to restart!",view_x+width/2-100,view_y+height/2+100);
   }
}
void updateAll(){
  p.updateAnimation();
   resolvePlatformCollisions(p,platforms);
   for(Sprite c: coins){
     ((AnimatedSprite)c).updateAnimation();
   }
   for(Sprite e:enemies)
   {
     e.update();
     ((AnimatedSprite)e).updateAnimation();
   }
   for(Sprite g:genders)
   {
     g.update();
     ((AnimatedSprite)g).updateAnimation();
   }
   
   collectCoins();
   attackOnArmy();
   checkDeath();
}
void checkDeath(){
  boolean collideEnemy=false;
  boolean collideMen=false;
  for(Sprite e:enemies){
  collideEnemy=collideEnemy || checkCollision(p,e);
  if(collideEnemy) break;
  }
  for(Sprite g:genders){
  collideMen=collideMen || checkCollision(p,g);
  if(collideMen) break;
  }
  boolean fallOffCliff= p.getBottom()>GROUND_LEVEL;
  //if(fallOffCliff){
  //  p.change_y=-JUMP_SPEED;
  //}
  if(collideEnemy ||collideMen|| fallOffCliff){
    p.lives--;
    if(p.lives==0){
    isGameOver=true;}
    else{
    p.center_x=100*1.5;
    p.setBottom(GROUND_LEVEL);}
  }
    
}
void attackOnArmy(){
  ArrayList<Sprite> col_list = checkCollisionList(p, enemies);
  if(col_list.size() > 0 && !isOnPlatforms(p,platforms)){
    for(Sprite enemy: col_list){
       enemies.remove(enemy);
    }
  }
}
void collectCoins(){
   ArrayList<Sprite> col_list = checkCollisionList(p, coins);
   if(col_list.size() > 0){
    for(Sprite coin: col_list){
       coins.remove(coin);
       numCoins++;
    }
  }
  if(coins.size()==0)
  isGameOver=true;
}
void scroll(){
  float right_boundary=view_x+width-RIGHT_MARGIN;
  if(p.getRight()>right_boundary){
    view_x+=p.getRight()-right_boundary;
  }
  float left_boundary=view_x+LEFT_MARGIN;
  if(p.getLeft()<left_boundary){
    view_x-=left_boundary-p.getLeft();
  }
  float bottom_boundary=view_y+height-VERTICAL_MARGIN;
  if(p.getBottom()>bottom_boundary){
    view_y+=p.getBottom()-bottom_boundary;
  }
  float top_boundary=view_y+VERTICAL_MARGIN;
  if(p.getTop()<top_boundary){
    view_y-=top_boundary-p.getTop();
  }
  translate(-view_x,-view_y);
}
boolean isOnPlatforms(Sprite s, ArrayList<Sprite> walls)
{
  s.center_y+=5;
  ArrayList<Sprite> col_list=checkCollisionList(s,walls);
  s.center_y-=5;
  if(col_list.size()>0) return true;
  else return false;
}
void resolvePlatformCollisions(Sprite s, ArrayList<Sprite> walls){
  s.change_y+=GRAVITY;
  //move in y direction and then resolve the collision
  s.center_y+=s.change_y;
  ArrayList<Sprite> col_list=checkCollisionList(s,walls);
  if(col_list.size()>0)
  {
    Sprite collided=col_list.get(0);
    if(s.change_y>0){
      s.setBottom(collided.getTop());
    }
    else if(s.change_y<0){
      s.setTop(collided.getBottom());
    }
    s.change_y=0;
  }
  //move in x direction and then resolve the collision
  s.center_x+=s.change_x;
  col_list=checkCollisionList(s,walls);
  if(col_list.size()>0)
  {
    Sprite collided=col_list.get(0);
    if(s.change_x>0){
      s.setRight(collided.getLeft());
    }
    else if(s.change_x<0){
      s.setLeft(collided.getRight());
    }
    //s.change_y=0;
  }
}
boolean checkCollision(Sprite s1, Sprite s2){
  boolean noXOverlap=s1.getRight()<=s2.getLeft()|| s1.getLeft()>=s2.getRight();
  boolean noYOverlap=s1.getBottom()<=s2.getTop()||s1.getTop()>=s2.getBottom();
  if(noXOverlap ||noYOverlap){
    return false;
  }
  else{
    return true;
  }
}
void createPlatforms(String filename){
  String[] lines=loadStrings(filename);
  for(int row=0;row<lines.length;row++){
    String[] values=split(lines[row],",");
    for(int col=0; col<values.length;col++){
      if(values[col].equals("1")){
        Sprite s=new Sprite(brown_brick,SPRITE_SCALE);
        s.center_x=SPRITE_SIZE/2 + col*SPRITE_SIZE;
        s.center_y=SPRITE_SIZE/2 +row*SPRITE_SIZE;
        platforms.add(s);
      }
      else if(values[col].equals("2")){
        Sprite s=new Sprite(grass,SPRITE_SCALE);
        s.center_x=SPRITE_SIZE/2 + col*SPRITE_SIZE;
        s.center_y=SPRITE_SIZE/2 +row*SPRITE_SIZE;
        platforms.add(s);
      }
      else if(values[col].equals("3")){
        Sprite s=new Sprite(crate,SPRITE_SCALE);
        s.center_x=SPRITE_SIZE/2 + col*SPRITE_SIZE;
        s.center_y=SPRITE_SIZE/2 +row*SPRITE_SIZE;
        platforms.add(s);
      }
      else if(values[col].equals("4")){
        Sprite s=new Sprite(brown_brick,SPRITE_SCALE);
        s.center_x=SPRITE_SIZE/2 + col*SPRITE_SIZE;
        s.center_y=SPRITE_SIZE/2 +row*SPRITE_SIZE;
        platforms.add(s);
      }
      else if(values[col].equals("5")){
        Sprite s=new Sprite(red_brick,SPRITE_SCALE);
        s.center_x=SPRITE_SIZE/2 + col*SPRITE_SIZE;
        s.center_y=SPRITE_SIZE/2 +row*SPRITE_SIZE;
        platforms.add(s);
      }
      else if(values[col].equals("6")){
        Coin c=new Coin(gold,SPRITE_SCALE);
        c.center_x=SPRITE_SIZE/2 + col*SPRITE_SIZE;
        c.center_y=SPRITE_SIZE/2 +row*SPRITE_SIZE;
        coins.add(c);
      }
      else if(values[col].equals("7")){
        float bLeft=col*SPRITE_SIZE;
        float bRight=bLeft+4*SPRITE_SIZE;
        Enemy enemy=new Enemy(british,SPRITE_SCALE,bLeft,bRight);
        enemy.center_x=SPRITE_SIZE/2 + col*SPRITE_SIZE;
        enemy.center_y=SPRITE_SIZE/2 + row*SPRITE_SIZE;
        enemies.add(enemy);
      }
      else if(values[col].equals("8")){
        float bLeft=col*SPRITE_SIZE;
        float bRight=bLeft+1*SPRITE_SIZE;
        Gender gender=new Gender(men,SPRITE_SCALE,bLeft,bRight);
        gender.center_x=SPRITE_SIZE/2 + col*SPRITE_SIZE;
        gender.center_y=SPRITE_SIZE/2 + row*SPRITE_SIZE;
        genders.add(gender);
      }
    }
  }
}
ArrayList<Sprite> checkCollisionList(Sprite s, ArrayList<Sprite> list){
  ArrayList<Sprite> collision_list=new ArrayList<Sprite>();
  for(Sprite p: list){
    if(checkCollision(s,p)){
      collision_list.add(p);}
  }
  return collision_list; 
}

//whwnever a key is prssed
void keyPressed(){
  if(keyCode==RIGHT){
    p.change_x=MOVE_SPEED;}
  else if(keyCode==LEFT){
    p.change_x=-MOVE_SPEED;}
  //else if(keyCode==UP){
  //  p.change_y=-MOVE_SPEED;}
  //else if(keyCode==DOWN){
  //  p.change_y=MOVE_SPEED;}
  else if(key==' ' && isOnPlatforms(p,platforms)){
    p.change_y=-JUMP_SPEED;
  }
  else if(isGameOver && keyCode==DOWN)
  setup();
}
//whenever a key is released
void keyReleased(){
   if(keyCode==RIGHT){
    p.change_x=0;
  }
  else if(keyCode==LEFT){
    p.change_x=0;
  }
  else if(keyCode==UP){
    p.change_y=0;
  }
  else if(keyCode==DOWN){
    p.change_y=0;
  }
}

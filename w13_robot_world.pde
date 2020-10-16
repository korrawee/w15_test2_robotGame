World world = new World();


void setup()
{
  size(500, 500);
  strokeWeight(2);
  world.load();
  world.robot.ip.load(); 
}

void draw()
{
  background(255);
  world.draw_map();
  
  if(keyPressed){
      if(mouseX > width/2-20 && mouseX < width/2 + 20){
          if(mouseY > height/2 - 20 && mouseY < height/2 + 20){
            mouseClicked();
          }// y-axis condition
       }// x-axis condition
    if(key == 't'){
      rectMode(CENTER);
       rect(width/2 - 20,height/2 - 20, width/2 + 20, height/2 + 20); 
       fill(255,0,0);
       text("SAVE",width/2 - 100,height/2 - 100);
       noLoop();
    }// button t condition
  }//keyPressed
  
}//draw function

void mouseClicked(){
  world.save(); 
  exit();  
}

class World
{
  int blockSize =50 ;
  int state = 1;
  String[][] barrierPosition;
  String[][] targetPosition;
  String[][] robotPosition;
  int[][] position = new int[500/blockSize][500/blockSize];
  Robot robot = new Robot(blockSize);
  
  World()
  {
  }
  void save(){
    String[] tmpLines = new String[height/blockSize]; 
    for(int i = 0; i < height/blockSize; i++)
    {
     for(int j = 0; j < width/blockSize; j++)
     {
      if(position[i][j] == 3)
      {
        position[i][j] = 0;
      }
     }
    }
    position[robot.get_Row()][robot.get_Column()] = 3;
    for(int i=0; i < height/blockSize; i++){
      tmpLines[i] = "";
      
      for(int j=0; j < width/blockSize; j++){
        if(j != 0){
          tmpLines[i] += ",";  
        }//condition
        tmpLines[i] += position[i][j];
      }// j loop
    }// i loop
    saveStrings("saved.txt", tmpLines);
  }// save method
  
  void load(){
    File z = new File(sketchPath("saved.txt"));
    
    if(z.exists()){
      String[] info = loadStrings("saved.txt");
      String[] tmpLine = {};
      
      for(int i=0; i < info.length; i++)
      {
        tmpLine = split(info[i], ",");
        
        for(int j=0; j < info.length; j++)
        {
          position[i][j] = int(tmpLine[j]);  
        }// j loop
      }// i loop
    }else{
       this.generate();
    }// check file exixts condition
  }// load method
  
  void generate(){
    int tmpIndex = int(random(1,position.length));
    int tmpIndex2 = int(random(1,position.length));
    int tmp;
    position[0][0] = 3; //gen. robot
    position[tmpIndex][tmpIndex2] = 2; // gen. target
    
    for(int i=0; i < position.length; i+=1){
      
      for(int j=0; j < position.length; j+=2)
      {
        if(position[i][j] != 2 && position[i][j] != 3)
        {
          tmp = int(random(2));
          if(tmp == 1)
          {
            position[i][j] = 1  ;
          }
        }
      }// j loop
    }// i loop
  }// generate method
  
  void draw_map()
  {
    
    for(int i = 0; i < position.length; i++){
      line(i* 50, 0, i*50, height);

      for(int j = 0; j < position.length; j++){  
        line(0, j*50,width, j*50);

        if(position[i][j] == 1 ){ // if barrier's position draw target
          this.draw_barrier(i, j); // draw_barrier(row, column)
          
        }if(position[i][j] == 2 ){ // if target's position draw barrier
          this.draw_target(i, j); // convert index into row, column
          
        }if(position[i][j] == 3){//  if robot's position draw robot
          robot.display(i,j);
        }
      }// j loop
    }// i loop

    robot.isBlocked();
    robot.move();
    robot.isOnTarget();
    robot.turnLeft();
    robot.turnRight();
  }//draw_map method
  
  void draw_target(int tmpRow, int tmpCol)
  {
    if(state == 1 )
    {
      int x = (tmpCol * blockSize); // find axis values from Row and column
      int y = (tmpRow * blockSize) ;
      int dLeftX, dLeftY;
      int dRightX, dRightY;
      int uLeftX, uLeftY;
      int uRightX, uRightY;
      
      stroke(100, 250, 100);
      strokeWeight(random(0,1) * 5); // change block outline's color
      line(x, y , x + blockSize, y ); // up
      line(x, y + blockSize, x + blockSize, y + blockSize); //down
      line(x, y , x, y + blockSize); //left
      line(x + blockSize , y , x + blockSize, y + blockSize); // right
      
      for(int i = 0; i < blockSize/4; i+= 2){ // draw each three corner
        dLeftX = x;
        dLeftY = y + blockSize;
        dRightX =dLeftX + blockSize;
        dRightY = y + blockSize;
        uLeftX = x;
        uLeftY = y ;
        uRightX = dLeftX + blockSize;
        uRightY = uLeftY;
        line(dLeftX + i, dLeftY, dLeftX, dLeftY - i);
        line( dRightX - i, dRightY, dRightX, dRightY - i);
        line(uLeftX + i, uLeftY, uLeftX, uLeftY + i);
        line(uRightX - i, uRightY, uRightX, uRightY + i);
      }
      stroke(0);
      strokeWeight(2);
      
    }// state condition
  }//draw_target method

  void draw_barrier(int tmpRow, int tmpCol)
  {
    int x = (tmpCol ) * blockSize;
    int y = (tmpRow ) * blockSize;
    fill(#F4A460);
    rect( x, y, blockSize, blockSize);
    stroke(0);
  }//draw_barrier method
  
}

class Robot
{
  int blockSize;
  int row = 0 ;
  int column = 0 ;
  int i ;
  int j ;
  String side = "UP" ;
  InputProcessor ip = new InputProcessor();
  
  Robot(int tmpBlockSize){
    blockSize = tmpBlockSize; 
  }
  void move()
  {
   if (keyPressed == true )
   {
     if(key == ip.up())
     {
       if(side == "UP")
       {
        row -= blockSize; 
        keyPressed = false ;
       }
       if(side == "DOWN")
       {
        row +=  blockSize; 
        keyPressed = false ; 
       }
       if(side == "LEFT")
       {
        column -= blockSize; 
        keyPressed = false ;
       }
       if(side == "RIGHT")
       {
        column +=  blockSize; 
        keyPressed = false ;
       }
     }// button condition
   }// keyPressed condition
  }// move method
  
  void display(int tmpx , int tmpy)
  {
   if(side == "UP")
   {
     line(tmpy*50 + column ,(tmpx*50)+50 + row ,(tmpy*50)+25 + column ,tmpx*50 + row);
     line((tmpy*50)+50 + column ,(tmpx*50)+50 + row ,(tmpy*50)+25 + column ,tmpx*50 + row);
   }
   if(side == "DOWN")
   {
    line(tmpy*50 + column ,tmpx*50 + row ,(tmpy*50)+25 + column ,(tmpx*50)+50 + row);
    line((tmpy*50)+50 + column ,tmpx*50 + row ,(tmpy*50)+25 + column ,(tmpx*50)+50 + row);
   }
   if(side == "LEFT")
   {
    line((tmpy*50)+50 + column ,tmpx*50 + row ,tmpy*50 + column ,(tmpx*50)+25 + row);
    line((tmpy*50)+50 + column ,(tmpx*50)+50 + row ,tmpy*50 + column ,(tmpx*50)+25 + row);
   }
   if(side == "RIGHT")
   {
    line(tmpy*50 + column ,tmpx*50 + row ,(tmpy*50)+50 + column ,(tmpx*50)+25 + row);
    line(tmpy*50 + column ,(tmpx*50)+50 + row ,(tmpy*50)+50 + column ,(tmpx*50)+25 + row);
   }
    i = (tmpx*50 + row) ;
    j = (tmpy*50 + column) ;
  }// display method
  
  void turnLeft()
  {
   if(keyPressed == true)
   {
    if(key == ip.left())
    {
     if(side == "UP")
     {
      side = "LEFT"  ;
      keyPressed = false ;
     }
     else if(side == "LEFT")
     {
      side = "DOWN"  ;
      keyPressed = false ;
     }
     else if(side == "DOWN")
     {
      side = "RIGHT"  ;
      keyPressed = false ;
     }
     else if(side == "RIGHT")
     {
      side = "UP"  ;
      keyPressed = false ;
     }
    }// button condition
   }// keyPressed comdition
  }// turnLeft method
  
  void turnRight()
  {
   if(keyPressed == true)
   {
    if(key == ip.right())
    {
     if(side == "UP")
     {
      side = "RIGHT"  ;
      keyPressed = false ;
     }
     else if(side == "RIGHT")
     {
      side = "DOWN"  ;
      keyPressed = false ;
     }
     else if(side == "DOWN")
     {
      side = "LEFT"  ;
      keyPressed = false ;
     }
     else if(side == "LEFT")
     {
      side = "UP" ;
      keyPressed = false ;
     }
    }// button condition
   }// keyPressed condition
  }// turnRight method
  
  void isBlocked()
  {
   if (keyPressed == true )
   {
     if(key == ip.up())
     {
       if(side == "UP")
       {
         if(this.i <= 0)
         {
           keyPressed = false ;
         }
         else if(world.position[ ((this.i - world.blockSize)/world.blockSize)  ][this.j/world.blockSize] == 1)
         {
           keyPressed = false ;
         }
       }
       if(side == "DOWN")
       {
         if(this.i + world.blockSize >= height)
         {
           keyPressed = false ;
         }
         else if(world.position[ ((this.i + world.blockSize)/world.blockSize)  ][this.j/world.blockSize] == 1)
         {
           keyPressed = false ;
         }
       }
       if(side == "LEFT")
       {
         if(this.j <= 0)
         {
           keyPressed = false ;
         }
         else if(world.position[  (this.i/world.blockSize)   ][( this.j - world.blockSize)/world.blockSize] == 1)
         {
           keyPressed = false ;
         }
       }
       if(side == "RIGHT")
       {
         if(this.j + world.blockSize >= width)
         {
           keyPressed = false ;
         }
         else if(world.position[ (this.i/world.blockSize)  ][( this.j + world.blockSize)/world.blockSize] == 1)
         {
           keyPressed = false ;
         }
       }
     }// button condition
   }// keyPressed condition
  }// isBlocked method
  
  void isOnTarget()
  {
   if(world.position[this.i/world.blockSize][this.j/world.blockSize] == 2)
   {
    world.state = 0 ;
    background(#FFFFFF);  
    textSize(40);
    text("You Win", 160, 250);
   }
  }
     // button condition
   // keyPressed condition
  // isOnTarget method
  
  int get_Row(){
    return i/blockSize;  
  }
  
  int get_Column(){
    return j/blockSize;  
  }
}

class InputProcessor
{ 
  char up ;
  char down ;
  char left ;
  char right ;
  
  void load(){
    File f = new File(sketchPath("control.txt"));
    String[] btn;
    
    if(f.exists()){
      String[] lines = loadStrings("control.txt");
      btn = lines[0].split(",");
      up = btn[0].charAt(0);
      down = btn[1].charAt(0);
      left = btn[2].charAt(0);
      right = btn[3].charAt(0);
    }else{
      this.createFile();
      this.load();
    }// file exist condition
  }// load method
  
  void createFile(){
    String[] defaultBtn = {"w,s,a,d"};
    saveStrings("control.txt", defaultBtn);  
  }
  
  char up()
  {
    return up ;
  }
  
  char down()
  {
    return down ;
  }
  
  char left()
  {
    return left ;
  }
  
  char right()
  {
    return right ;
  }
}

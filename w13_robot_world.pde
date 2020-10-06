World world = new World();
InputProcessor ip = new InputProcessor();

void setup()
{
  size(500, 500);
  strokeWeight(2);
  ip.load(); 
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
  
  World(){
   this.load();
  }
  void save(){
    String[] tmpLines = new String[height/blockSize]; 
    position[robot.getRow()][robot.getColumn()] = 3;
    
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
    File f = new File(sketchPath("saved.txt"));
    
    if(f.exists()){
      String[] info = loadStrings("saved.txt");
      String[] tmpLine = {};
      
      for(int i=0; i < info.length; i++){
        tmpLine = split(info[i], ",");
        
        for(int j=0; j < info.length; j++){
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
    
    for(int i=1; i < position.length; i++){
      
      for(int j=1; j < position.length; j++){
        tmp = int(random(2));
        if(tmp == 1){
          position[i][j] = 1  ;
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

        if(position[i][j] == 1){ // if target's position draw target
          this.draw_barrier(3,2); // draw_barrier(row, column)
          
        }else if(position[i][j] == 2){ // if barrier's position draw barrier
          this.draw_target(i+1, j+1); // convert index into row, column
          
        }else if(position[i][j] == 3){//  if robot's position draw robot
          robot.display();
        }
      }// j loop
    }// i loop

    robot.move(); 
    robot.isBlocked();
    robot.isOnTarget();
    robot.move();
    robot.turnLeft();
    robot.turnRight();
  }//draw_map method
  
  void draw_target(int tmpRow, int tmpCol)
  {
    position[tmpRow-1][tmpCol-1] = 2;
    if(state == 1 )
    {
      int x = (tmpCol-1) * (blockSize); // find axis values from Row and column
      int y = (tmpRow * blockSize) ;
      int dLeftX, dLeftY;
      int dRightX, dRightY;
      int uLeftX, uLeftY;
      int uRightX, uRightY;
      
      stroke(100, 250, 100);
      strokeWeight(random(0,1) * 5);
      line(x, y - blockSize, x + blockSize, y - blockSize); // change block outline's color
      line(x, y, x + blockSize, y);
      line(x, y - blockSize, x, y);
      line(x + blockSize, y - blockSize, x + blockSize, y);
      
      for(int i = 0; i < blockSize/4; i+= 2){ // draw each three corner
        dLeftX = x;
        dLeftY = y;
        dRightX =dLeftX + blockSize;
        dRightY = y;
        uLeftX = x;
        uLeftY = y - blockSize;
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
    int x = (tmpCol - 1) * blockSize;
    int y = (tmpRow - 1) * blockSize;
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
  String side = "UP" ;
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
  
  void display()
  {
   if(side == "UP")
   {
     line(0 + column ,50 + row ,25 + column ,0 + row);
     line(50 + column ,50 + row ,25 + column ,0 + row);
   }
   if(side == "DOWN")
   {
    line(0 + column ,0 + row ,25 + column ,50 + row);
    line(50 + column ,0 + row ,25 + column ,50 + row);
   }
   if(side == "LEFT")
   {
    line(50 + column ,0 + row ,0 + column ,25 + row);
    line(50 + column ,50 + row ,0 + column ,25 + row);
   }
   if(side == "RIGHT")
   {
    line(0 + column ,0 + row ,50 + column ,25 + row);
    line(0 + column ,50 + row ,50 + column ,25 + row);
   }
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
         if(row <= 0)
         {
           keyPressed = false ;
         }
         else if(world.position[ ((row - world.blockSize)/world.blockSize)  ][column/world.blockSize] == 1)
         {
           keyPressed = false ;
         }
       }
       if(side == "DOWN")
       {
         if(row + world.blockSize >= height)
         {
           keyPressed = false ;
         }
         else if(world.position[ ((row + world.blockSize)/world.blockSize)  ][column/world.blockSize] == 1)
         {
           keyPressed = false ;
         }
       }
       if(side == "LEFT")
       {
         if(column <= 0)
         {
           keyPressed = false ;
         }
         else if(world.position[  (row/world.blockSize)   ][( column - world.blockSize)/world.blockSize] == 1)
         {
           keyPressed = false ;
         }
       }
       if(side == "RIGHT")
       {
         if(column + world.blockSize >= width)
         {
           keyPressed = false ;
         }
         else if(world.position[ (row/world.blockSize)  ][( column + world.blockSize)/world.blockSize] == 1)
         {
           keyPressed = false ;
         }
       }
     }// button condition
   }// keyPressed condition
  }// isBlocked method
  
  void isOnTarget()
  {
   if (keyPressed == true )
   {
     if(key == ip.up())
     {
       if(side == "UP")
       {
         if(world.position[ ((row - world.blockSize)/world.blockSize)  ][column/world.blockSize] == 2)
         {
           row -= 50; 
           world.state = 0 ;
           keyPressed = false ;
         }
       }
       if(side == "DOWN")
       {
         if(world.position[ ((row + world.blockSize)/world.blockSize)  ][column/world.blockSize] == 2)
         {
           row += 50;
           world.state = 0 ;
           keyPressed = false ;
         }
       }
       if(side == "LEFT")
       {
         if(world.position[ (row/world.blockSize)   ][( column - world.blockSize)/world.blockSize] == 2)
         {
           column -= 50;
           world.state = 0 ;
           keyPressed = false ;
         }
       }
       if(side == "RIGHT")
       {
         if(world.position[ (row/world.blockSize)  ][( column + world.blockSize)/world.blockSize] == 2)
         {
           column += 50 ;
           world.state = 0 ;
           keyPressed = false ;
         }
       }
     }// button condition
   }// keyPressed condition
  }// isOnTarget method
  
  int getRow(){
    return row/blockSize;  
  }
  
  int getColumn(){
    return column/blockSize;  
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

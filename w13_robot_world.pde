World world = new World();
InputProcessor ip = new InputProcessor();
void setup()
{
  size(500, 500);
  strokeWeight(2);
}

void draw()
{
  background(255);
  world.draw_map();
  ip.setUp();
  ip.setDown();
  ip.setLeft();
  ip.setRight();
  if(keyPressed){
      if(mouseX > width/2-20 && mouseX < width/2 + 20){
          if(mouseY > height/2 - 20 && mouseY < height/2 + 20){
            mouseClicked();
          }
       }
    if(key == 't'){
      rectMode(CENTER);
       rect(width/2 - 20,height/2 - 20, width/2 + 20, height/2 + 20); 
       fill(255,0,0);
       text("SAVE",width/2 - 100,height/2 - 100);
       noLoop();
       
    }
  }
}

void mouseClicked(){
  world.save(); 
  exit();  
}
class World
{
  Robot robot = new Robot();
  int blockSize =50 ;
  String[][] position = new String[500/blockSize][500/blockSize];
  int state = 1;
  
  World()
  {
  }
  
  void draw_map()
  {
    for(int i = 0 ; i < (width/blockSize); i++)
    {
      for(int j = 0 ; j < (height/blockSize); j++)
      {
        line(i*50,0,i*50,height);
        line(0,j*50,width,j*50);
        position[i][j] = "0";
      }
    }
    robot.display();
    robot.move(); 
    robot.isBlocked();
    robot.isOnTarget();
    robot.move();
    robot.turnLeft();
    robot.turnRight();
    this.draw_barrier();
    this.draw_target(5,2);
  }
  
  void draw_target(int tmpRow, int tmpCol)
  {
    if(state == 1 )
    {
      int x = (tmpCol-1) * (blockSize); // find axis values from Row and column
      int y = (tmpRow * blockSize) ;
      int dLeftX, dLeftY;
      int dRightX, dRightY;
      int uLeftX, uLeftY;
      int uRightX, uRightY;
      
      stroke(190, 251, 19);
      strokeWeight(random(1,2) * 2);
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
    }
    
  }
  
  void draw_barrier()
  {
    for(int i = 0 ;i < 1 ; i++)
    {
      for(int j = 2 ;j < 10 ;j++)
      {
       fill(#F4A460);
       rect(j*50,i*50,blockSize,blockSize);
       position[i][j] = "1";
      }
    }
    
    for(int i = 2 ;i < 10 ; i++)
    {
      for(int j = 0 ;j < 1 ;j++)
      {
       fill(#F4A460);
       rect(j*50,i*50,blockSize,blockSize);
       position[i][j] = "1";
      }
    }
    
    for(int i = 3 ;i < 5 ; i++)
    {
      for(int j = 3 ;j < 10 ;j+=2)
      {
       fill(#F4A460);
       rect(j*50,i*50,blockSize,blockSize);
       position[i][j] = "1";
      }
    }
    
    for(int i = 3 ;i < 10 ; i+=2)
    {
      for(int j = 3 ;j < 5 ;j++)
      {
       fill(#F4A460);
       rect(j*50,i*50,blockSize,blockSize);
       position[i][j] = "1";
      }
    }
  }
  
  void save(){
    String[] tmpStr = new String[height/blockSize + 2]; 
    
    for(int i=0; i < height/blockSize; i++){
      tmpStr[i] = "";
      for(int j=0; j < width/blockSize; j++){
        
        if(j != 0){
          tmpStr[i] += ",";  
        }
        tmpStr[i] += position[i][j];
      }
    }
    tmpStr[height/blockSize] = str(robot.getRow());
    tmpStr[height/blockSize + 1] = str(robot.getColumn());
    saveStrings("saved.txt", tmpStr);
  }
}

class Robot
{
  int row = 0 ;
  int column = 0 ;
  String side = "UP" ;
  
  void move()
  {
   if (keyPressed == true )
   {
     if(keyCode == ip.up())
     {
       if(side == "UP")
       {
        row -= 50; 
        keyPressed = false ;
       }
       if(side == "DOWN")
       {
        row +=  50; 
        keyPressed = false ; 
       }
       if(side == "LEFT")
       {
        column -= 50; 
        keyPressed = false ;
       }
       if(side == "RIGHT")
       {
        column +=  50; 
        keyPressed = false ;
       }
     }
   }
  }
  
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
  }
  void turnLeft()
  {
   if(keyPressed == true)
   {
    if(keyCode == ip.left())
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
    }
   }
  }
  
  void turnRight()
  {
   if(keyPressed == true)
   {
    if(keyCode == ip.right())
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
    }
   }
  }
  
  void isBlocked()
  {
   if (keyPressed == true )
   {
     if(keyCode == ip.up())
     {
       if(side == "UP")
       {
         if(row <= 0)
         {
           keyPressed = false ;
         }
         else if(match(world.position[ ((row - world.blockSize)/world.blockSize)  ][column/world.blockSize], "1") != null)
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
         else if(match(world.position[ ((row + world.blockSize)/world.blockSize)  ][column/world.blockSize], "1") != null)
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
         else if(match(world.position[  (row/world.blockSize)   ][( column - world.blockSize)/world.blockSize], "1") != null)
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
         else if(match(world.position[ (row/world.blockSize)  ][( column + world.blockSize)/world.blockSize], "1") != null)
         {
           keyPressed = false ;
         }
       }
     }
   }
  }
  
  void isOnTarget()
  {
   if (keyPressed == true )
   {
     if(keyCode == ip.up())
     {
       if(side == "UP")
       {
         if(match(world.position[ ((row - world.blockSize)/world.blockSize)  ][column/world.blockSize], "2") != null)
         {
           row -= 50; 
           world.state = 0 ;
           keyPressed = false ;
         }
       }
       if(side == "DOWN")
       {
         if(match(world.position[ ((row + world.blockSize)/world.blockSize)  ][column/world.blockSize], "2") != null)
         {
           row += 50;
           world.state = 0 ;
           keyPressed = false ;
         }
       }
       if(side == "LEFT")
       {
         if(match(world.position[ (row/world.blockSize)   ][( column - world.blockSize)/world.blockSize], "2") != null)
         {
           column -= 50;
           world.state = 0 ;
           keyPressed = false ;
         }
       }
       if(side == "RIGHT")
       {
         if(match(world.position[ (row/world.blockSize)  ][( column + world.blockSize)/world.blockSize], "2") != null)
         {
           column += 50 ;
           world.state = 0 ;
           keyPressed = false ;
         }
       }
     }
   }
  }
  
  int getRow(){
    return row;  
  }
  
  int getColumn(){
    return column;  
  }
}

class InputProcessor
{ 
  char up ;
  char down ;
  char left ;
  char right ;
  
  void setUp()
  {
    up = UP ;
  }
  
  void setDown()
  {
    down = DOWN ;
  }
  
  void setLeft()
  {
    left = LEFT ;
  }
  
  void setRight()
  {
    right = RIGHT ;
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

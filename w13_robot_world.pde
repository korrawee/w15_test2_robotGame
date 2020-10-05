World world = new World();
Robot robot = new Robot();
InputProcessor ip = new InputProcessor();
void setup()
{
  size(500,500);
}

void draw()
{
  background(255);
  world.draw_map();
  world.draw_target();
  world.draw_barrier();
  robot.display();
  robot.isBlocked();
  robot.isOnTarget();
  robot.move();
  robot.turnLeft();
  robot.turnRight();
  ip.setUp();
  ip.setDown();
  ip.setLeft();
  ip.setRight();
}

void polygon(float x, float y, float radius, int npoints) 
{
  float angle = TWO_PI / npoints;
  beginShape();
  for (float a = 0; a < TWO_PI; a += angle) 
  {
    float sx = x + cos(a) * radius;
    float sy = y + sin(a) * radius;
    vertex(sx, sy);
  }
  endShape(CLOSE);
}

class World
{
  int blockSize =50 ;
  int[][] position = new int[500/blockSize][500/blockSize];
  int state = 1;
  
  World()
  {
  }
  
  void draw_map()
  {
    for(int i = 0 ; i < width/blockSize ; i++)
    {
      for(int j = 0 ; j < height/blockSize ; j++)
      {
        line(i*50,0,i*50,height);
        line(0,j*50,width,j*50);
        position[i][j] = 0;
      }
    }
  }
  
  void draw_target()
  {
    if(state == 1 )
    {
      fill(#FA8072);
      polygon(475,475,20,8);
      position[475/world.blockSize][475/world.blockSize] = 2;
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
       position[i][j] = 1;
      }
    }
    
    for(int i = 2 ;i < 10 ; i++)
    {
      for(int j = 0 ;j < 1 ;j++)
      {
       fill(#F4A460);
       rect(j*50,i*50,blockSize,blockSize);
       position[i][j] = 1;
      }
    }
    
    for(int i = 3 ;i < 5 ; i++)
    {
      for(int j = 3 ;j < 10 ;j+=2)
      {
       fill(#F4A460);
       rect(j*50,i*50,blockSize,blockSize);
       position[i][j] = 1;
      }
    }
    
    for(int i = 3 ;i < 10 ; i+=2)
    {
      for(int j = 3 ;j < 5 ;j++)
      {
       fill(#F4A460);
       rect(j*50,i*50,blockSize,blockSize);
       position[i][j] = 1;
      }
    }
  }
}

class Robot
{
  int row = 0 ;
  int column = 0 ;
  String darn = "UP" ;
  
  void move()
  {
   if (keyPressed == true )
   {
     if(keyCode == ip.up())
     {
       if(darn == "UP")
       {
        row -= 50; 
        keyPressed = false ;
       }
       if(darn == "DOWN")
       {
        row +=  50; 
        keyPressed = false ; 
       }
       if(darn == "LEFT")
       {
        column -= 50; 
        keyPressed = false ;
       }
       if(darn == "RIGHT")
       {
        column +=  50; 
        keyPressed = false ;
       }
     }
   }
  }
  
  void display()
  {
   if(darn == "UP")
   {
     line(0 + column ,50 + row ,25 + column ,0 + row);
     line(50 + column ,50 + row ,25 + column ,0 + row);
   }
   if(darn == "DOWN")
   {
    line(0 + column ,0 + row ,25 + column ,50 + row);
    line(50 + column ,0 + row ,25 + column ,50 + row);
   }
   if(darn == "LEFT")
   {
    line(50 + column ,0 + row ,0 + column ,25 + row);
    line(50 + column ,50 + row ,0 + column ,25 + row);
   }
   if(darn == "RIGHT")
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
     if(darn == "UP")
     {
      darn = "LEFT"  ;
      keyPressed = false ;
     }
     else if(darn == "LEFT")
     {
      darn = "DOWN"  ;
      keyPressed = false ;
     }
     else if(darn == "DOWN")
     {
      darn = "RIGHT"  ;
      keyPressed = false ;
     }
     else if(darn == "RIGHT")
     {
      darn = "UP"  ;
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
     if(darn == "UP")
     {
      darn = "RIGHT"  ;
      keyPressed = false ;
     }
     else if(darn == "RIGHT")
     {
      darn = "DOWN"  ;
      keyPressed = false ;
     }
     else if(darn == "DOWN")
     {
      darn = "LEFT"  ;
      keyPressed = false ;
     }
     else if(darn == "LEFT")
     {
      darn = "UP" ;
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
       if(darn == "UP")
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
       if(darn == "DOWN")
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
       if(darn == "LEFT")
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
       if(darn == "RIGHT")
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
     }
   }
  }
  
  void isOnTarget()
  {
   if (keyPressed == true )
   {
     if(keyCode == ip.up())
     {
       if(darn == "UP")
       {
         if(world.position[ ((row - world.blockSize)/world.blockSize)  ][column/world.blockSize] == 2)
         {
           row -= 50; 
           world.state = 0 ;
           keyPressed = false ;
         }
       }
       if(darn == "DOWN")
       {
         if(world.position[ ((row + world.blockSize)/world.blockSize)  ][column/world.blockSize] == 2)
         {
           row += 50;
           world.state = 0 ;
           keyPressed = false ;
         }
       }
       if(darn == "LEFT")
       {
         if(world.position[ (row/world.blockSize)   ][( column - world.blockSize)/world.blockSize] == 2)
         {
           column -= 50;
           world.state = 0 ;
           keyPressed = false ;
         }
       }
       if(darn == "RIGHT")
       {
         if(world.position[ (row/world.blockSize)  ][( column + world.blockSize)/world.blockSize] == 2)
         {
           column += 50 ;
           world.state = 0 ;
           keyPressed = false ;
         }
       }
     }
   }
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

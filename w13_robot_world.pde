World world = new World();
Robot robot = new Robot();

void setup()
{
  size(900,900);
}

void draw()
{
  background(#A9A9A9);
  world.draw_map();
  world.draw_target();
  robot.display();
  robot.move(); 
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
  int row = 900/blockSize ;
  int column = 900/blockSize ;
  int[][] position = new int[row][column];
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
      polygon(325,325,20,8);
    }
  }
  
  void draw_barrier()
  {
  }
  
  int aRow()
  {
    return row;
  }
  
  int aColumn()
  {
    return column;
  }
}
class Robot
{
  int row = 0 ;
  int column = 0 ;
  
  void move()
  {
   if (keyPressed)
   {
     if(keyCode == UP)
     {
       column -=50; 
     }
     if(keyCode == DOWN)
     {
      column +=  50; 
     }
     if(keyCode == LEFT)
     {
       row -= 50; 
     }
     if(keyCode == RIGHT)
     {
      row +=  50; 
     }
     if(row - 25 < 0)
     {
       row = 0 ;  
     }
     if(row + 25 > width)
     {
       row = 850 ;
     }
     if(column - 10 < 0)
     {
       column = 0;
     }
     if (column + 40 > height)
     {
      column = 850 ;
     }
   }
  }
  
  void display()
  {
   fill(#FFD700);
    if(key == CODED)
    {
     if(keyCode == UP)
     {
      triangle(25 + row,10 + column,5 + row,40 + column,45 + row,40 + column);
     }
     if(keyCode == DOWN)
     {
      triangle(25 + row,40 + column,5 + row,10 + column,45 + row,10 + column);
     }
     if(keyCode == LEFT)
     {
      triangle(10 + row,25 + column,40 + row,5 + column,40 + row,45 + column);
     }
     if(keyCode == RIGHT)
     {
      triangle(40 + row,25 + column,10 + row,5 + column,10 + row,45 + column);
     }
    }
   }
}  

World world = new World();

void setup()
{
  size(900,900);
}

void draw()
{
  background(#A9A9A9);
  world.draw_map();
}

class World
{
  int blockSize =50 ;
  int row = 900/blockSize ;
  int column = 900/blockSize ;
  int[][] position = new int[row][column];
  
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
  int row  ;
  int column ;
  
  void move()
  {
  }
  
  void display()
  {
  }
}  

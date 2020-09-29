void setup(){
  size(300,300);
}
void draw(){
}


class World{
  float blockSize;
  int[][] position = {{   },{  }};
  
  World(){
  }
  void draw_map(){
  }
  
}
class Robot{
  float column;
  float row;
  
  void move(){
  }
  void display(){
  }
  void rotate(){
  }
}
class Target{
  float row;
  float column;
  float state;
  
  void display(){
  }
}
class Barrier{
  float row;
  float column;
  
  void display(){
  }
}

void setup(){
  size(300,300);
}
void draw(){
}


class World{                      ////Create a world of robot
  float blockSize;
  int[][] position = {{   },{  }};
  
  World(){
  }
  void draw_map(){
  }
  
}
class Robot{             /////Create Robot
  float column;
  float row;
  
  void move(){
  }
  void display(){
  }
  void rotate(){
  }
}
class Target{          /////Create a walking goal of the robot.
  float row;
  float column;
  float state;
  
  void display(){
  }
}
class Barrier{      /////Create a barrier for the robot
  float row;
  float column;
  
  void display(){
  }
}

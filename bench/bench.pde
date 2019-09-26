int ballCount = 5;
Ball[] ball = new Ball[ballCount];
void setup(){
  size(800, 800);
  frameRate(60);
  for(int i = 0; i < ballCount; i++){
    ball[i] = new Ball((int)random(5,35));
    ball[i].colors[0] = (int)random(0, 255);
    ball[i].colors[1] = (int)random(0, 255);
    ball[i].colors[2] = (int)random(0, 255);
    ball[i].posx = random(50, width - 50);
    ball[i].posy = random(50, height - 50);
  }
}
void draw(){
  background(33, 33, 33);
  for(int i = 0; i < ballCount; i++){
    ball[i].looped = false;
    for(int j = 0; j < ballCount; j++){
      if(i == j){
        continue;
      }
      double distance = Math.sqrt(Math.pow(ball[i].posx - ball[j].posx, 2) + Math.pow(ball[i].posy - ball[j].posy, 2));
      
      if(distance <= (ball[i].radius + ball[j].radius)){
        float phi = (float)Math.atan((ball[i].posy - ball[j].posy) / (ball[j].posx - ball[i].posx));
        ball[i].velocityX = (float)(
          (((ball[i].mag * Math.cos(ball[i].theta - phi) * (ball[i].mass - ball[j].mass) + 2 * ball[j].mass * ball[j].mag * Math.cos(ball[j].theta - phi)) / (ball[i].mass + ball[j].mass)) * Math.cos(phi)) + ball[i].mag * Math.sin(ball[i].theta - phi) * Math.cos(phi + (Math.PI / 2))
        );
        ball[i].velocityY = (float)(
          (((ball[i].mag * Math.cos(ball[i].theta - phi) * (ball[i].mass - ball[j].mass) + 2 * ball[i].mass * ball[j].mag * Math.cos(ball[j].theta - phi)) / (ball[i].mass + ball[j].mass)) * Math.sin(phi)) + ball[i].mag * Math.sin(ball[i].theta - phi) * Math.sin(phi + (Math.PI / 2))
        );
        
        ball[j].velocityX = (float)(
          (((ball[j].mag * Math.cos(ball[j].theta - phi) * (ball[j].mass - ball[j].mass) + 2 * ball[i].mass * ball[i].mag * Math.cos(ball[i].theta - phi)) / (ball[j].mass + ball[i].mass)) * Math.cos(phi)) + ball[j].mag * Math.sin(ball[j].theta - phi) * Math.cos(phi + (Math.PI / 2))
        );
        ball[j].velocityY = (float)(
          (((ball[j].mag * Math.cos(ball[j].theta - phi) * (ball[j].mass - ball[j].mass) + 2 * ball[i].mass * ball[i].mag * Math.cos(ball[i].theta - phi)) / (ball[j].mass + ball[i].mass)) * Math.sin(phi)) + ball[j].mag * Math.sin(ball[j].theta - phi) * Math.sin(phi + (Math.PI / 2))
        );
        if(ball[i].mag > ball[j].mag){
          ball[j].loop();
        }else{
          ball[i].loop();
        }
        ball[i].looped = true;
      }
    }
    if(!ball[i].looped){
      ball[i].loop();
      ball[i].looped = true;
    }
    ball[i].draw();
    if(hitTheTop(ball[i]) || hitTheGround(ball[i])){
      ball[i].bounce(0.0, 1.0); 
    }
    if(hitTheLeft(ball[i]) || hitTheRight(ball[i])){
      ball[i].bounce(1.0, 0.0);
    }
  }
  text("Theta of ball 0: " + (ball[0].theta * (180/Math.PI)), 500, 500);
  text("Quad of ball 0: " + ball[0].quad, 500, 550);
}

Boolean hitTheTop(Ball ball){
 if(ball.posy - ball.radius <= 0 && ball.velocityY >= 0){
   return true;
 } else {
   return false;
 }
}

Boolean hitTheGround(Ball ball){
  if(ball.posy + ball.radius >= height && ball.velocityY <= 0){
    return true;
  }else{
    return false;
  }
}

Boolean hitTheLeft(Ball ball){
  if(ball.posx - ball.radius <= 0 && ball.velocityX <= 0){
    return true;
  }else{
    return false;
  }
}

Boolean hitTheRight(Ball ball){
  if(ball.posx + ball.radius >= width && ball.velocityX >= 0){
    return true;
  }else{
    return false;
  }
}

class Ball {
  float radius;
  float velocity;
  float velocityX = 10.0, velocityY = 0.0;
  float posx = 150.0, posy = 150.0;
  float mag;
  float theta;
  float mass;
  int quad;
  float friction = 0.005;
  int[] colors = new int[3];
  Boolean looped = false;
  Ball(float radius){
     this.radius = radius;
     this.mass = radius * 1000;
     this.colors[0] = 255;
     this.colors[1] = 255;
     this.colors[2] = 255;
     //println(this.colors[0] + "" + this.colors[1] + "" + this.colors[2] + "" + this.radius);
  }
  
  void loop(){
     this.posx += velocityX;
     /*
     if(velocityX < 0 && this.posx + velocityX < 0){
       this.posx = 0;
     }else if(velocityX > 0 && this.posx + velocityX > width){
       this.posx = width;
     }else{
       this.posx += velocityX;
     }*/
     this.posy -= velocityY;
     this.velocityY -= 0.5;
     
     if(this.velocityX > 0){
        this.velocityX -= friction; 
     }else{
        this.velocityX += friction; 
     }
     
     if(this.velocityY > 0){
        this.velocityY -= friction; 
     }else{
        this.velocityY += friction; 
     }
     
     this.mag = (float)Math.sqrt(Math.pow(velocityX, 2) + Math.pow(velocityY, 2));
     this.theta = (float)(Math.atan2((velocityY), (velocityX)));
     if(this.theta < 0){
       this.theta = (float)Math.PI + (this.theta * -1);
     }
     /*if(velocityX > 0){
        if(velocityY < 0){
          this.theta *= -1;
          quad = 4;
        }else{
          quad = 2;
        }
     }else{
       if(this.velocityY > 0){
        this.theta = ((float)Math.PI - this.theta); 
        quad = 1;
       }else{
        quad = 3;
        this.theta *= -1;
        this.theta = (float)Math.PI - this.theta;
       }
     }*/
  }
  
  void draw(){
     fill(this.colors[0], this.colors[1], this.colors[2]);
     ellipse(this.posx, this.posy, radius * 2, radius * 2); 
  }
  
  void bounce(float horizontal, float vertical){
     if(horizontal > 0){
       this.velocityX *= -1;
     }
     if(vertical > 0){
       this.velocityY *= -1;
     }
  }
}

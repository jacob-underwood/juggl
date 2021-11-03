import gohai.glvideo.*;
import blobDetection.BlobDetection;

GLCapture video;

color trackColor; 
float threshold = 15;
Ball red;
Ball blue;
Ball purple;

ArrayList<int[]> redTracker = new ArrayList<int[]>();

void setup() {
  size(320, 240, P2D); // Important to note the renderer
  
  // Get the list of cameras connected to the Pi
  String[] devices = GLCapture.list(); 
  println("Devices:");
  printArray(devices);
  
  // Get the resolutions and framerates supported by the first camera
  if (0 < devices.length) {
    String[] configs = GLCapture.configs(devices[0]); 
    println("Configs:");
    printArray(configs);
  }

  red = new Ball(color(172, 39, 48), 15);
  blue = new Ball(color(25, 67, 167), 10);
  purple = new Ball(color(49, 31, 107), 15);

  // this will use the first recognized camera by default
  video = new GLCapture(this);

  video.start();
  

 
}

void draw() {
  //if (redTracker.size() > 1)
  //println(redTracker.get(redTracker.size()-1)[0]);
  
  background(0);
  if (video.available()) {
    video.read();
    video.loadPixels();
  }
  image(video, 0, 0, width, height);
  
  red.findColor();
  red.fallBall();
  red.showTrail(color(200, 50, 50));
  
  blue.findColor();
  blue.fallBall();
  blue.showTrail(color(70, 70, 250));
  
  purple.findColor();
  purple.fallBall();
  purple.showTrail(color(150, 30, 150));
  
  

  
}




float distSq(float x1, float y1, float z1, float x2, float y2, float z2) {
  float d = (x2-x1)*(x2-x1) + (y2-y1)*(y2-y1) +(z2-z1)*(z2-z1);
  return d;
}

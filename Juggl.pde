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
  size(480, 360, P2D); // Important to note the renderer
  
  // Get the list of cameras connected to the Pi
  String[] devices = GLCapture.list(); 
  println("Devices:");
  //printArray(devices);
  
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
  video = new GLCapture(this, devices[0], 480, 360, 30);

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
  image(blur(video), 0, 0, width, height);
  red.findColor();
  //red.fallBall();
  red.showTrail(color(200, 50, 50));
  
  blue.findColor();
  //blue.fallBall();
  blue.showTrail(color(70, 70, 250));
  
  purple.findColor();
  //purple.fallBall();
  purple.showTrail(color(100, 10, 100));

  
}

PImage blur(PImage img) {
 
  img.loadPixels();
  
  //beMoreEfficient(please);

  // Create an opaque image of the same size as the original
  PImage edgeImg = createImage(img.width, img.height, RGB);
  int[] ballPos = red.getCurrPos();
  // Loop through every pixel in the image
  for (int y = 1; y < img.height-1; y++) {   // Skip top and bottom edges
    for (int x = 1; x < img.width-1; x++) {  // Skip left and right edges
      int pos = y*img.width + x;
      color pixel = img.pixels[pos];
      double d = pow(ballPos[0] - x, 2) + pow(ballPos[1] - y, 2);
      
      //if ((x > ballPos[0] - d && x < ballPos[0] + d) && (y > ballPos[1] - d && y < ballPos[1] + d))
      if (d < 900)
        edgeImg.pixels[pos] = pixel;
      else {
        float r = red(pixel);
        float g = green(pixel);
        float b = blue(pixel);
        edgeImg.pixels[pos] = color((r+g+b)/3);
      }
      
      
    }
  }
  
  return edgeImg;
}




float distSq(float x1, float y1, float z1, float x2, float y2, float z2) {
  float d = (x2-x1)*(x2-x1) + (y2-y1)*(y2-y1) +(z2-z1)*(z2-z1);
  return d;
}

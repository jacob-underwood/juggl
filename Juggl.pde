import gohai.glvideo.*;
import blobDetection.BlobDetection;

GLCapture video;

color trackColor; 
Ball red;
Ball blue;
Ball purple;
Ball green;


void setup() {
  size(480, 360, P2D); // Important to note the renderer
  
  red = new Ball(color(172, 39, 48), 15);
  blue = new Ball(color(30, 110, 208), 25);
  purple = new Ball(color(49, 31, 107), 15);
  green = new Ball(color(0, 187, 176), 25);

  String[] devices = GLCapture.list(); 
  video = new GLCapture(this, devices[0], 480, 360, 30);

  video.start();
}

void draw() {
  background(0);
  
  if (video.available()) {
    video.read();
    video.loadPixels();
  }
  image(video, 0, 0, width, height);
  red.findColor();
  red.showTrail(color(200, 50, 50), "Dashes", false);
  
  blue.findColor();
  blue.showTrail(color(70, 70, 250), "Line", true);
  
  purple.findColor();
  purple.showTrail(color(100, 10, 100), "Line", false);
  
  green.findColor();
  green.showTrail(color(0, 250, 0), "Dots", false);

  
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

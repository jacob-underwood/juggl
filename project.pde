import gohai.glvideo.*;
import blobDetection.BlobDetection;

GLCapture video;

color trackColor; 
float threshold = 0.5;

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

  // this will use the first recognized camera by default
  video = new GLCapture(this);

  // you could be more specific also, e.g.
  //video = new GLCapture(this, devices[0]);
  //video = new GLCapture(this, devices[0], 640, 480, 25);
  //video = new GLCapture(this, devices[0], configs[0]);

  video.start();
}

//void draw() {
//  colorMode(HSB, 360);
  
//  background(0);
//  // If the camera is sending new data, capture that data
//  if (video.available()) {
//    video.read();
//    video.loadPixels();
//  }
  
//  BlobDetection bd = new BlobDetection(video.width, video.height);
//  BlobDetection.setConstants(1000, 500, 400);
//  bd.setThreshold(0.1);
//  bd.computeBlobs(video.pixels);
//  println(bd.getBlobNb());
  
//   // for (int y = 0; y < video.width; y++){
//   //for (int x = 0; x < video.height; x++){
//   // float h = hue(video.get(y, x));
//   // float s = saturation(video.get(y, x));
//   // float b = brightness(video.get(y, x));
    
    
//   // if ((h > 230 && h < 250) && s > 70)
//   // {
//   //   b = 90;
//   // }
    
    
//   // video.set(y, x, color(h, s, b));
//   //}
//  //}
  
//  // Copy pixels into a PImage object and show on the screen
//  image(video, 0, 0, width, height);
//  //filter(GRAY);
//  //filter(THRESHOLD, 0.1);
//}

void draw() {
  background(0);
  if (video.available()) {
    video.read();
    video.loadPixels();
  }
  image(video, 0, 0, width, height);

  //threshold = map(mouseX, 0, width, 0, 100);
  threshold = 15;

  float avgX = 0;
  float avgY = 0;

  int count = 0;
  trackColor = color(172, 39, 48);

   //Begin loop to walk through every pixel
  for (int x = 0; x < video.width; x++ ) {
    for (int y = 0; y < video.height; y++ ) {
      int loc = x + y * video.width;
      // What is current color
      color currentColor = video.pixels[loc];
      float r1 = red(currentColor);
      float g1 = green(currentColor);
      float b1 = blue(currentColor);
      float r2 = red(trackColor);
      float g2 = green(trackColor);
      float b2 = blue(trackColor);

      float d = distSq(r1, g1, b1, r2, g2, b2); 

      if (d < threshold*threshold) {
        stroke(255);
        strokeWeight(1);
        point(x, y);
        avgX += x;
        avgY += y;
        count++;
      }
    }
  }
  
   //We only consider the color found if its color distance is less than 10. 
   //This threshold of 10 is arbitrary and you can adjust this number depending on how accurate you require the tracking to be.
  if (count > 0) { 
    avgX = avgX / count;
    avgY = avgY / count;
    // Draw a circle at the tracked pixel
    fill(255);
    strokeWeight(4.0);
    stroke(0);
    ellipse(avgX, avgY, 24, 24);
  }
}


float distSq(float x1, float y1, float z1, float x2, float y2, float z2) {
  float d = (x2-x1)*(x2-x1) + (y2-y1)*(y2-y1) +(z2-z1)*(z2-z1);
  return d;
}

//void mousePressed() {
//  // Save color where the mouse is clicked in trackColor variable
//  int loc = mouseX + mouseY*video.width;
//  trackColor = video.pixels[loc];
//}

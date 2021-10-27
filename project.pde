import gohai.glvideo.*;
import blobDetection.BlobDetection;

GLCapture video;

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

void draw() {
  colorMode(HSB, 360);
  
  background(0);
  // If the camera is sending new data, capture that data
  if (video.available()) {
    video.read();
    video.loadPixels();
  }
  
  BlobDetection bd = new BlobDetection(video.width, video.height);
  BlobDetection.setConstants(1000, 500, 400);
  bd.setThreshold(0.1);
  bd.computeBlobs(video.pixels);
  println(bd.getBlobNb());
  
   // for (int y = 0; y < video.width; y++){
   //for (int x = 0; x < video.height; x++){
   // float h = hue(video.get(y, x));
   // float s = saturation(video.get(y, x));
   // float b = brightness(video.get(y, x));
    
    
   // if ((h > 230 && h < 250) && s > 70)
   // {
   //   b = 90;
   // }
    
    
   // video.set(y, x, color(h, s, b));
   //}
  //}
  
  // Copy pixels into a PImage object and show on the screen
  image(video, 0, 0, width, height);
  //filter(GRAY);
  //filter(THRESHOLD, 0.1);
}

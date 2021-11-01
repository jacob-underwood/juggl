import gohai.glvideo.*;
import blobDetection.BlobDetection;

GLCapture video;

color trackColor; 
float threshold = 15;

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

  // this will use the first recognized camera by default
  video = new GLCapture(this);

  video.start();
  

 
}

void draw() {
  if (redTracker.size() > 1)
  println(redTracker.get(redTracker.size()-1)[0]);
  
  background(0);
  if (video.available()) {
    video.read();
    video.loadPixels();
  }
  image(video, 0, 0, width, height);
  int[] loc = findColor(color(172, 39, 48), 15); //red
  findColor(color(147, 196, 164), 20); //gtreen
  findColor(color(49, 31, 107), 15); //purple
  //findColor(color(238, 238, 228), 10); //white
  findColor(color(25, 67, 167), 10);
  
  redTracker.add(loc);
  
}

int[] findColor(color trackColor, int threshold) {
  float avgX = 0;
  float avgY = 0;

  int count = 0;

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
  
  if (count > 0) { 
    avgX = avgX / count;
    avgY = avgY / count;
    // Draw a circle at the tracked pixel
    fill(red(trackColor));
    strokeWeight(4.0);
    stroke(0);
    ellipse(avgX, avgY, 84, 84);
    int[] res = {(int)avgX, (int)avgY};
    return res;
  }
  return new int[2];

}


float distSq(float x1, float y1, float z1, float x2, float y2, float z2) {
  float d = (x2-x1)*(x2-x1) + (y2-y1)*(y2-y1) +(z2-z1)*(z2-z1);
  return d;
}

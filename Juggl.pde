import gohai.glvideo.*;

GLCapture video;

color trackColor; 
Ball red;
Ball blue;
Ball purple;
Ball green;


void setup() {
  size(960, 720, P2D); // 2D rendering (as opposed to P3D, Becca)

  // Set colors that are tracked for each different color ball
  red = new Ball(color(172, 39, 48), 15);
  blue = new Ball(color(30, 110, 208), 25);
  purple = new Ball(color(49, 31, 107), 15);
  green = new Ball(color(0, 187, 176), 25);

  // Find devices then set framerate and dimensions (but does not print out yet)
  String[] devices = GLCapture.list(); 
  video = new GLCapture(this, devices[0], 480, 360, 30);

  video.start();
}

void draw() {
  background(0);
  
  // Gets video
  if (video.available()) {
    video.read();
    // This in theory gets the pixels in an array that's easy to work with
    video.loadPixels();
  }
  pushMatrix();
  translate(width, 0);
  scale(-1, 1);
  
  // Displays video instant
  image(video, 0, 0, width, height);
  
  // Locates the average color of red in the picture
  red.findColor();
  red.showTrail(color(200, 50, 50), "Dots", true);
  
  blue.findColor();
  blue.showTrail(color(70, 70, 250), "Line", true);
  
  purple.findColor();
  purple.showTrail(color(100, 10, 100), "Dots", false);
  
  green.findColor();
  green.showTrail(color(0, 250, 0), "Dots", false);

  popMatrix();
}

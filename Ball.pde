public class Ball {
  
  private ArrayList<int[]> history;
  private color trackColor;
  private int threshold;
  
  
  public Ball(color trackColor, int threshold) {
    this.trackColor = trackColor;
    this.history = new ArrayList<int[]>();
    this.threshold = threshold; 
  }
  
  
  public void findColor() {
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
      //fill(red(trackColor));
      //strokeWeight(4.0);
      //stroke(0);
      //ellipse(avgX, avgY, 4, 4);
      int[] res = {(int)avgX, (int)avgY};
      history.add(res);
    }
  
  }
  
  public void showTrail(color trailColor) {
    int size = history.size() - 1;
    int constant = 20;

    for (int i = size; i > size - constant && i >= 0; i--){
      stroke(trailColor, (constant - (size-i * 1.0) ) * 255 / constant);

      strokeWeight(8);
      int[] coords = history.get(i);
      point(coords[0], coords[1]);
    } 
  }
  
  public void fallBall() {
    for (int i = history.size() - 20; i < history.size() && i > 0; i++){
      int[] coords = history.get(i);
      coords[1] += 4;
      history.set(i, coords);
    }
  }
  
  public int[] getCurrPos() {
    if (history.size() == 0) return new int[2];
    return history.get(history.size() - 1);
  }
}

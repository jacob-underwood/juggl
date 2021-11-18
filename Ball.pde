public class Ball {
  
  // All the previous locations of a ball
  private ArrayList<int[]> history;
  // Color being tracked
  private color trackColor;
  // How strictly the color must match trackColor
  private int threshold;
   
  public Ball(color trackColor, int threshold) {
    this.trackColor = trackColor;
    this.history = new ArrayList<int[]>();
    this.threshold = threshold; 
  }
  
  public void findColor() {
    float avgX = 0;
    float avgY = 0;
  
    // How many pixels of the color (within threshold)
    int count = 0;
    float r2 = red(trackColor);
    float g2 = green(trackColor);
    float b2 = blue(trackColor);
  
    for (int x = 0; x < video.width; x++ ) {
      for (int y = 0; y < video.height; y++ ) {
        // 1D location
        int loc = x + y * video.width;
        color currentColor = video.pixels[loc];
        // Color of current pixel as opposed to  color that's being tracked
        float r1 = red(currentColor);
        float g1 = green(currentColor);
        float b1 = blue(currentColor);

  
        float d = distSq(r1, g1, b1, r2, g2, b2); 
    
        // Equivalent to sqrt(d) < threshold
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
     
      int[] res = {(int)avgX, (int)avgY};
      history.add(res);
    }
    else {
      int[] placeholder = {-1, -1};
      history.add(placeholder);
    }
  
  }
  
  public void showTrail(color trailColor, String type, boolean fall) {
    
    int size = history.size() - 1;
    int constant = 20;
    strokeWeight(8);
    strokeCap(ROUND);

    for (int i = size - 1; i > size - constant && i >= 0; i--){
      int[] coords = history.get(i);
      if (coords[0] < 0 && coords[1] < 0){
        continue;
      }
        
      if (fall){
        coords[1] += 4;
        history.set(i, coords);
      }
      
      stroke(trailColor, (constant - (size-i * 1.0) ) * 255 / constant);
      
      if (type.equals("Line")){
        trailColor = color(blue(trailColor) + 1, red(trailColor), green(trailColor));
        if (i % 2 == 0) 
          strokeCap(SQUARE);
        else 
          strokeCap(ROUND);
          
        int[] prev = history.get(i + 1);
        if (prev[0] > 0 && prev[1] > 0)
          line(coords[0], coords[1], prev[0], prev[1]);
      }
      else if (type.equals("Dots")){
        point(coords[0], coords[1]);
      } 
      else if (type.equals("Dashes")){
        if (i % 2 == 0){
          trailColor = color(blue(trailColor) + 1, red(trailColor), green(trailColor));
          if (i % 4 == 0)
            strokeCap(SQUARE);
          else 
            strokeCap(ROUND);
          int[] prev = history.get(i + 1);
          if (prev[0] > 0 && prev[1] > 0)
            line(coords[0], coords[1], prev[0], prev[1]);
        }
      }
      
    } 
  }
  
  
  public int[] getCurrPos() {
    if (history.size() == 0) return new int[2];
    return history.get(history.size() - 1);
  }
  
  // Squared distance formula (3D)
  private float distSq(float x1, float y1, float z1, float x2, float y2, float z2) {
    float d = (x2-x1)*(x2-x1) + (y2-y1)*(y2-y1) +(z2-z1)*(z2-z1);
    return d;
  }
}

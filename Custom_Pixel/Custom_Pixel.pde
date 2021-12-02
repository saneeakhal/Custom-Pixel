PImage promise, heart;
ArrayList<Dot> dots;
ArrayList<PVector> targets1, targets2;
int scaler = 2; // will use only every 2nd pixel from the image
int threshold = 200;
boolean imageToggled = false;
color col1, col2;

void setup() {
  size(50, 50, P2D);  
  promise = loadImage("promise.jpg");
  heart = loadImage("heart.jpg");
  
  int w, h;
  if (promise.width > heart.width) {
    w = promise.width;
  } else {
    w = heart.width;
  }
  if (promise.height > heart.height) {
    h = promise.height;
  } else {
    h = heart.height;
  }
  surface.setSize(w, h);
  
  promise.loadPixels();
  heart.loadPixels();
  
  targets1 = new ArrayList<PVector>();
  targets2 = new ArrayList<PVector>();
  
  col1 = color(242,112,153,80);
  col2 = color(85,191,212,12);
  
  for (int x = 0; x < heart.width; x += scaler) {
    for (int y = 0; y < heart.height; y += scaler) {
      int loc = x + y * heart.width;

      if (brightness(heart.pixels[loc]) > threshold) {
        targets2.add(new PVector(x, y));
      }
    }
  }

  dots = new ArrayList<Dot>();

  for (int x = 0; x < promise.width; x += scaler) {
    for (int y = 0; y < promise.height; y += scaler) {
      int loc = x + y * promise.width;
      
      if (brightness(promise.pixels[loc]) > threshold) {
        int targetIndex = int(random(0, targets2.size()));
        targets1.add(new PVector(x, y));
        Dot dot = new Dot(x, y, col1, targets2.get(targetIndex));
        dots.add(dot);
      }
    }
  }
}

void draw() { 
  background(0);
  
  blendMode(ADD);
  
  boolean flipTargets = true;

  for (Dot dot : dots) {
    dot.run();
    if (!dot.ready) flipTargets = false;
  }
  
  if (flipTargets) {
    for (Dot dot : dots) {
      if (!imageToggled) {
        int targetIndex = int(random(0, targets1.size()));
        dot.target = targets1.get(targetIndex);
        dot.col = col2;
      } else {
        int targetIndex = int(random(0, targets2.size()));
        dot.target = targets2.get(targetIndex);
        dot.col = col1;
      }
    }
    imageToggled = !imageToggled;
  }
    
  surface.setTitle("" + frameRate);
}

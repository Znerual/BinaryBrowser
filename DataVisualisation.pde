import processing.sound.*; //<>//

byte[] data;
int pixelPerData = 2;
int screenSize;
int zoomCounter = 2;
int boxCounter = 2;
int blockSize;
int dataOffset = 0;
int counter;
boolean initFinished = false;
boolean doubleByte = true;

boolean playSound = false;
//Sound
Pulse pulse;
TriOsc triOsc;
SawOsc sawOsc;
SqrOsc sqrOsc;
Env env;
ArrayList<Node> nodes = new ArrayList<Node>();

int nodeIndex = 0;
float trigger = 0f;
float nodeDistance = 50;
Node[] playNodes;
void setup() {
  selectInput("Select a file to process:", "fileSelected");
  //INit sound
  // Create triangle wave and envelope 
  triOsc = new TriOsc(this);
  sawOsc = new SawOsc(this);
  sqrOsc = new SqrOsc(this);
  pulse = new Pulse(this);
  env  = new Env(this);
  blockSize = 32 * pixelPerData;
  fullScreen();
  frameRate(10);
}
void fileSelected(File selection) {
  if (selection == null) {
    exit();
  } else {
    data = loadBytes(selection.getAbsolutePath());
    initFinished = true;
  }
}

color getColorMid(byte[] bytes) {
  if (bytes != null && bytes.length == 2) {
    return color(bytes[0], bytes[1], ((float)(bytes[0] + bytes[1] + 1)/2.0) - 0.5);
  }
  return (0);
}
color getColor(byte[] bytes) {
  if (bytes != null && bytes.length == 2) {
    return color(bytes[0], bytes[1], bytes[0] > bytes[1] ? 255 : 0);
  }
  return (0);
}
byte getSingleByte(int counter) {
  if (counter + 1 < data.length && counter > 0) {
    return data[counter];
  }
  return 0;
}
color getColor(byte bytes) {
  return color(bytes);
}
byte[] getByte(int counter) {
  if (counter +1 < data.length && counter > 0) {
    byte[] result = new byte[2];
    result[0] = data[counter];
    result[1] = data[counter +1];
    return  result;
  }
  byte[] res = {0, 0};
  return res;
}


void draw() {
  if (initFinished) {
    if (!playSound) {
      counter = 0;
      nodes.clear();
      for (int sy = 0; sy < height; sy += blockSize) {
        for (int sx = 0; sx < width; sx += blockSize) {
          drawBox(sx, sy);
        }
      }
      fill(255);
      text("Box: " + blockSize, 0, height - 35);
      text("Zoom: " + pixelPerData, 100, height-35);
      text("Increase: " + (boxCounter > 0 ? true : false), 200, height - 35);
      text("Locked:", 300, height - 35);
    } else {
      text("Locked: True", 300, height - 35);
      if (nodeIndex +1 < playNodes.length) {
        if (millis() > trigger) {
          env  = new Env(this);
          playNodes[nodeIndex].play(sawOsc, env);
          playNodes[nodeIndex+1].play(triOsc, env);
          
          trigger = millis() + max(playNodes[nodeIndex].getDuration(),playNodes[nodeIndex+1].getDuration()) + nodeDistance;
          nodeIndex += 2;
        }
      } else {
        nodeIndex =0;
      }
    }
  }
}
void drawBox(int sx, int sy) {
  for (int by = 0; by < blockSize; by += pixelPerData) {
    for (int bx = 0; bx < blockSize; bx += pixelPerData) {
      if (bx + pixelPerData >= blockSize || by+pixelPerData >= blockSize) {
        for (int y = 0; y < pixelPerData; y++) {
          for (int x = 0; x < pixelPerData; x++) {               
            set(x+sx+bx, y+sy+by, color(255, 255, 255));
          }
        }
      } else {
        color dataColor;
        if (doubleByte) {
          dataColor = getColor(getByte(counter + dataOffset));
          nodes.add(new Node(getByte(counter + dataOffset)));
          counter+=2;
        } else {
          dataColor = getColor(getSingleByte(counter + dataOffset));
          nodes.add(new Node(getSingleByte(counter + dataOffset)));
          counter += 1;
        }

        for (int y = 0; y < pixelPerData; y++) {
          for (int x = 0; x < pixelPerData; x++) {               
            set(x+sx+bx, y+sy+by, dataColor);
          }
        }
      }
    }
  }
}


void keyPressed() {
  if (key == 'z') { //Key: S
    if (zoomCounter >= 0) {   
      pixelPerData *= zoomCounter;
    } else {
      pixelPerData /= (zoomCounter * -1);
    }
  } else if (key == 'b') { //Key: B
    if (boxCounter >= 0) {   
      blockSize *= boxCounter;
    } else {
      blockSize /= (boxCounter * -1);
    }
  } 
  if (key == 'a') {

    dataOffset -= sq(blockSize-pixelPerData) / (doubleByte ? pixelPerData: pixelPerData * 2);
  } else if (key == 'd') {
    dataOffset += sq(blockSize-pixelPerData) / (doubleByte ? pixelPerData: pixelPerData * 2);
  }
  if (key == 's') {
    doubleByte = !doubleByte;
  }
  if (key == 'f') {
    zoomCounter *= -1;
    boxCounter *= -1;
  }
  if (key == 'p') {
    playSound = !playSound;
    playNodes =nodes.toArray(new Node[nodes.size()]);
    nodeIndex = 0;
  }
  if (key == 'q') {
    exit();
  }
  if (key == 'n') {
    selectInput("Select a file to process:", "fileSelected");
  }
}
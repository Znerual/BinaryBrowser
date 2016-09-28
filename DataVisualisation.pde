byte[] data; //<>// //<>// //<>// //<>// //<>//
int pixelPerData = 2;
int screenSize;
int zoomCounter = 2;
int boxCounter = 2;
int blockSize;
int dataOffset = 0;
boolean initFinished = false;
void setup() {
  selectInput("Select a file to process:", "fileSelected");
  
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
    int counter = 0;
    for (int sy = 0; sy < height; sy += blockSize) {
      for (int sx = 0; sx < width; sx += blockSize) {
        for (int by = 0; by < blockSize; by += pixelPerData) {
          for (int bx = 0; bx < blockSize; bx += pixelPerData) {
            color dataColor = getColor(getByte(counter + dataOffset));
            counter+=2;
            for (int y = 0; y < pixelPerData; y++) {
              for (int x = 0; x < pixelPerData; x++) {
                if (x +1 == blockSize || y+1 == blockSize) {
                  set(x+sx+bx, y+sy+by, color(255, 255, 255));
                } else {
                  set(x+sx+bx, y+sy+by, dataColor);
                }
              }
            }
          }
        }
      }
    }
  }
  fill(255);
  text("Box: " + blockSize, 0, height - 35);
  text("Zoom: " + pixelPerData, 100, height-35);
  text("Increase: " + (boxCounter > 0 ? true : false), 200, height - 35);
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
    
    dataOffset += height * blockSize;
  } else if (key == 'd') {
    dataOffset -= height * blockSize;
  }
  if (key == 'f') {
    zoomCounter *= -1;
    boxCounter *= -1;
  }
  if (key == 'q') {
    exit();
  }
  if (key == 'n') {
    selectInput("Select a file to process:", "fileSelected");
  }
}
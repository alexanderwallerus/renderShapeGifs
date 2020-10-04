//Code by Alexander Wallerus, MIT license

//This code was written to create .gifs with moving texture on various interpolated 
//shapes in between a rectangle and an ellipse based on a static image used
//for previous experiments
PGraphics graphics;
PImage texture;
float[] shapeInterpolations;
float[] brightnesses;
float halfWidth = 171;

void setup(){
  size(496, 601, P2D);
  background(20);
  texture = loadImage("newTexture.png");
  graphics = createGraphics(700, 700, P2D);
  graphics.beginDraw();          //without these 2 lines the first PGraphcis 
  graphics.endDraw();            //frame would be black
  brightnesses = new float[]{0.1, 0.2, 0.3, 0.4, 0.5, 0.6, 0.7, 0.8, 0.9, 1.0,
                             1.1, 1.2, 1.3, 1.4, 1.5, 1.6, 1.7, 1.8, 1.9};
  shapeInterpolations = new float[]{0.0, 0.2, 0.4, 0.5, 0.6, 0.8, 1.0};
  
  ////UNCOMMENT THIS BLOCK TO CREATE FRAMES FOR ONE SPECIFIC CONFIGURATION
  //createFrames(0.8, true, 1.2);
  //println("done");
  
  //UNCOMMENT THIS BLOCK TO CREATE ALL BRIGHTNESSES AND SHAPEINTERPOLATIONS AND
  //ROTATIONS
  for(int i=0; i<shapeInterpolations.length; i++){
    boolean rotated = false;
    for(int j=0; j<2; j++){
      rotated = (j==0) ? false : true;
      for(int k=0; k<brightnesses.length; k++){
        createFrames(shapeInterpolations[i], rotated, brightnesses[k]);
        println("created rotation: " + rotated +", interpolation: " + 
                shapeInterpolations[i] + ", brightness: " + 
                nf(brightnesses[k], 0, 3));
      }
    }
  }
}

void createFrames(float shapeInterp, boolean rotated, float bright){
  int pngCounter = 0;
  //the texture loops every 288 pixels => use textPos<288 for perfect looping and
  //for quick testing of folder structure with 2 result images each use textPos<4
  for(float textPos=0; textPos<288; textPos+=2){
    //render the image in the graphics PGraphic using the texture and parameters
    PImage rendered = renderImage(texture, shapeInterp, rotated, 
                                  textPos);
    //create a new PImage brightness rescaled from the rendered version
    PImage brightScaled = brightScaleImage(rendered, bright);
    
    ////UNCOMMENT TO RESIZE THE CREATED IMAGES BY A FACTOR
    //float resizeFactor = 0.1;
    //brightScaled.resize(int(brightScaled.width * resizeFactor),
    //                    int(brightScaled.height * resizeFactor));
    
    //testing code block:
    //display frame:
    //image(brightScaled, 0, 0, brightScaled.width/2, brightScaled.height/2);
    //save frame:
    //brightScaled.save("./tests/test.png");
    
    String saveName = "shape_rotated=" + rotated + "_interp=" +
                      nf(shapeInterp, 0, 2) + "_brightScale=" + nf(bright, 0, 3) + 
                      "_frame=" + nf(pngCounter, 3) + ".png";
    String saveDir = "results/rotated" + rotated + "\\interp" +
                     nf(shapeInterp, 0, 2) + "\\brightScale" + nf(bright, 0, 3) + 
                     "\\";
    
    //if this directory doesn't exist yet, create it
    String newDir = sketchPath("") + saveDir;
    File file = new File(newDir);
    file.mkdir();
                
    brightScaled.save(newDir + saveName);
    pngCounter++;
  }
}

PImage renderImage(PImage text, float shapeInterp, boolean rotated, float textPos){
  //interpolation of shape from 0.0 to 1.0
  graphics.beginDraw();
    graphics.background(0 );
    graphics.pushMatrix();
      graphics.strokeWeight(8);
      graphics.stroke(0, 159, 9);
      graphics.noFill();
      graphics.translate(graphics.width/2, graphics.height/2);
      if(rotated){
        graphics.rotate(HALF_PI);
      }
      //y scaling will stretch a square/circle into a rectangle/ellipse
      //y = 684 pixels, x = 334 pixels. 2.020 is a bit below this ratio
      //but reflects the original image measurements in the result frames
      float yScaling = 2.020;  
      textureMode(IMAGE);
      graphics.beginShape();
      graphics.texture(text);
        for(float theta=0; theta<TWO_PI; theta+= 0.001){  
          PVector squareVert = polarToSquareVert(theta);
          PVector circVert = polarToCircleVert(theta);
          PVector vert = PVector.lerp(squareVert, circVert, shapeInterp);
          
          float textVertX = map(vert.x, -halfWidth, halfWidth, 
                                0 +textPos, 334 +textPos);
          float textVertY = map(vert.y, -halfWidth, halfWidth, 
                                0, 684);
          graphics.vertex(vert.x, vert.y*yScaling, textVertX, textVertY);
        }
      graphics.endShape();
    graphics.popMatrix();
  graphics.endDraw();
  return graphics;
}

PImage brightScaleImage(PImage rendered, float brightScale){
  PImage brightScaled = createImage(rendered.width, rendered.height, RGB);
  rendered.loadPixels();
  brightScaled.loadPixels();
    for(int x=0; x<rendered.width; x++){
      for(int y=0; y<rendered.height; y++){
        int pixelPos = x + y*rendered.width;
        color col = rendered.pixels[pixelPos];
        float r = red(col)*brightScale;
        r = constrain(r, 0, 255);
        float g = green(col)*brightScale;
        g = constrain(g, 0, 255);
        float b = blue(col)*brightScale;
        b = constrain(b, 0, 255);
        brightScaled.pixels[pixelPos] = color(r, g, b);
      }
    }
  rendered.updatePixels();
  brightScaled.updatePixels();
  return brightScaled;
}

PVector polarToCircleVert(float theta){
  float r = halfWidth;
  PVector vert = polarToCartesian(r, theta);
  return vert;
}

PVector polarToSquareVert(float theta){
  float r = 0;
  if(theta < QUARTER_PI){
      //cos(theta) = (w/2)/r => for w==100 the hypothenuse r = 50/cos(theta)
      r = halfWidth/cos(theta);
    } else if(theta < HALF_PI+QUARTER_PI){
      //sin(theta) = (h/2)/r
      r = halfWidth/(sin(theta));
    } else if(theta < PI+QUARTER_PI){
      r = -halfWidth/cos(theta);
    } else if(theta < TWO_PI-QUARTER_PI){
      r = -halfWidth/(sin(theta));
    } else {
      r = halfWidth/cos(theta);
    }
    PVector vert = polarToCartesian(r, theta);
    return vert;
}

PVector polarToCartesian(float r, float theta){
  return new PVector(r*cos(theta), r*sin(theta));
}

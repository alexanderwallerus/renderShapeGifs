# render .gifs of a continously moving texture with different shapes, orientation, brightnesses, and texture movement direction

![example](/gitReadmeFiles/shape_dir=reverse_rotated=false_interp=0.80_brightScale=1.200.gif)

This code was written to create .gifs with moving texture on various interpolated 
shapes in between a rectangle and an ellipse based on a static image used
for previous experiments

Run the processing sketch to render frames for all orientations, shape interpolations, and brightnesses requested in the brightnesses and shapeInterpolations array.
Then run the python script to combine them into moving .gifs.
The python script needs ffmpeg installed in order to work.
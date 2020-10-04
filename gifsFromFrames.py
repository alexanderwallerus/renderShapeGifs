#Code by Alexander Wallerus, MIT license
 
import os
 
scriptDirectory = os.path.abspath("")
print(scriptDirectory)
print(os.walk("./"))
allFolders = [x[0] for x in os.walk(".\\results")]
#remove non terminal directories from the list
allFolders = [i for i in allFolders if "brightScale" in i]
print(allFolders) #['\\results\\rotatedfalse\\interp0.20\\brightScale0.500', '.\\results\\...
for folder in allFolders:
    print("current folder: ", folder)
    absPath = os.path.abspath(folder[2:])  #snip off the beginning .\ for the abspath to work
    #print(absPath)   #C:\Users\...\renderGifs\results\rotatedtrue\interp0.80\brightScale1.500
 
    firstFile = os.listdir(folder)[0]  #get the name of the first file
    #shape_rotated=false_interp=0.20_brightScale=0.500_frame=000.png
     
    #replace the 000 with %3d for use in ffmpeg
    generic = "_".join(firstFile.split("_")[:-1]) + "_frame=%3d.png"
    totalPath = absPath + "\\" + generic
     
    command = "ffmpeg -f image2 -framerate 40 -i " + totalPath + " " + scriptDirectory + \
              "\\resultGifs\\"
    gifName = firstFile.split("_")
    print(gifName)
    gifName[1:1] = ["dir=forward"]
    print(gifName)
    gifName = "_".join(gifName[:-1]) + ".gif"
    print(gifName)
    command += gifName
     
    os.system(command)
 
    #create reverse movement direction
    command = "ffmpeg -f image2 -framerate 40 -i " + totalPath + " -vf reverse " + \
              scriptDirectory + "\\resultGifs\\"
    gifName = firstFile.split("_")
    gifName[1:1] = ["dir=reverse"]
    gifName = "_".join(gifName[:-1]) + ".gif"
    command += gifName
     
    os.system(command)

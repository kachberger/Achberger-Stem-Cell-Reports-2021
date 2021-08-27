//User definses the number of circles
getDateAndTime(year, month, dayOfWeek, day, hour, minute, second, msec)

background=newArray(40,71,33);


//Open a Folder with exported TIFF images (unaltered 16bit) First image: Brighfield, second image: 488 FLuor
input = getDirectory("Input directory");
folder= File.getName(input);
list = getFileList(input);

//Open a Folder with exported TIFF images (unaltered 16bit)

//Make a folder for results
myDir = input +"\\resultGridder"+File.separator;
if (!File.exists(myDir))
  File.makeDirectory(myDir);
//Make a folder for results

path = myDir+ "results_ColoC"+folder+"_"+day+"_"+hour+"_"+minute+".txt"; 
if (File.exists(path)){ File.delete(path);}
String.append("Background values (Ch1-3):"+"\t"+background[0]+"\t"+background[1]+"\t"+background[2]); 
string1 =  String.buffer; 
File.append(string1, path);
String.resetBuffer;

for (k = 0; k < list.length; k++) {
//begin if cause only opening tiff files
if (endsWith(list[k], ".zvi") ){
//open each file from list
setBatchMode(true);
run("Bio-Formats Windowless Importer", "open=["+input+list[k]+ "]");
title= getTitle();
////////////Background Seetings + create the result files///////
//User Input= Define BG area
getDimensions(width, height, channels, slices, frames);


run("Clear Results");
run("Measure");
meanRes = getResult("Area", 0);
String.append("OrgSize:"+"\t"+meanRes+"\n"); 
run("Select All");
run("Clear Results");
run("Measure");
meanRes = getResult("Area", 0);
String.append("AllSize:"+"\t"+meanRes+"\n"); 

/////////
/////////
//////////Loop for channels
run("Clear Results");
//for(c=0;c<channels;c++){
for(d=0;d<slices;d++){
String.append("Slice"+d+1+"_"+getTitle()+"\t"); 
Stack.setSlice(d+1);
//background= newArray(63,102,16);

Stack.setChannel(1);
orgImage= getImageID();
run("Duplicate...", " ");
channel1 = getImageID();
setThreshold(background[0], 65535);
setOption("BlackBackground", true);
run("Convert to Mask");
run("Measure");
CurrentResult= nResults()-1;
meanRes = getResult("Mean", CurrentResult);
String.append(meanRes+"\t"); 
saveAs("jpeg", myDir+ title+"Slice"+d+1+"_ch1.jpg");

selectImage(orgImage);
Stack.setChannel(2);
run("Duplicate...", " ");
channel2 = getImageID();
setThreshold(background[1], 65535);
setOption("BlackBackground", true);
run("Convert to Mask");
run("Measure");
CurrentResult= nResults()-1;
meanRes = getResult("Mean", CurrentResult);
String.append(meanRes+"\t"); 
saveAs("jpeg", myDir+ title+"Slice"+d+1+"_ch2.jpg");

selectImage(orgImage);
Stack.setChannel(3);
run("Duplicate...", " ");
channel3 = getImageID();
setThreshold(background[2], 65535);
setOption("BlackBackground", true);
run("Convert to Mask");
run("Measure");
CurrentResult= nResults()-1;
meanRes = getResult("Mean", CurrentResult);
String.append(meanRes+"\t"); 
saveAs("jpeg", myDir+ title+"Slice"+d+1+"_ch3.jpg");

imageCalculator("AND create", channel1,channel2);
Col1and2 = getImageID();
run("Measure");
CurrentResult= nResults()-1;
meanRes = getResult("Mean", CurrentResult);
String.append(meanRes+"\t");
saveAs("jpeg", myDir+ title+"Slice"+d+1+"_chMerge1_2.jpg"); 

imageCalculator("AND create", channel1,channel3);
Col1and3 = getImageID();
run("Measure");
CurrentResult= nResults()-1;
meanRes = getResult("Mean", CurrentResult);
String.append(meanRes+"\t"); 
saveAs("jpeg", myDir+ title+"Slice"+d+1+"_chMerge1_3.jpg"); 

selectImage(channel1);
close();
selectImage(channel2);
close();
selectImage(channel3);
close();
selectImage(Col1and2);
close();
selectImage(Col1and3);
close();
selectImage(orgImage);
string1 =  String.buffer;
File.append(string1, path);
String.resetBuffer;
}

close();

}//if cause "Image = tif?"
}//for loop "once every image"

setBatchMode(false);
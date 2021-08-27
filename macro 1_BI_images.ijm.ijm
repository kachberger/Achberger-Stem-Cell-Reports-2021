//Open a Folder with exported TIFF images (unaltered 16bit) First image: Brighfield, second image: 488 FLuor
 input = getDirectory("Input directory");
folder= File.getName(input);
list = getFileList(input);

//Open a Folder with exported TIFF images (unaltered 16bit)
//Make a folder for results
myDir = File.getParent(input) + "\\results"+File.separator;
if (!File.exists(myDir))
  File.makeDirectory(myDir);
//Make a folder for results
//Make a file  for results and create headline
path = myDir+ "d1"+".txt";
if (File.exists(path)){ File.delete(path);}
String.append("Label"+"\t"+"Area"+"\t"+"Mean"+"\t"+"StdDev"+"\t"+"Sum"+"\t"+"Count"); 
string1 =  String.buffer; 
File.append(string1, path);
String.resetBuffer;
//Make a file  for results and create headline

//Clear previous results from table
 run("Clear Results");
 //Clear previous results from Table 
 
//begin for loop for opening all images from the choosen folder
for (i = 0; i < list.length/2; i++) {
//begin if cause only opening tiff files
if (endsWith(list[i], ".tif") ){
//open each file from list
open(input+list[2*i]);

//create a 8 bit treshold image from slice 1 Brightfield images)
run("8-bit");
run("Threshold...");
setThreshold(0, 168);
//user can check if treshold is ok
//wait(1000);
//waitForUser;
//if user makes any adjustmend by drawing, it will be altered; if no adjustment treshold will be measured
//selType= selectionType();
//if(selType!=-1){
//roiManager("reset");
//roiManager("add");	
//}
//else{
setOption("BlackBackground", false);
run("Convert to Mask");
roiManager("reset");
run("Analyze Particles...", "size=6.000-Infinity exclude include add in_situ");
//}

//user can check if result (either manual or automatic is ok)
wait(500);
//waitForUser;
//selType= selectionType();
//if(selType!=-1){
//roiManager("reset");
//roiManager("add");	
//}

//last change to add something, otherwise no further functioning)
while(roiManager("count")==0){
close();
open(input+list[2*i]);
run("Threshold...");
setThreshold(0, 168);
	waitForUser;
	selType= selectionType();
if(selType!=-1){
	roiManager("add");
	wait(1500);
}
else{
run("Analyze Particles...", "size=6.000-Infinity exclude include add in_situ");
wait(1500);
}
}

//Brightfield image will be closed
close();
//open Fluoresence image (2,4,6,...)
open(input+list[2*i+1]);

//if cause to check whether a selection has been made
if (roiManager("count")>0){

//roiManager("Select", 0);
//run("Make Inverse");
//run("Measure");
//CurrentResult= nResults()-1;
//ME= getResult("Mean", CurrentResult);
//SD= getResult("StdDev", CurrentResult);
//BG= ME+SD;
BG= 1300;

run("Select All");
run("Subtract...", "value="+BG);
roiManager("Select", 0);
run("Measure");
CurrentResult= nResults()-1;
labelRes= getResultLabel(CurrentResult);
areaRes= getResult("Area", CurrentResult);
meanRes = getResult("Mean", CurrentResult);
stdDevRes= getResult("StdDev", CurrentResult);
nBins=1;
	getHistogram(values,counts,nBins);
sumPixel=counts[0];

     String.append(labelRes+"\t"); 
     String.append(areaRes+"\t"); 
     String.append(meanRes+"\t"); 
     String.append(stdDevRes+"\t"); 
     String.append(sumPixel+"\t");
     



  nBins = 50;
  row = nResults();
  histMin= 0;
  histMax= 6000;
  getHistogram(values, counts, nBins, histMin, histMax);

  for (j=0; j<nBins; j++) {

String.append(counts[j]+"\t"); 
   }

 string1 =  String.buffer; 
File.append(string1, path);
String.resetBuffer;

roiManager("reset");

}
close();

}}
//end if cause only opening tiff files
//end for loop for opening all images from the choosen folder



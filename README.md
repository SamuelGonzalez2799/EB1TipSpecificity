# EB1TipSpecificity
Semi-automated script to analyze EB1 tip specificity in cell free assays and simulated cell free assays. Used for https://www.biorxiv.org/content/10.1101/2022.06.07.495114v1.abstract. 

## About the project

This code is used to quantify the amount of EB1 tip tracking in both cell free assays and in cells via measuring the tip Specificity (tip-background)/(lattice-background). This code inputs images with similar names (ie stacks0001, stacks0002, etc) that are RGB. For these images, the EB1 should be in the green channel and the dynamic microtubule in the red channel (although it can really be in any channel but the green channel). Additionally, this code was generated under the assumption that the microtubule seed would be in the green channel as well, although this is not altogether necessary (part of a legacy feature that is still present). The output of this code will be an excel file that has the intensity at the tip (called peak intensity), intensity along the lattice, ratio of peak/lattice, seed intensity, background intensity, and Tip Specificity (background subtracted tip to lattice ratio). For cell free assays, we use the Tip Specificity quantification. When in cells, we used the Ratio of Peak to Lattice ratio (as a clear background is hard to obtain). 

### Built With
MATLAB by Mathworks

## Getting Started
To get started, download this Github repository as a zipped file by downloading it from the "code" dropdown menu, unzip the file locally, and save it in an accessible location.  

To use the code, move the repository into the folder with your images to analyze. Of note, the script assumes that all images have a similar naming scheme (image0001, image0002, etc) so that it can automatically load in the next file. Of note, all inputs should be an RGB image with the dynamic microtubule in red, EB1 in green, and MT seed in green. If either of these are different, change them at the start of the code to ensure the output is correct. Furthermore, choose the name you want for the filename1 (which will be an excel sheet). Before starting the code, you will want to make sure that the filename1 is adjusted to what you what the output file to be called and the filename (image name) is changed to whatever you would like (here it assumes the images are TIFs).

## Prerequisites

Ensure Matlab is operational on your device. This code was generated to work with MATLAB 2022b. It should work with newer versions of Matlab. 

## Installation

This script requires some add-ons including: 
- Image Processing Toolbox


## Usage

Use the sample images along with the code to try it in your own system. The premise of the code is very simple: first, the user will get the microtubule oriented in the proper direction by clicking once at the peak EB1 position (highest EB1 intensity) and then a second time on the far side of the microtubule seed. This will then orient the image so that everything is in one line (x axis). Next, for each image, the user will click a total of 6 times. The first click is supposed to be centered on the peak EB1 position (highest area of EB1 intensity). The second is an area behind the tip along the lattice of the dynamic portion of the microtubule behind the tail of the EB1 comet. The third and forth are legacy code (and can be removed if desired) to allow the user to click at the start and the end of the comet to measure its lenght (in pixels). The fifth click is to be along the seed of the microtubule (also legacy) and the sixth click is to be for the background (normally picked near the first click but below/above the microtubule so as there shouldn't be any EB1. For each image, the data should be exported to the excel sheet so that if any errors occur, the data isn't lost. Then, this process is repeated for all images in the set. Of note, if the user clicks fewer than the expected number of clicks, and error will be thrown. 


Of note, this code was used for some publications from the Gardner lab including: 

https://www.biorxiv.org/content/10.1101/2022.06.07.495114v1.abstract 




## Contact

Samuel Gonzalez-(https://www.linkedin.com/in/samuel-gonzalez-081504163/) - samueljgonzalez@hotmail.com

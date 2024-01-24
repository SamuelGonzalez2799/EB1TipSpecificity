%Thsi code will input an image of a microtubule (MT should be red channel,
%protein should be green channel). The user then clicks twice to get a
%proper rotation of the image. Then, the user clicks the tip protein
%intensity middle, a lattice on the dynamic MT middle, the start and stop
%of the comet, a click for the seed intensity (which in this
%case is the same tagged protein color as the protein) for normalizing to),
% finally an area outside the tip for the background.
%

%%% Copyright Gardner lab 2023.
%%% The goal of this code is analyze cell free EB1 tip tracking along
%%% dynamic microtubules. This is done for either simulated microtubules
%%% are experimental microtubules. The code works by inputing images (which
%%% should be in a single folder with a consistent naming scheme such as
%%% stacks0001, stacks0002, etc). The user can define what the name of the
%%% images where filename is defined. The user also defines
%%% the name of the output excel file with the designation of filename 1
%%% . All images should be RGB and should have the microtubule in
%%% the red channel and your protein of interest (such as EB1) in the green
%%% channel. Then, one at a time, the images are opened. The user then
%%% should click twice so that the microtubule is oriented properly for
%%% analysis. For these clicks, one should click once at each end of the
%%% microtubule. The image will then be rotated so that the microtubule is
%%% flat (along the x axis so to speak). Then, the user clicks a total of 6
%%% times, the first click should be in the middle of the EB1 comet, the
%%% second should be along the lattice of the microtubule behind the comet
%%% (so should have no visible green). The third and fourth are legacy code 
%%% for the comet length with the third at the start and fourth at end of
%%% the comet. The fifth click is for the seed (in our imaging, we had the 
%%% seed in the same channel as the protein of
%%% interest, EB1, so that all data was contrasted to the seed upon
%%% analysis for consistency). Finally, the user clicks once
%%% outside of the microtubule to get the background intensity in the
%%% protein (EB1) channel. Then, the user hits enter and moves on. This
%%% data should be recorded and sent to an excel spreadsheet. Of note, it
%%% is possible for an error to occur if you do not click the correct
%%% number of times (may be fixed at a later date). In this instance,
%%% adjust the start position for tests at the start of the main for loop
%%% so that you start the analysis again at the correct image (rather than
%%% starting from the beginning) otherwises you might write over previous data. 
%%% Of note, the code uses boxes that are 5
%%% pixels by 5 pixels for all intensity measurements. Of note, since the
%%% main output (name background subtract ratio tip to lattice) can end up
%%% having very small values for the denominator, it is best to use the
%%% median of this data rather than the average when comparing across
%%% conditions (and this was done for 2024 DARPin paper). 

clear; clc; close all;
%fid_alpha = fopen ('EB1_density.txt','a');
%create an array to hold data in.
valuesMatrix=zeros(500,5);
%file headers. 
titles=["Peak Intensity","Lattice Intensity","Ratio of Peak to Lattice", "comet length", "Seed Intensity","backgroundIntensity","Tip Specificity"];%titles for excel output file
%pick the filename. 
filename1="Example.xlsx"; %name for output excel file for data
writematrix(titles,filename1)
%write file headers to file. 
for tests = 1 : 500  %indexing for each image
    %Initialize variables. 
    xf=[];%x pos of user picks
    yf=[];%y pos of user picks
    P=[];%intensity pos of user picks
    box_top = 2;%height of box analyzed; lenght by width will be box_top*2+1. 
    sumColorValsG  = 0;%initialize intensity for tip fluorescence
    sumColorValsG2  = 0;%initialize intensity for lattice fluorescence
    sumColorValsG3 = 0;%initialize intensity for seed fluorescence
    sumColorValsG4=0;%initialize intensity for background fluorescence
    ctr=0;
    
    
    tests
    
    %choose the proper name for the images you are using. 
    filename=sprintf('stacks%04d',tests);
    
    %read in the first image
    A=[];
    A = imread(filename,'tif');
    
    %show the first image
    imshow(A, [],'InitialMagnification','fit')
    %pick points and rotate the microtubule so it is aligned. 
    [x,y,P]=impixel();
    close;
    Angle= (atan((y(2,1)-y(1,1))/(x(2,1)-x(1,1))))*180/3.1415;
    %Angle=input('Enter rotation angle');
    
    uncorrected_length = sqrt((y(2,1)-y(1,1))^2 + (x(2,1) - x(1,1))^2);
    
    %rotate the image so it is along the x axis and show it. 
    B=imrotate(A,Angle,'nearest');
    
    imshow(B, [],'InitialMagnification','fit')
    
    %user picking positions of comet, seed, etc. 
    
    [xf,yf,P]=impixel();  %first click: bright spot on tip, second click: lattice, third click: start of comet, fourth click: end of comet, fifth click: seed, sixth click: background off to side of comet
    avgy=(yf(2,1)+yf(1,1))/2;
    
    y_pos = avgy;
    figure;
    %show where user inputs are by plotting the user picked positions. 
    imshow(B, [], 'InitialMagnification', 'fit');
    hold on
    
    plot([xf(1,1)-box_top, xf(1,1)+box_top],[y_pos-box_top, y_pos-box_top], 'w');
    plot([xf(1,1)-box_top, xf(1,1)+box_top],[y_pos+box_top, y_pos+box_top], 'w');
    plot([xf(1,1)-box_top, xf(1,1)-box_top], [y_pos-box_top, y_pos+box_top], 'w');
    plot([xf(1,1)+box_top, xf(1,1)+box_top], [y_pos-box_top, y_pos+box_top], 'w');
    
    plot([xf(2,1)-box_top, xf(2,1)+box_top],[y_pos-box_top, y_pos-box_top], 'w');
    plot([xf(2,1)-box_top, xf(2,1)+box_top], [y_pos+box_top, y_pos+box_top], 'w');
    plot([xf(2,1)-box_top, xf(2,1)-box_top], [y_pos-box_top, y_pos+box_top], 'w');
    plot([xf(2,1)+box_top, xf(2,1)+box_top], [y_pos-box_top, y_pos+box_top], 'w');
    
    plot(xf(3,1), avgy, 'y*')
    plot(xf(4,1), avgy, 'y*')
    
    plot([xf(5,1)-box_top, xf(5,1)+box_top],[y_pos-box_top, y_pos-box_top], 'w');
    plot([xf(5,1)-box_top, xf(5,1)+box_top], [y_pos+box_top, y_pos+box_top], 'w');
    plot([xf(5,1)-box_top, xf(5,1)-box_top], [y_pos-box_top, y_pos+box_top], 'w');
    plot([xf(5,1)+box_top, xf(5,1)+box_top], [y_pos-box_top, y_pos+box_top], 'w');
    
    plot([xf(6,1)-box_top, xf(6,1)+box_top],[yf(6,1)-box_top, yf(6,1)-box_top], 'w');
    plot([xf(6,1)-box_top, xf(6,1)+box_top], [yf(6,1)+box_top, yf(6,1)+box_top], 'w');
    plot([xf(6,1)-box_top, xf(6,1)-box_top], [yf(6,1)-box_top, yf(6,1)+box_top], 'w');
    plot([xf(6,1)+box_top, xf(6,1)+box_top], [yf(6,1)-box_top, yf(6,1)+box_top], 'w');
    hold off
    %allow user to confirm points are good before recording. 
    k = waitforbuttonpress
    %calculate comet lenght
    EB1_Length = abs(xf(3,1) - xf(4,1));
    
    for a=xf(2,1)-box_top:1:xf(2,1)+box_top  %lattice fluorescence is calculated
        
        ctr=ctr+1;
        colorValsG(ctr) = 0;
        
        
        for b= avgy-box_top:avgy+box_top
            
            [xt,yt,P]= impixel(B,a,b);
            colorValsG(ctr) = colorValsG(ctr) + P(2);
            
        end
        
        
        
        sumColorValsG2 = sumColorValsG2 + colorValsG(ctr);
        
        
        
    end  
    
    
    for a=xf(1,1)-box_top:1:xf(1,1)+box_top  %tip fluorescence is calculated
        
        ctr=ctr+1;
        colorValsG(ctr) = 0;
        
        
        for b= avgy-box_top:avgy+box_top
            
            [xt,yt,P]= impixel(B,a,b);
            colorValsG(ctr) = colorValsG(ctr) + P(2);
            
        end
        
        
        
        sumColorValsG = sumColorValsG + colorValsG(ctr);
        
        
        
    end
    
     for a=xf(5,1)-box_top:1:xf(5,1)+box_top  %seed fluorescence is calculated
        
        ctr=ctr+1;
        colorValsG(ctr) = 0;
        
        
        for b= yf(5,1)-box_top:yf(5,1)+box_top
            
            [xt,yt,P]= impixel(B,a,b);
            colorValsG(ctr) = colorValsG(ctr) + P(2);
            
        end
        
        
        
        sumColorValsG3 = sumColorValsG3 + colorValsG(ctr);
        
        
        
     end

     %background fluorescence
     for a=xf(6,1)-box_top:1:xf(6,1)+box_top  %background fluorescence is calculated
        
        ctr=ctr+1;
        colorValsG(ctr) = 0;
        
        
        for b= yf(6,1)-box_top:yf(6,1)+box_top
            
            [xt,yt,P]= impixel(B,a,b);
            colorValsG(ctr) = colorValsG(ctr) + P(2);
            
        end
        
        
        
        sumColorValsG4 = sumColorValsG4 + colorValsG(ctr);
        
        
        
     end
    %print out all values of interest
    %So is tip, then lattice, then ratio, then eb1 length
    %fprintf (fid_alpha,'%d %d %d %d %d %d',sumColorValsG,sumColorValsG2,sumColorValsG/sumColorValsG2, EB1_Length,sumColorValsG3,sumColorValsG4);
    %fprintf (fid_alpha,'\r\n');
    valuesMatrix(tests,1)=sumColorValsG;
    valuesMatrix(tests,2)=sumColorValsG2;
    valuesMatrix(tests,3)=sumColorValsG/sumColorValsG2;
    valuesMatrix(tests,4)=EB1_Length;
    valuesMatrix(tests,5)=sumColorValsG3;
    valuesMatrix(tests,6)=sumColorValsG4;
    valuesMatrix(tests,7)=(sumColorValsG-sumColorValsG4)/(sumColorValsG2-sumColorValsG4);
    number=int2str(tests+1);
   % number=[char(number(1)) char(number(2))]
    value=['A' number];
    %write data to the matrix
    writematrix(valuesMatrix(tests,:),filename1,'Sheet',1,'Range',value);

end  %end of images



%fclose(fid_alpha)


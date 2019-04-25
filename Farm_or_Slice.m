clc;clear all;close all

%slices remaining
%not sure if it'll be useful
gold = 0
purple = 1
blue = 2
green = 3
grey = 4
unrolled = 5

%possible starting speeds (we don't care about 0 speed)
purplerange = 3:23;
bluerange = 3:17;
greenrange = 3:11;
greyrange = 3:5;

%crystal cost to slice a mod
%currently arbitrary values. Will calculate the cost later
greycost = 42
greencost = 44
bluecost = 100
purplecost = 150
goldcost = 200

%minimum speed the user cares about
%let them input the value (for now it's faster to debug without their input)
targetspeed = 15


%This array is all slicing outcomes for speed bumps, equally weighted
slice = zeros(1,16);
for n = 3:6
    slice(n+10) = slice(n+10) + n;
end

%Starting speed of 6 is rare so I changed 6's spot to be 5
level = slice;
level(16) = 5;
    
%This will be a matrix of all possible outcomes a purple can have after being sliced to gold
%Rows all have the same starting speed
%Columns are all slicing outcomes (mostly unchanged, +0 speed)
purplematrix = zeros([length(purplerange), length(slice)]);
for startingspeed = 1:length(purplerange);
    for possibleslices = 1:length(slice);
        purplematrix(startingspeed, possibleslices) = purplerange(startingspeed) + slice(possibleslices);
    end
end
row = 1:size(purplematrix,1)
column = 1:size(purplematrix,2)
purplespeedgain = zeros(length(purplematrix),size(purplematrix,2));
for row = 1:size(purplematrix,1)
    for column = 1:size(purplematrix,2)
        %This finds the speed gained (but only that which exceeds the target speed). 
        purplespeedgain(row, column) = min([purplematrix(row, column) - targetspeed; slice(column)]);
        %Numbers under the target speed are converted to zero.
        %This way they don't bring down the mean.
        purplespeedgain(row, column) = neg2zero(purplespeedgain(row, column));
    end
end

%efficiency = purplespeedgain / purplecost;


%PrettyTable = array2table(purplematrix)

%Goals:
%include efficiency of refreshing Ground War for 7 guaranteed blues

    

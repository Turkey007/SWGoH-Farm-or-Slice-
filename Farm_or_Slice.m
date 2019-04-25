clc;clear all;close all

%slices remaining
%not sure if this'll be useful
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

%crystal cost to slice a mod (or level, in the case of greys)
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
  slicebumps = zeros(1,16);
  for n = 3:6
    slicebumps(n+10) = slicebumps(n+10) + n;
  end
  

%Starting speed of 6 is rare so I changed 6's spot to be 5
level = slicebumps;
level(16) = 5;

purplematrix = modslice(purplerange);

purplespeedgain = zeros(length(purplematrix),size(purplematrix,2));
for row = 1:size(purplematrix,1)
    for column = 1:size(purplematrix,2)
        %This finds the speed gained (but only that which exceeds the target speed). 
        %Perhaps instead of speed gained, final speed is more important
        purplespeedgain(row, column) = min([purplematrix(row, column) - targetspeed; slicebumps(column)]);
        %Numbers under the target speed are converted to zero.
        %This way they don't bring down the mean.
        purplespeedgain(row, column) = neg2zero(purplespeedgain(row, column));
    end
end

%displays efficiency
efficiency(:,1) = purplerange;
%multiplied by 100 to display as %
efficiency(:,2) = mean(purplespeedgain, 2) * 100 / goldcost;
percentconversion = strcat(num2str(efficiency(:,2)),'%');

% I can't get this damn table to look nice. It's all wrong.
nicetable(:,1) = efficiency(:,1);
nicetable(:,2) = percentconversion(:,1);
disp(nicetable)

bluematrix = modslice(bluerange);

greenmatrix = modslice(greenrange);

%PrettyTable = array2table(purplematrix)

%Goals:
%include efficiency of refreshing Ground War for 7 guaranteed blues


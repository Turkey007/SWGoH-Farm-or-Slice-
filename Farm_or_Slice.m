clc; clear all; close all;

%slices remaining
%not sure if this'll be useful
gold = 0;
purple = 1;
blue = 2;
green = 3;
grey = 4;
unrolled = 5;

%possible starting speeds (we don't care about 0 speed)
purplerange = 3:23;
bluerange = 3:17;
greenrange = 3:11;
greyrange = 3:5;

%salvage cost to slice a mod 
greysalvage = 0;
greensalvage = 10;
bluesalvage = 20;
purplesalvage = 35;
goldsalvage = 50;


%credit cost to slice a mod 
%In the case of greys, it's the level cost minus the sell cost,
%since most will end up in the trash
greycredits = 151100;
greencredits = 18000;
bluecredits = 36000;
purplecredits = 63000;
goldcredits = 90000;

%This is the user input, which is commented out. 
%(For now it's faster to debug without their input)
%{
defaulttargetspeed = 15;
inputprompt = ['Please enter the minimum desired speed. (Press enter to use the default value of ', num2str(defaulttargetspeed), ')\n'];
targetspeed = input(inputprompt);
if isempty(targetspeed)
  targetspeed = defaulttargetspeed;
end
%}

targetspeed = 15
output = ['Target speed is ', num2str(targetspeed), ' \n'];
fprintf(output)



%{
defaultcreditsratio = 3500;
inputprompt = ['Please enter how many credits are worth 1 crystal. (Press enter to use the default value of ', num2str(defaultcreditsratio), ')\n'];
creditsratio = input(inputprompt);
if isempty(creditsratio)
  creditsratio = defaultcreditsratio;
end
%}

creditsratio = 3500;
output = ['Credits ratio is ', num2str(creditsratio), ' \n'];
fprintf(output)


%crystal cost per salvage
refreshcost = 50;
refreshenergy = 120;
energy = 12;
sims = refreshenergy/energy;
droprate = 1.2;
drops = sims*droprate;
crystalspersalvage = refreshcost/drops;

%Total crystal cost to slice (including credit cost)
greycost = greycredits/creditsratio;
greencost = crystalspersalvage*greensalvage + greencredits/creditsratio;
bluecost = crystalspersalvage*bluesalvage + bluecredits/creditsratio;
purplecost = crystalspersalvage*purplesalvage + purplecredits/creditsratio;
goldcost = crystalspersalvage*goldsalvage + goldcredits/creditsratio;


%This array is all slicing outcomes for speed bumps, equally weighted
  slicebumps = zeros(1,16);
  for n = 3:6
    slicebumps(n+10) = slicebumps(n+10) + n;
  end
  

%Starting speed of 6 is rare so I changed 6's spot to be 5
level = slicebumps;
level(16) = 5;

purplematrix = modslice(purplerange);

%This for loop was very unnecessary so I'm redoing it simpler
%{
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
%}

purplespeedgain = min(purplematrix - targetspeed, slicebumps);
purplespeedgain = neg2zero(purplespeedgain);

%displays efficiency
purpleefficiency(:,1) = purplerange;
purpleefficiency(:,2) = mean(purplespeedgain, 2) / goldcost;

%{
% I can't get this damn table to look nice. It's all wrong.
%multiplied by 100 to display as %
efficiency(:,2) = efficiency(:,2)*100;
percentconversion = strcat(num2str(efficiency(:,2)),'%');
nicetable(:,1) = efficiency(:,1);
nicetable(:,2) = percentconversion(:,1);
disp(nicetable)
%PrettyTable = array2table(nicetable)
%}

bluematrix = modslice(bluerange);

for m = 1:size(bluematrix, 1)
    for n = 2:size(bluematrix, 2)
        purplerow = find(purplematrix(:,1) == bluematrix(m,n,1));
        for k = 2:size(purplematrix, 2)
            bluematrix(m,n,k) = purplematrix(purplerow, k);
        end
    end
end

bluespeedgain = min(bluematrix - targetspeed, slicebumps);
bluespeedgain = neg2zero(bluespeedgain);

%Should I approximate the cumulative cost of slicing a blue by saying:
%75% of blues won't be sliced further because speed won't hit.
%So the total cost to slice a blue all the way is 4 times the bluecost + the purplecost
%But then we only use the part of the blue table where speed hits the first time
blueefficiency(:,1) = bluerange;
blueefficiency(:,2) = mean(bluespeedgain(:,:,:) ) / (bluecost + purplecost)
%blueefficiency(:,2) = mean( ) / (4*bluecost + purplecost)

greenmatrix = modslice(greenrange);


%Goals:
%include efficiency of refreshing Ground War for 7 guaranteed blues
%include efficiency of purchasing mods from the mod shop
%include efficiency of refreshing the mod shop
%add option to treat speedgain scaling as nonlinear
%so the speed gained over target speed could be squared or to the 1.3 power
%e.g.
%This would represent that higher speeds are exponentially more valuable

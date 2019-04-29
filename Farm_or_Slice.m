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
%include efficiency of purchasing mods from the mod shop
%include efficiency of refreshing the mod shop

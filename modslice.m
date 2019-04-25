function finalspeed = modslice(speedrange)
  
  %This array is all slicing outcomes for speed bumps, equally weighted
  slicebumps = zeros(1,16);
  for n = 3:6
    slicebumps(n+10) = slicebumps(n+10) + n;
  end
  
  finalspeed = zeros([length(speedrange), length(slicebumps)]);
  for startingspeed = 1:length(speedrange);
      for possibleslices = 1:length(slicebumps);
          finalspeed(startingspeed, possibleslices) = speedrange(startingspeed) + slicebumps(possibleslices);
      end
  end
end
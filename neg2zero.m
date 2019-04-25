%This function turns negative numbers to zero, which helps for calculating speed gained over the minimum desired
%Awesomely, this function leaves positive numbers unchanged. 
function zero = neg2zero(number)
  zero = (abs(number) + number)/2;
end


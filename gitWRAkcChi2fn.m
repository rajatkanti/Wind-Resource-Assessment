function [chi2Cal]=gitWRAkcChi2fn(k,c,maxClass,datacount,noOfHours)
%% This function computes Chi Square statistic
%   for evaluating the accuracy of parameter estimation 
% $Author: Dr. Rajat Kanti Samal$ $Date: 2022/01/25 18:23:52 $    $Version: 1.0 $
% $Veer Surendra Sai University of Technology, Burla, Odisha, India$



%forming the class intervals
class=zeros(maxClass,1);
for i=1:maxClass
    class(i)=i;
end

noOfHoursT=zeros(maxClass,1);
noOfHoursT(1)=datacount*((1-exp(-((1/c)^k)))-(1-exp(-((0/c)^k))));
sumNoOfHoursT=noOfHoursT(1);
chi2Cal=((noOfHours(1)-noOfHoursT(1))^2)/noOfHoursT(1);
for i=2:maxClass
    noOfHoursT(i)=datacount*(((1-exp(-(class(i)/c)^k)))-(1-exp(-((class(i-1)/c)^k))));
    sumNoOfHoursT=sumNoOfHoursT+noOfHoursT(i);
    chi2Cal=chi2Cal+((noOfHours(i)-noOfHoursT(i))^2)/noOfHoursT(i);
end





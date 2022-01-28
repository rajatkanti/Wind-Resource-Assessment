
function [meanWindData,sdWindData]=gitWRAmeansdfn(maxClass,datacount,noOfHours,averageClassSpeed)
%% This function computes mean and standard deviation
%   arithmatic mean, mean square and cubic mean are computed
% $Author: Dr. Rajat Kanti Samal$ $Date: 2022/01/25 18:23:52 $    $Version: 1.0 $
% $Veer Surendra Sai University of Technology, Burla, Odisha, India$

%% arithmatic mean, root mean square and cubic mean of wind data
sumNm=zeros(3,1);
meanWindData=zeros(3,1);
for n=1:3
    for count=1:maxClass
        sumNm(n)=sumNm(n)+noOfHours(count)*(averageClassSpeed(count)^n);    
    end
    meanWindData(n)=(sumNm(n)/datacount)^(1/n);
end


%% standard deviation of wind data
sumNm=zeros(3,1);
sdWindData=zeros(3,1);
for n=1:3
    for count=1:maxClass
        sumNm(n)=sumNm(n)+noOfHours(count)*((averageClassSpeed(count)-meanWindData(n))^2);    
    end
    sdWindData(n)=(sumNm(n)/datacount)^(1/2);
end

%% End of function




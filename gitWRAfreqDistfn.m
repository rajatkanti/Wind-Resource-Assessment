%frequency distribution
function [maxClass,class,noOfHours,frequency,cumuFreq,midClassSpeed,averageClassSpeed]=gitWRAfreqDistfn(windData,datacount)
%% This function computes frequency distribution of wind speed
%   such as max class, frequency, cumulative frequency etc.
% $Author: Dr. Rajat Kanti Samal$ $Date: 2022/01/25 18:23:52 $    $Version: 1.0 $
% $Veer Surendra Sai University of Technology, Burla, Odisha, India$

%% Determination of maximum class interval
maxSpeed=max(windData);
intSpeed=int16(maxSpeed);
if intSpeed>maxSpeed
    maxClass=intSpeed;
else
    maxClass=intSpeed+1;
end

%% forming the class intervals
class=zeros(maxClass,1);
for i=1:maxClass
    class(i)=i;
end

%% frquency of class and sum of speeds in class for calculating average
noOfHours=zeros(maxClass,1);
classSpeedSum=zeros(maxClass,1);
for count=1:datacount
    for speed=1:maxClass
        if windData(count)>=(speed-1) && windData(count)<speed
            noOfHours(speed)=noOfHours(speed)+1;
            classSpeedSum(speed)=classSpeedSum(speed)+windData(count);
            break;
        end
    end
end

disp('maxSpeed  intSpeed  maxClass')
fprintf('%6.4f      %d     %d\n\n',maxSpeed,intSpeed,maxClass)

%% for calculating frquency as a fraction (probability) and cumulative freq
frequency=zeros(maxClass,1);
cumuFreq=zeros(maxClass,1);
for count=1:maxClass    
    frequency(count)=noOfHours(count)/datacount;
    if count==1
       cumuFreq(count)=frequency(count);
    else
       cumuFreq(count)=cumuFreq(count-1)+frequency(count);
    end
end

%% mid value of the class
midClassSpeed=zeros(maxClass,1);
for count=1:maxClass
    if noOfHours(count)~=0
        midClassSpeed(count)=double(count)-1/2;
    else
         midClassSpeed(count)=0;
    end
end

%% average speed in a class interval
averageClassSpeed=zeros(maxClass,1);
for count=1:maxClass
    if noOfHours(count)~=0
        averageClassSpeed(count)=classSpeedSum(count)/noOfHours(count);
    else
        averageClassSpeed(count)=0;
    end
end

%% End of function




function [monthlyAverage,meanWindSpeed]=gitWRAmeanfn(windData,datacount)
%% This function determines monthly mean and other means
%   simple mean, mean square and cubic mean are also computed
% $Author: Dr. Rajat Kanti Samal$ $Date: 2022/01/25 18:23:52 $    $Version: 1.0 $
% $Veer Surendra Sai University of Technology, Burla, Odisha, India$


%% Determination of monthly averages
if datacount>=8760
    hours=24;
else
    hours=1;
end
monthDur=[31 28 31 30 31 30 31 31 30 31 30 31]*hours;
durCount=0;
monthlySum=zeros(12,1);
monthlyAverage=zeros(12,1);
for month=1:12    
    for count=(durCount+1):(durCount+monthDur(month))
        monthlySum(month)=monthlySum(month)+windData(count);
    end
    durCount=durCount+monthDur(month);
    monthlyAverage(month)=monthlySum(month)/monthDur(month);
end

%% Mean of speed, speed2 and speed3
sumWindSpeed=0;sumWindSpeed2=0;sumWindSpeed3=0;
for count=1:datacount
    sumWindSpeed=sumWindSpeed+windData(count);
    sumWindSpeed2=sumWindSpeed2+(windData(count)^2);
    sumWindSpeed3=sumWindSpeed3+(windData(count)^3);
end

meanWindSpeed1=sumWindSpeed/datacount;
meanWindSpeed2=sumWindSpeed2/datacount;
meanWindSpeed3=sumWindSpeed3/datacount;
meanWindSpeed=[meanWindSpeed1 meanWindSpeed2 meanWindSpeed3];

%% End of function



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This program analyzes the wind speed time series 
% to obtain basic statistical parameters
% $Author: Dr. Rajat Kanti Samal$ $Date: 25-May-2021 $    $Version: 1.0 $
% $Veer Surendra Sai University of Technology, Burla, Odisha, India$




clc;
clear;
centTen=zeros(17,6);

%% Read wind speed data for year
disp('Now reading wind speed averages over the year...')
yearData=xlsread('C:\Users\RAJAT\Documents\MATLAB\IOFiles\NIWEio\NIWEwind80.xlsx', 'Year', 'D6:H8765');
hourYear=yearData(1:8760,1); dayYear=yearData(1:370,2); 
h3Year=yearData(1:2930,3); h6Year=yearData(1:1460,4); h12Year=yearData(1:730,5); 
%qnt = quantile(hourYear,3); intQ = qnt(3)-qnt(1); 
% figure(1)
% histogram(hourYear)
% figure(2)
% histogram(h3Year)
% figure(3)
% histogram(h6Year)
% figure(4)
% histogram(h12Year)
% figure(5)
% histogram(dayYear)

%% Read hourly average wind speed data for months
disp('Now reading monthly hourly average data...')
monData=xlsread('C:\Users\RAJAT\Documents\MATLAB\IOFiles\NIWEio\NIWEwind80.xlsx', 'Hourly', 'D6:O749');
janData=monData(1:744,1); marData=monData(1:744,3); mayData=monData(1:744,5); 
julData=monData(1:744,7); augData=monData(1:744,8); octData=monData(1:744,10); 
decData=monData(1:744,12); aprData=monData(1:720,4); junData=monData(1:720,6); 
sepData=monData(1:720,9); novData=monData(1:720,11); febData=monData(1:672,2); 
totD=[31 28 31 30 31 30 31 31 30 31 30 31];
for monID=1:12
    %fprintf('Month ID: %d \n',monID);
    totH=totD(monID)*24;
    windDataM=monData(1:totH,monID);
    centTen(monID,:) = [mean(windDataM) std(windDataM) std(windDataM)/mean(windDataM) ...
                iqr(windDataM) skewness(windDataM) kurtosis(windDataM)];
end
%histogram(decData)

%% Seasonal Data
summer=[marData; aprData; mayData];
rainy=[junData; julData; augData];
autumn=[sepData; octData; novData];
winter=[decData; janData; febData];
centTen(13,:) = [mean(summer) std(summer) std(summer)/mean(summer) ...
    iqr(summer) skewness(summer) kurtosis(summer)];
centTen(14,:) = [mean(rainy) std(rainy) std(rainy)/mean(rainy) ...
    iqr(rainy) skewness(rainy) kurtosis(rainy)];
centTen(15,:) = [mean(autumn) std(autumn) std(autumn)/mean(autumn) ...
    iqr(autumn) skewness(autumn) kurtosis(autumn)];
centTen(16,:) = [mean(winter) std(winter) std(winter)/mean(winter) ...
    iqr(winter) skewness(winter) kurtosis(winter)];
%histogram(spring)

%% Add central tendency of year at last
centTen(17,:) = [mean(hourYear) std(hourYear) std(hourYear)/mean(hourYear) ...
                iqr(hourYear) skewness(hourYear) kurtosis(hourYear)];

disp('Now writing central tendency...')
xlswrite('C:\Users\Rajat\Documents\MATLAB\IOFiles\NIWEio\NIWEres.xlsx', centTen, 'Ana', 'D7:I23' );

% hold all; 
% plot(xlim, c1*[1 1])







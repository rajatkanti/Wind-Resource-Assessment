%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This is a script of executing niwePlotDistFn.m 
% to plot fitted wind speed distributions
% MATLAB Statistics Toolbox is used
% $Author: Dr. Rajat Kanti Samal$ $Date: 03-June-2020 $    $Version: 1.0 $
% $Veer Surendra Sai University of Technology, Burla, Odisha, India$


clc;
clear;

periodC=input('Enter Period: 1-Year;2-Month;3-Seasons-->'); 

switch(periodC)
    case 1        
        %% Yearly data
        disp('Now reading wind speed averages over the year...')
        yearData=xlsread('C:\Users\RAJAT\Documents\MATLAB\IOFiles\NIWEio\NIWEwind80.xlsx', 'Year', 'D6:H8765');
        hourYear=yearData(1:8760,1);   
        disp('Now plotting yearly data...')               
        niwePlotDistYfn(hourYear);
    case 2
        %% Monthly data
        disp('Now reading monthly hourly average data...')
        monData=xlsread('C:\Users\RAJAT\Documents\MATLAB\IOFiles\NIWEio\NIWEwind80.xlsx', 'Hourly', 'D6:O749');
        disp('Now plotting monthly data...')
        niwePlotDistMfn(monData);           
    case 3 
        %% Seasonal data
        % Read data
        disp('Now reading monthly hourly average data...')
        monData=xlsread('C:\Users\RAJAT\Documents\MATLAB\IOFiles\NIWEio\NIWEwind80.xlsx', 'Hourly', 'D6:O749');
        janData=monData(1:744,1); marData=monData(1:744,3); mayData=monData(1:744,5); 
        julData=monData(1:744,7); augData=monData(1:744,8); octData=monData(1:744,10); 
        decData=monData(1:744,12); aprData=monData(1:720,4); junData=monData(1:720,6); 
        sepData=monData(1:720,9); novData=monData(1:720,11); febData=monData(1:672,2); 
        summer=[marData; aprData; mayData];
        rainy=[junData; julData; augData];
        autumn=[sepData; octData; novData];
        winter=[decData; janData; febData];
        % Plot distributions
        % niwePlotDistSfn(summer,rainy,autumn,winter); % All seasons separate
        niwePlotDistS2fn(summer,rainy,autumn,winter); % All seasons together
end% End of switch(periodC)



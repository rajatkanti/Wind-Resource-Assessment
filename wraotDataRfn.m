function windSpeed = wraotDataRfn( periodC,mon )
%wraotDataRfn reads data for wind rose plots
%   Yearly, Monthly or Seasonal data
% Author: Rajat Samal. Date: 11-May-2021

switch(periodC)
    case 1        
        %% Yearly data
        % disp('Now reading wind speed averages over the year...')
        yearData=xlsread('F:\MATLAB\IOFiles\NIWEio\NIWEwind80.xlsx', 'Year', 'D6:H8765');
        windSpeed=yearData(1:8760,1);
    case 2
        %% Monthly data
        % disp('Now reading monthly hourly average data...')
        monData=xlsread('F:\MATLAB\IOFiles\NIWEio\NIWEwind80.xlsx', 'Hourly', 'D6:O749'); 
        janData=monData(1:744,1); marData=monData(1:744,3); mayData=monData(1:744,5); 
        julData=monData(1:744,7); augData=monData(1:744,8); octData=monData(1:744,10); 
        decData=monData(1:744,12); aprData=monData(1:720,4); junData=monData(1:720,6); 
        sepData=monData(1:720,9); novData=monData(1:720,11); febData=monData(1:672,2); 
        switch(mon)
            case 1
                windSpeed=janData;
            case 2
                windSpeed=febData;
            case 3
                windSpeed=marData;
            case 4
                windSpeed=aprData;
            case 5
                windSpeed=mayData;
            case 6
                windSpeed=junData;
            case 7
                windSpeed=julData;
            case 8
                windSpeed=augData;
            case 9
                windSpeed=sepData;
            case 10
                windSpeed=octData;
            case 11
                windSpeed=novData;
            case 12
                windSpeed=decData;
        end
    case 3 
        %% Seasonal data
        % Read data
        % disp('Now reading monthly hourly average data...')
        monData=xlsread('F:\MATLAB\IOFiles\NIWEio\NIWEwind80.xlsx', 'Hourly', 'D6:O749');
        janData=monData(1:744,1); marData=monData(1:744,3); mayData=monData(1:744,5); 
        julData=monData(1:744,7); augData=monData(1:744,8); octData=monData(1:744,10); 
        decData=monData(1:744,12); aprData=monData(1:720,4); junData=monData(1:720,6); 
        sepData=monData(1:720,9); novData=monData(1:720,11); febData=monData(1:672,2); 
        summer=[marData; aprData; mayData];
        rainy=[junData; julData; augData];
        autumn=[sepData; octData; novData];
        winter=[decData; janData; febData];
        switch(mon)
            case 13
                windSpeed=winter;
            case 14
                windSpeed=summer;
            case 15
                windSpeed=rainy;
            case 16
                windSpeed=autumn;
        end
        
end% End of switch(periodC)


end % end of function


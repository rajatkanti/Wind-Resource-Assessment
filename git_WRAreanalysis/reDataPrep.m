function [ windData,datacount,nzPercent ]=reDataPrep( choiceData )
%% Data preparation for Weibull parameter estimation
%@ Author: Rajat Kanti Samal, This version date: 30-Apr-2020
% Following choices are available. 
% 1- zero speeds are converted to 0.01;
% 2-non zero speeds are only considered; 
% 3,6,12,24- 3,6,12 hourly and daily averages
    
    disp('Now reading wind speed data...')
    switch(choiceData)
        % Original Data        
        case 1
            colHData='D6:D8765';
        case 2
            colHData='D6:D8765';
        case 24
            colHData='E6:E370';
        case 3
            colHData='F6:F2926';
        case 6
            colHData='G6:G1465';
        case 12
            colHData='H6:H735';        
    end
    % windDataO=xlsread('C:\Users\Rajat\Documents\MATLAB\IOFiles\WRAV\WRAVav.xlsx', 'Year', colHData);
    % windDataO=xlsread('C:\Users\RAJAT\Documents\MATLAB\IOFiles\MERRAio\NIWERE\NIWEtemp.xlsx', 'Year', colHData);
    windDataO=xlsread('C:\Users\RAJAT\Documents\MATLAB\IOFiles\NIWEio\NIWEwind50.xlsx', 'Year', colHData);
    datacountO=size(windDataO,1);

    %%%%Converting zero wind speed to 0.01 m/s and Calculate non zero wind data count
    windDataC=zeros(datacountO,1);%zero to be converted to 0.01
    datacountNZ=0;
    for i=1:datacountO
        if windDataO(i)==0
            windDataC(i)=0.01;        
        else        
            windDataC(i)=windDataO(i);
            datacountNZ=datacountNZ+1;
        end
    end
    %%%%Non zero wind speed data
    windDataNZ=zeros(datacountNZ,1);
    countNZ=0;
    for i=1:datacountO
        if windDataO(i)~=0
            countNZ=countNZ+1;
            windDataNZ(countNZ)=windDataO(i);            
        end
    end

    % Percentage of non zero wind speed data
    nzPercent=(datacountNZ/datacountO)*100;

    switch(choiceData)
        case 1 % Hourly averages with zeros to 0.01
            windData=windDataC;
            datacount=datacountO;
        case 2 % Non zero hourly averages
            windData=windDataNZ;
            datacount=datacountNZ;
        case 3 % 3-hourly averages
            windData=windDataNZ;
            datacount=datacountNZ;
        case 6 % 6-hourly averages
            windData=windDataNZ;
            datacount=datacountNZ;
        case 12 % 12-hourly averages
            windData=windDataNZ;
            datacount=datacountNZ;
        case 24 % Daily averages
            windData=windDataNZ;
            datacount=datacountNZ;
    end

end% end of function


function [ windData,datacount,nzPercent ]=reDataPrepMon( choiceDataM,monID )
%% Data preparation for Weibull parameter estimation
%@ Author: Rajat Kanti Samal; Date of this version: 30-Apr-2020
% Following choices are available. 
% 1- zero speeds are converted to 0.01;
% 2-non zero speeds are only considered; 
% 3,6,12,24- 3,6,12 hourly and daily averages
    
%% Function Body
    totD=[31 28 31 30 31 30 31 31 30 31 30 31];
    totH=totD(monID)*24;
    disp('Now reading data...')
    if choiceDataM==1 || choiceDataM==2
        % windDataSel=xlsread('C:\Users\RAJAT\Documents\MATLAB\IOFiles\MERRAio\NIWERE\NIWEtemp.xlsx', 'Hourly', 'D6:O749');
        windDataSel=xlsread('C:\Users\RAJAT\Documents\MATLAB\IOFiles\NIWEio\NIWEwind50.xlsx', 'Hourly', 'D6:O749');
        windDataO=windDataSel(1:totH,monID);
    elseif choiceDataM==24        
        % windDataSel=xlsread('C:\Users\RAJAT\Documents\MATLAB\IOFiles\MERRAio\NIWERE\NIWEtemp.xlsx', 'Daily', 'D6:O36');
        windDataSel=xlsread('C:\Users\RAJAT\Documents\MATLAB\IOFiles\NIWEio\NIWEwind50.xlsx', 'Daily', 'D6:O36');
        windDataO=windDataSel(1:totD(monID),monID);
    end   
    datacountO=size(windDataO,1);
    disp('Data reading complete...')

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

    switch(choiceDataM)
        case 1 % Hourly averages with zeros to 0.01
            windData=windDataC;
            datacount=datacountO;
        case 2 % Non zero hourly averages
            windData=windDataNZ;
            datacount=datacountNZ;        
        case 24 % Daily averages
            windData=windDataNZ;
            datacount=datacountNZ;
    end

end% end of function


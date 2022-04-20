function [ windData,datacount,nzPercent ]=reDataPrepS( choiceData,sID )
%% data preparation for Seasonal Weibull parameter estimation
%@ Author: Rajat Kanti Samal; Date of this version: 30-Apr-2020
% Following choices are available. 
% 1- zero speeds are converted to 0.01;
% 2-non zero speeds are only considered; 
% 3,6,12,24- 3,6,12 hourly and daily averages
% Dec,Jan,Feb-Winter; Mar,Apr,May-Summer;
% June,July,Aug-Rain;Sep,Oct,Nov-Autumn
    
%% Function Body
    disp('Now reading wind speed data for seasonal data preparation...')
    if choiceData==1 || choiceData==2
        windDataSel=xlsread('C:\Users\RAJAT\Documents\MATLAB\IOFiles\NIWEio\NIWEwind50.xlsx', 'Year', 'D6:D8765');        
        hFlag=24;
    elseif choiceData==24        
        windDataSel=xlsread('C:\Users\RAJAT\Documents\MATLAB\IOFiles\NIWEio\NIWEwind50.xlsx', 'Year', 'E6:E370');
        hFlag=1;
    end   
    switch(sID)
        case 1                  
            windDataO(1:31*hFlag)=windDataSel((334*hFlag+1):365*hFlag);
            windDataO((31*hFlag+1):90*hFlag)=windDataSel(1:59*hFlag);            
        case 2
            windDataO(1:92*hFlag)=windDataSel((59*hFlag+1):151*hFlag);
        case 3
            windDataO(1:92*hFlag)=windDataSel((151*hFlag+1):243*hFlag);
        case 4
            windDataO(1:91*hFlag)=windDataSel((243*hFlag+1):334*hFlag);
    end
    windDataO=windDataO';
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


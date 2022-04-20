%% This program peforms correlation between LIDAR and MERRA data
%  And between NIWE purchased and MERRA data
% This program is for comparing weather variables
% @ Author: Rajat Kanti Samal, Date. 30-Apr-2020

clc;
clear;

%% Read reanalysis data
periodC=3;% 1-Year; 2-Month; 3-Season
choiceData=24; %1-hourly average; 24-daily average
height=3; %input('Enter variable choice (1-ps,2-qv10m,3-t10m)-->');

switch(periodC)
    case 1 % Yearly Data
        switch(height)
            case 1 % 2M height
                dsheet='wData';
                switch(choiceData)
                    case 1
                        colData='D6:D8765';%% hourly average
                        colCorr='D6:D6';
                    case 24
                        colData='H6:H370';%% daily average
                        colCorr='E6:E6';
                end    
            case 2 % 10M height
                dsheet='wData';
                switch(choiceData)
                    case 1
                        colData='E6:E8765';%% hourly average
                        colCorr='F6:F6';
                    case 24
                        colData='I6:I370';%% daily average
                        colCorr='G6:G6';
                end                
            case 3 % 50M height
                dsheet='wData';
                switch(choiceData)
                    case 1
                        colData='F6:F8765';%% hourly average
                        colCorr='H6:H6';
                    case 24
                        colData='J6:J370';%% daily average
                        colCorr='I6:I6';
                end    
        end
        
    case 2 % Monthly Data  
        switch(height)
            case 1
                switch(choiceData)
                    case 1
                        dsheet='psM'; 
                        colData='C6:N749';
                        colCorr='D11:D22';
                        monDay=[31 28 31 30 31 30 31 31 30 31 30 31]*24;
                    case 24
                        dsheet='psM'; 
                        colData='Q6:AB36';
                        colCorr='E11:E22';
                        monDay=[31 28 31 30 31 30 31 31 30 31 30 31];
                end
            case 2
                switch(choiceData)
                    case 1
                        dsheet='qv10M'; 
                        colData='C6:N749';
                        colCorr='F11:F22';
                        monDay=[31 28 31 30 31 30 31 31 30 31 30 31]*24;
                    case 24
                        dsheet='qv10M'; 
                        colData='Q6:AB36';
                        colCorr='G11:G22';
                        monDay=[31 28 31 30 31 30 31 31 30 31 30 31];
                end
            case 3
                switch(choiceData)
                    case 1
                        dsheet='t10M'; 
                        colData='C6:N749';
                        colCorr='H11:H22';
                        monDay=[31 28 31 30 31 30 31 31 30 31 30 31]*24;
                    case 24
                        dsheet='t10M'; 
                        colData='Q6:AB36';
                        colCorr='I11:I22';
                        monDay=[31 28 31 30 31 30 31 31 30 31 30 31];
                end
                
        end        
        
    case 3 % Seasonal Data
        switch(height)
            case 1
                switch(choiceData)
                    case 1
                        dsheet='psS'; 
                        colData='C6:F2213';
                        colCorr='D7:D10';
                        seaDay=[31+31+28 31+30+31 30+31+31 30+31+30]*24;
                    case 24
                        dsheet='psS'; 
                        colData='H6:K97';
                        colCorr='E7:E10';
                        seaDay=[31+31+28 31+30+31 30+31+31 30+31+30];
                end
            case 2
                switch(choiceData)
                    case 1
                        dsheet='qv10S'; 
                        colData='C6:F2213';
                        colCorr='F7:F10';
                        seaDay=[31+31+28 31+30+31 30+31+31 30+31+30]*24;
                    case 24
                        dsheet='qv10S'; 
                        colData='H6:K97';
                        colCorr='G7:G10';
                        seaDay=[31+31+28 31+30+31 30+31+31 30+31+30];
                end
            case 3
                switch(choiceData)
                    case 1
                        dsheet='t10S'; 
                        colData='C6:F2213';
                        colCorr='H7:H10';
                        seaDay=[31+31+28 31+30+31 30+31+31 30+31+30]*24;
                    case 24
                        dsheet='t10S'; 
                        colData='H6:K97';
                        colCorr='I7:I10';
                        seaDay=[31+31+28 31+30+31 30+31+31 30+31+30];
                end
        end
        
        
end
disp('Now reading reanalysis wind speed data...')
windDataR=xlsread('C:\Users\RAJAT\Documents\MATLAB\IOFiles\MERRAio\NIWERE\REniweW.xlsx', dsheet, colData);


%% Read measured data
switch(periodC)
    case 1 %%%%%%%% Yearly Data    
        % 24-Daily average; 1-zeroTo0.01; 2-Only nonZero;         
        [windData,datacount,nzPercent]=reDataPrep(choiceData);
    case 2 %%%%%%%% Monthly Data  
        windData=zeros(31,12);
        for monID=1:12 % 1 to 12
            disp(monID)
            [ windData(1:monDay(monID),monID),datacount,nzPercent ]=reDataPrepMon( choiceData,monID );
        end            
    case 3
        %sID=4;% 1-Winter;2-Summer;3-Rain;4-Autumn
        windData=zeros(92,4);
        for sID=1:4
            disp(sID)
            [ windData(1:seaDay(sID),sID),datacount,nzPercent ]=reDataPrepS( choiceData,sID );
        end        
end

%% Correlation
switch(periodC)
    case 1
      R= corrcoef(windData,windDataR);
      Rval=R(1,2);
    case 2
        Rval=zeros(12,1);
        for monID=1:12
            windDataM=windData(1:1:monDay(monID),monID);
            windDataRM=windDataR(1:monDay(monID),monID);
            R= corrcoef(windDataM,windDataRM);
            Rval(monID)=R(1,2);
        end
    case 3
        Rval=zeros(4,1);
        for sID=1:4
            windDataS=windData(1:1:seaDay(sID),sID);
            windDataRS=windDataR(1:1:seaDay(sID),sID);
            R= corrcoef(windDataS,windDataRS);
            Rval(sID)=R(1,2);
        end
      
end
disp('Now writing correlation values...')
xlswrite('C:\Users\RAJAT\Documents\MATLAB\IOFiles\MERRAio\NIWERE\REniweRes.xlsx', Rval, 'CorrW', colCorr);







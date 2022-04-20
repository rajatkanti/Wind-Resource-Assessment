%% This program obtains error measures for comparison between 
%  NIWE and MERRA data
% @ Author: Rajat Kanti Samal, Date. 04-Aug-2020

clc;
clear;

%% Read reanalysis data
periodC=3;% 1-Year; 2-Month; 3-Season
choiceData=1; %1-hourly average; 24-daily average
height=3;%input('Enter height (1-2M,2-10M,3-50M)-->');

switch(periodC)
    case 1 % Yearly Data
        switch(height)
            case 1 % 2M height
                dsheet='WS';
                switch(choiceData)
                    case 1
                        colData='D6:D8765';%% hourly average
                        % colCorr='D6:D6';
                    case 24
                        colData='H6:H370';%% daily average
                        % colCorr='E6:E6';
                end    
            case 2 % 10M height
                dsheet='WS';
                switch(choiceData)
                    case 1
                        colData='E6:E8765';%% hourly average
                        colErr='D6:I6';
                    case 24
                        colData='I6:I370';%% daily average
                        colErr='J6:O6';
                end                
            case 3 % 50M height
                dsheet='WS';
                switch(choiceData)
                    case 1
                        colData='F6:F8765';%% hourly average
                        colErr='D6:I6';
                    case 24
                        colData='J6:J370';%% daily average
                        colErr='J6:O6';
                end    
        end
        
    case 2 % Monthly Data  
        switch(height)
            case 1
                switch(choiceData)
                    case 1
                        dsheet='WSm2'; 
                        colData='C6:N749';
                        % colErr='D11:I22';
                        monDay=[31 28 31 30 31 30 31 31 30 31 30 31]*24;
                    case 24
                        dsheet='WSm2'; 
                        colData='Q6:AB36';
                        % colErr='J11:O22';
                        monDay=[31 28 31 30 31 30 31 31 30 31 30 31];
                end
            case 2
                switch(choiceData)
                    case 1
                        dsheet='WSm10'; 
                        colData='C6:N749';
                        colErr='D11:I22';
                        monDay=[31 28 31 30 31 30 31 31 30 31 30 31]*24;
                    case 24
                        dsheet='WSm10'; 
                        colData='Q6:AB36';
                        colErr='J11:O22';
                        monDay=[31 28 31 30 31 30 31 31 30 31 30 31];
                end
            case 3
                switch(choiceData)
                    case 1
                        dsheet='WSm50'; 
                        colData='C6:N749';
                        colErr='D11:I22';
                        monDay=[31 28 31 30 31 30 31 31 30 31 30 31]*24;
                    case 24
                        dsheet='WSm50'; 
                        colData='Q6:AB36';
                        colErr='J11:O22';
                        monDay=[31 28 31 30 31 30 31 31 30 31 30 31];
                end
                
        end        
        
    case 3 % Seasonal Data
        switch(height)
            case 1
                switch(choiceData)
                    case 1
                        dsheet='WSs2'; 
                        colData='C6:F2213';
                        % colErr='D7:D10';
                        seaDay=[31+31+28 31+30+31 30+31+31 30+31+30]*24;
                    case 24
                        dsheet='WSs2'; 
                        colData='H6:K97';
                        % colErr='E7:E10';
                        seaDay=[31+31+28 31+30+31 30+31+31 30+31+30];
                end
            case 2
                switch(choiceData)
                    case 1
                        dsheet='WSs10'; 
                        colData='C6:F2213';
                        colErr='D7:I10';
                        seaDay=[31+31+28 31+30+31 30+31+31 30+31+30]*24;
                    case 24
                        dsheet='WSs10'; 
                        colData='H6:K97';
                        colErr='J7:O10';
                        seaDay=[31+31+28 31+30+31 30+31+31 30+31+30];
                end
            case 3
                switch(choiceData)
                    case 1
                        dsheet='WSs50'; 
                        colData='C6:F2213';
                        colErr='D7:I10';
                        seaDay=[31+31+28 31+30+31 30+31+31 30+31+30]*24;
                    case 24
                        dsheet='WSs50'; 
                        colData='H6:K97';
                        colErr='J7:O10';
                        seaDay=[31+31+28 31+30+31 30+31+31 30+31+30];
                end
        end
        
        
end
disp('Now reading reanalysis wind speed data...')
% windDataR=xlsread('C:\Users\Rajat\Documents\MATLAB\IOFiles\MERRAio\MERRA.xlsx', dsheet, colData);
windDataR=xlsread('C:\Users\RAJAT\Documents\MATLAB\IOFiles\MERRAio\NIWERE\REniwe.xlsx', dsheet, colData);


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
      % Obtain error measure
      errMes= reERRfn(windData,windDataR);
      % Plot regression plot
      reRegPlotfn( windData,windDataR )
    case 2
        errMes=zeros(12,6);
        for monID=1:12
            windDataM=windData(1:1:monDay(monID),monID);
            windDataRM=windDataR(1:monDay(monID),monID);
            errMes(monID,:)= reERRfn(windDataM,windDataRM);            
        end
    case 3
        errMes=zeros(4,6);
        for sID=1:4
            windDataS=windData(1:1:seaDay(sID),sID);
            windDataRS=windDataR(1:1:seaDay(sID),sID);
            errMes(sID,:)= reERRfn(windDataS,windDataRS);   
            subplot(2,2,sID)
            reRegPlotfn( windDataS,windDataRS )
        end
      
end
% disp('Now writing correlation values...')
% xlswrite('C:\Users\RAJAT\Documents\MATLAB\IOFiles\MERRAio\NIWERE\REniweRes.xlsx', errMes, 'Err50', colErr);







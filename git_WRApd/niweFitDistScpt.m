%% This is a script of executing niweFitDistFn.m
%@ Author: Rajat Kanti Samal, This version data: 26-May-2020

clc;
clear;

periodC=input('Enter Period: 1-Year;2-Month;3-Seasons-->'); 

switch(periodC)
    case 1        
        %% Yearly data
        disp('Now reading wind speed averages over the year...')
        yearData=xlsread('C:\Users\RAJAT\Documents\MATLAB\IOFiles\NIWEio\NIWEwind20.xlsx', 'Year', 'D6:H8765');
        hourYear=yearData(1:8760,1);   
        disp('Now fitting yearly data...')
        periodC=1; sID=0; monID=0;        
        niweFitDistFn(periodC,monID,sID,hourYear);
        %niweFitDistMixFn(periodC,monID,sID,hourYear);
    case 2
        %% Monthly data
        disp('Now reading monthly hourly average data...')
        monData=xlsread('C:\Users\RAJAT\Documents\MATLAB\IOFiles\NIWEio\NIWEwind20.xlsx', 'Hourly', 'D6:O749');
        janData=monData(1:744,1); marData=monData(1:744,3); mayData=monData(1:744,5); 
        julData=monData(1:744,7); augData=monData(1:744,8); octData=monData(1:744,10); 
        decData=monData(1:744,12); aprData=monData(1:720,4); junData=monData(1:720,6); 
        sepData=monData(1:720,9); novData=monData(1:720,11); febData=monData(1:672,2); 
        disp('Now fitting monthly data...')
        sID=0;
        totD=[31 28 31 30 31 30 31 31 30 31 30 31];
        for monID=1:12
            fprintf('Month ID: %d \n',monID);
            totH=totD(monID)*24;
            windDataM=monData(1:totH,monID);
            niweFitDistFn(periodC,monID,sID,windDataM);
            %niweFitDistMixFn(periodC,monID,sID,windDataM);
        end
    case 3 
        %% Seasonal data
        % Read data
        disp('Now reading monthly hourly average data...')
        monData=xlsread('C:\Users\RAJAT\Documents\MATLAB\IOFiles\NIWEio\NIWEwind20.xlsx', 'Hourly', 'D6:O749');
        janData=monData(1:744,1); marData=monData(1:744,3); mayData=monData(1:744,5); 
        julData=monData(1:744,7); augData=monData(1:744,8); octData=monData(1:744,10); 
        decData=monData(1:744,12); aprData=monData(1:720,4); junData=monData(1:720,6); 
        sepData=monData(1:720,9); novData=monData(1:720,11); febData=monData(1:672,2); 
        summer=[marData; aprData; mayData];
        rainy=[junData; julData; augData];
        autumn=[sepData; octData; novData];
        winter=[decData; janData; febData];
        % Fit distributions
        % sID: 1-Summer;2-Rainy;3-Autumn;4-Winter
        monID=0;
        for sID=1:4
            fprintf('Season ID: %d \n',sID);
            switch(sID)
                case 1
                    windDataS=summer;
                case 2
                    windDataS=rainy; 
                case 3
                    windDataS=autumn;
                case 4
                    windDataS=winter;         
            end
            niweFitDistFn(periodC,monID,sID,windDataS);
            %niweFitDistMixFn(periodC,monID,sID,windDataS);
        end
end% End of switch(periodC)



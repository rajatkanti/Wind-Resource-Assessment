%% This program formats MERRA-2 weather variable data
%  corresponding to NIWE purchased data
% @Author: Rajat Kanti Samal, Version Date. 29-Apr-2020

%% Start up
clc;
clear;

%% Enter Choice
% Choice 1 Convert raw data to yearly data
% Choice 2 Convert yearly data to daily averages
% Choice 3 Convert to monthly data
% Choice 4 Convert monthly data to daily averages
% Choice 5 Convert to seasonal data
% choice 6 Convert seasonal data to daily averages

choice=6;

switch(choice)
    case 1
        %% Convert U,V data
        % This data is from 01-Mar-2013 to 28-Feb-2014
        disp('Now reading Raw data')
        raw=xlsread('C:\Users\RAJAT\Documents\MATLAB\IOFiles\MERRAio\NIWERE\REniweW.xlsx', 'Raw', 'C6:E17525');
        size(raw);
        i=0;
        ps=zeros(8760,1);
        qv10m=zeros(8760,1);
        t10m=zeros(8760,1);
        for row=1:17519
            if mod(row,2)~=0
                i=i+1;
                ps(i)=raw(row,1);
                qv10m(i)=raw(row,2);
                t10m(i)=raw(row,3);
            end
        end
        
        %%% Converting the data from Dec-Nov to Jan-Dec        
        psjd(1:1416)=ps(7345:8760); %Jan-Feb
        psjd(1417:8760)=ps(1:7344); %Mar-Dec
        
        qv10mjd(1:1416)=qv10m(7345:8760); %Jan-Feb
        qv10mjd(1417:8760)=qv10m(1:7344); %Mar-Dec
        
        t10mjd(1:1416)=t10m(7345:8760); %Jan-Feb
        t10mjd(1417:8760)=t10m(1:7344); %Mar-Dec
        
        windDataUV=[psjd' qv10mjd' t10mjd'];
        weatherD=[psjd' qv10mjd' t10mjd'];

        disp('Writing converted data...')
        xlswrite('C:\Users\RAJAT\Documents\MATLAB\IOFiles\MERRAio\NIWERE\REniweW.xlsx', weatherD, 'wData', 'D6:F8765');
    case 2
        %% Convert yearly data to daily averages
        disp('Now reading reanalysis wind speed data...')
        windData=xlsread('C:\Users\RAJAT\Documents\MATLAB\IOFiles\MERRAio\NIWERE\REniweW.xlsx', 'wData', 'D6:F8765');
        ps=windData(:,1);
        qv10m=windData(:,2);
        t10m=windData(:,3); 

        psdav=zeros(365,1);qv10dav=zeros(365,1);t10dav=zeros(365,1);
        for i=1:365
            psdav(i)=sum(ps((24*(i-1)+1):(24*i)))/24;
            qv10dav(i)=sum(qv10m((24*(i-1)+1):(24*i)))/24;
            t10dav(i)=sum(t10m((24*(i-1)+1):(24*i)))/24;
        end
        
        wDataDA=[psdav qv10dav t10dav];
        
        disp('Now writing reanalysis daily average data...')
        xlswrite('C:\Users\RAJAT\Documents\MATLAB\IOFiles\MERRAio\NIWERE\REniweW.xlsx', wDataDA, 'wData', 'H6:J370');        
    
    case 3
        %% Convert to monthly data
        hChoice=input('Enter choice (1- ps, 2-qv10m, 3-t10m) -->');
        switch(hChoice)
            case 1
                inCol='D6:D8765';
                oSheet='psM';
            case 2
                inCol='E6:E8765';
                oSheet='qv10M';
            case 3
                inCol='F6:F8765';
                oSheet='t10M';
        end
        disp('Now reading reanalysis wind speed data...')
        windData=xlsread('C:\Users\RAJAT\Documents\MATLAB\IOFiles\MERRAio\NIWERE\REniweW.xlsx', 'wData', inCol);        
        windMon=zeros(744,12);
        monDay=[31 28 31 30 31 30 31 31 30 31 30 31];
        totH=0;
        for i=1:12
            currH=totH+monDay(i)*24;
            windMon(1:monDay(i)*24,i)=windData((totH+1):currH);
            totH=currH;
        end
        disp('Now writing monthly data...')
        xlswrite('C:\Users\RAJAT\Documents\MATLAB\IOFiles\MERRAio\NIWERE\REniweW.xlsx', windMon, oSheet, 'C6:N749');
    case 4
        %% Convert monthly data to daily averages
        for hChoice=1:3
            %hChoice=input('Enter choice (1- ps, 2-qv10m, 3-t10m) -->');
            disp(hChoice)
            switch(hChoice)
                case 1                
                    oSheet='psM';
                case 2
                    oSheet='qv10M';
                case 3
                    oSheet='t10M';
            end
            disp('Now reading reanalysis wind speed monthly data...')
            windData=xlsread('C:\Users\RAJAT\Documents\MATLAB\IOFiles\MERRAio\NIWERE\REniweW.xlsx', oSheet, 'C6:N749');
            wsMdav=zeros(31,12);
            monDay=[31 28 31 30 31 30 31 31 30 31 30 31];
            for mon=1:12
                for i=1:monDay(mon)
                    wsMdav(i,mon)=sum(windData((24*(i-1)+1):(24*i),mon))/24;
                end
            end
            %wsMdav
            disp('Now writing daily averages of monthly data...')
            xlswrite('C:\Users\RAJAT\Documents\MATLAB\IOFiles\MERRAio\NIWERE\REniweW.xlsx', wsMdav, oSheet, 'Q6:AB36');
        end
    case 5
        %% Convert to seasonal data
        for hChoice=1:3
            % hChoice=input('Enter choice (1- ps, 2-qv10m, 3-t10m) -->');
            disp(hChoice)
            switch(hChoice)
                case 1
                    inCol='D6:D8765';
                    oSheet='psS';
                case 2
                    inCol='E6:E8765';
                    oSheet='qv10S';
                case 3
                    inCol='F6:F8765';
                    oSheet='t10S';
            end
            disp('Now reading reanalysis wind speed data...')
            windData=xlsread('C:\Users\RAJAT\Documents\MATLAB\IOFiles\MERRAio\NIWERE\REniweW.xlsx', 'wData', inCol);
            windSea=zeros(744*4,4);
            % Convert data from Jan-Dec to Dec-Nov;
            windDataS(1:744)=windData(8017:8760);
            windDataS(745:8760)=windData(1:8016);

            seaDay=[31+31+28 31+30+31 30+31+31 30+31+30];
            totH=0;currH=0;
            for i=1:4
                currH=totH+seaDay(i)*24;
                windSea(1:seaDay(i)*24,i)=windDataS((totH+1):currH);
                totH=currH;
            end
            disp('Now writing seasonal data...')
            xlswrite('C:\Users\RAJAT\Documents\MATLAB\IOFiles\MERRAio\NIWERE\REniweW.xlsx', windSea, oSheet, 'C6:F2213');
        end
        
    case 6 
        %% Convert seasonal data to daily averages   
        for hChoice=1:3
            % hChoice=input('Enter choice (1- ps, 2-qv10m, 3-t10m) -->');
            disp(hChoice)
            switch(hChoice)
                case 1                
                    oSheet='psS';
                case 2
                    oSheet='qv10S';
                case 3
                    oSheet='t10S';
            end
            disp('Now reading reanalysis wind speed seasonal data...')
            windData=xlsread('C:\Users\RAJAT\Documents\MATLAB\IOFiles\MERRAio\NIWERE\REniweW.xlsx', oSheet, 'C6:F2213');
            wsSdav=zeros(92,12);
            seaDay=[31+31+28 31+30+31 30+31+31 30+31+30];
            for sea=1:4
                for i=1:seaDay(sea)
                    wsSdav(i,sea)=sum(windData((24*(i-1)+1):(24*i),sea))/24;
                end
            end
            %wsMdav
            disp('Now writing daily averages of seasonal data...')
            xlswrite('C:\Users\RAJAT\Documents\MATLAB\IOFiles\MERRAio\NIWERE\REniweW.xlsx', wsSdav, oSheet, 'H6:K97');
        end
end

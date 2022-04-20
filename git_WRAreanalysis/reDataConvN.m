%% This program formats MERRA-2 data for NIWE purchased data
% @Author: Rajat Kanti Samal, Version Date. 28-Apr-2020

%% Start up
clc;
clear;

%% Enter Choice
% Choice 1 Convert U,V data to wind speed
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
        disp('Now reading U, V data')
        uv=xlsread('C:\Users\RAJAT\Documents\MATLAB\IOFiles\MERRAio\NIWERE\REniwe.xlsx', 'UV', 'B6:G17525');
        size(uv)
        i=0;
        u2=zeros(8760,1);v2=zeros(8760,1);
        u10=zeros(8760,1);v10=zeros(8760,1);
        u50=zeros(8760,1);v50=zeros(8760,1);
        for row=1:17519
            if mod(row,2)~=0
                i=i+1;
                u2(i)=uv(row,1);
                v2(i)=uv(row,2);
                u10(i)=uv(row,3);
                v10(i)=uv(row,4);
                u50(i)=uv(row,5);
                v50(i)=uv(row,6);
            end
        end

        ws2=zeros(8760,1);ws10=zeros(8760,1);ws50=zeros(8760,1);
        for i=1:8760
            ws2(i)=sqrt(u2(i)^2+v2(i)^2);
            ws10(i)=sqrt(u10(i)^2+v10(i)^2);
            ws50(i)=sqrt(u50(i)^2+v50(i)^2);
        end
        
        %%% Converting the data from Mar-Feb to Jan-Dec
        u2jd(1:1416)=u2(7345:8760); %Jan-Feb
        u2jd(1417:8760)=u2(1:7344); %Mar-Dec
        
        v2jd(1:1416)=v2(7345:8760); %Jan-Feb
        v2jd(1417:8760)=v2(1:7344); %Mar-Dec
        
        u10jd(1:1416)=u10(7345:8760); %Jan-Feb
        u10jd(1417:8760)=u10(1:7344); %Mar-Dec
        
        v10jd(1:1416)=v10(7345:8760); %Jan-Feb
        v10jd(1417:8760)=v10(1:7344); %Mar-Dec
        
        u50jd(1:1416)=u50(7345:8760); %Jan-Feb
        u50jd(1417:8760)=u50(1:7344); %Mar-Dec
        
        v50jd(1:1416)=v50(7345:8760); %Jan-Feb
        v50jd(1417:8760)=v50(1:7344); %Mar-Dec
        
        ws2jd(1:1416)=ws2(7345:8760); %Jan-Feb
        ws2jd(1417:8760)=ws2(1:7344); %Mar-Dec
        
        ws10jd(1:1416)=ws10(7345:8760); %Jan-Feb
        ws10jd(1417:8760)=ws10(1:7344); %Mar-Dec
        
        ws50jd(1:1416)=ws50(7345:8760); %Jan-Feb
        ws50jd(1417:8760)=ws50(1:7344); %Mar-Dec
        
        windDataUV=[u2jd' v2jd' u10jd' v10jd' u50jd' v50jd'];
        windDataWS=[ws2jd' ws10jd' ws50jd'];

        disp('Writing converted data...')
        xlswrite('C:\Users\RAJAT\Documents\MATLAB\IOFiles\MERRAio\NIWERE\REniwe.xlsx', windDataUV, 'UV', 'K6:P8765');
        xlswrite('C:\Users\RAJAT\Documents\MATLAB\IOFiles\MERRAio\NIWERE\REniwe.xlsx', windDataWS, 'WS', 'D6:F8765');
    case 2
        %% Convert yearly data to daily averages
        disp('Now reading reanalysis wind speed data...')
        windData=xlsread('C:\Users\RAJAT\Documents\MATLAB\IOFiles\MERRAio\NIWERE\REniwe.xlsx', 'WS', 'D6:F8765');
        ws2=windData(:,1);
        ws10=windData(:,2);
        ws50=windData(:,3); 

        ws2dav=zeros(365,1);ws10dav=zeros(365,1);ws50dav=zeros(365,1);
        for i=1:365
            ws2dav(i)=sum(ws2((24*(i-1)+1):(24*i)))/24;
            ws10dav(i)=sum(ws10((24*(i-1)+1):(24*i)))/24;
            ws50dav(i)=sum(ws50((24*(i-1)+1):(24*i)))/24;
        end
        
        windDataDA=[ws2dav ws10dav ws50dav];
        
        disp('Now writing reanalysis daily average data...')
        xlswrite('C:\Users\RAJAT\Documents\MATLAB\IOFiles\MERRAio\NIWERE\REniwe.xlsx', windDataDA, 'WS', 'H6:J370');        
    
    case 3
        %% Convert to monthly data
        hChoice=input('Enter choice (1- 2M, 2-10M, 3-50M) -->');
        switch(hChoice)
            case 1
                inCol='D6:D8765';
                oSheet='WSm2';
            case 2
                inCol='E6:E8765';
                oSheet='WSm10';
            case 3
                inCol='F6:F8765';
                oSheet='WSm50';
        end
        disp('Now reading reanalysis wind speed data...')
        windData=xlsread('C:\Users\RAJAT\Documents\MATLAB\IOFiles\MERRAio\NIWERE\REniwe.xlsx', 'WS', inCol);        
        windMon=zeros(744,12);
        monDay=[31 28 31 30 31 30 31 31 30 31 30 31];
        totH=0;
        for i=1:12
            currH=totH+monDay(i)*24;
            windMon(1:monDay(i)*24,i)=windData((totH+1):currH);
            totH=currH;
        end
        disp('Now writing monthly data...')
        xlswrite('C:\Users\RAJAT\Documents\MATLAB\IOFiles\MERRAio\NIWERE\REniwe.xlsx', windMon, oSheet, 'C6:N749');
    case 4
        %% Convert monthly data to daily averages
        hChoice=input('Enter choice (1- 2M, 2-10M, 3-50M) -->');
        switch(hChoice)
            case 1                
                oSheet='WSm2';
            case 2
                oSheet='WSm10';
            case 3
                oSheet='WSm50';
        end
        disp('Now reading reanalysis wind speed monthly data...')
        windData=xlsread('C:\Users\RAJAT\Documents\MATLAB\IOFiles\MERRAio\NIWERE\REniwe.xlsx', oSheet, 'C6:N749');
        wsMdav=zeros(31,12);
        monDay=[31 28 31 30 31 30 31 31 30 31 30 31];
        for mon=1:12
            for i=1:monDay(mon)
                wsMdav(i,mon)=sum(windData((24*(i-1)+1):(24*i),mon))/24;
            end
        end
        %wsMdav
        disp('Now writing daily averages of monthly data...')
        xlswrite('C:\Users\RAJAT\Documents\MATLAB\IOFiles\MERRAio\NIWERE\REniwe.xlsx', wsMdav, oSheet, 'Q6:AB36');
    case 5
        %% Convert to seasonal data
        hChoice=input('Enter choice (1- 2M, 2-10M, 3-50M) -->');
        switch(hChoice)
            case 1
                inCol='D6:D8765';
                oSheet='WSs2';
            case 2
                inCol='E6:E8765';
                oSheet='WSs10';
            case 3
                inCol='F6:F8765';
                oSheet='WSs50';
        end
        disp('Now reading reanalysis wind speed data...')
        windData=xlsread('C:\Users\RAJAT\Documents\MATLAB\IOFiles\MERRAio\NIWERE\REniwe.xlsx', 'WS', inCol);
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
        xlswrite('C:\Users\RAJAT\Documents\MATLAB\IOFiles\MERRAio\NIWERE\REniwe.xlsx', windSea, oSheet, 'C6:F2213');
        
    case 6 
        %% Convert seasonal data to daily averages    
        hChoice=input('Enter choice (1- 2M, 2-10M, 3-50M) -->');
        switch(hChoice)
            case 1                
                oSheet='WSs2';
            case 2
                oSheet='WSs10';
            case 3
                oSheet='WSs50';
        end
        disp('Now reading reanalysis wind speed seasonal data...')
        windData=xlsread('C:\Users\RAJAT\Documents\MATLAB\IOFiles\MERRAio\NIWERE\REniwe.xlsx', oSheet, 'C6:F2213');
        wsSdav=zeros(92,12);
        seaDay=[31+31+28 31+30+31 30+31+31 30+31+30];
        for sea=1:4
            for i=1:seaDay(sea)
                wsSdav(i,sea)=sum(windData((24*(i-1)+1):(24*i),sea))/24;
            end
        end
        %wsMdav
        disp('Now writing daily averages of seasonal data...')
        xlswrite('C:\Users\RAJAT\Documents\MATLAB\IOFiles\MERRAio\NIWERE\REniwe.xlsx', wsSdav, oSheet, 'H6:K97');
end

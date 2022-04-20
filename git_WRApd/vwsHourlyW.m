%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This programs converts 5/10-min average weather variables to hourly/daily averages
% This data was obtained from a Vantage Vue Weather Station installed in 
% the premises of VSSUT Burla. WeatherLink DataLogger is used. 
% @Author: Rajat Kanti Samal, This Version Date. 01-May-2020. 
% VWS data column information; 6-Wind Speed; 
% 1-Out Temperature; 4-Out Humidity; 5-Dew Point; 
% 14-Pressure; 24-Air Density

clc;

maxminY=zeros(12,6);%10min,hourly,daily min max
tenminAv=zeros(744*6,12);
hourlyAv=zeros(744,12); %744 hours for 12 months
dailyAv=zeros(31,12); % 31 days for 12 months
hourly3Av=zeros(744/3,12);hourly6Av=zeros(744/6,12);hourly12Av=zeros(744/12,12);
windNZ10=zeros(31,12);windNZh=zeros(31,12);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%JANUARY%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
monID=1;totD=31;totH=totD*24;
disp('Now reading Jan wind speed data...')
JanData=xlsread('C:\Users\Rajat\Documents\MATLAB\IOFiles\WRAV\WindData-VSSUT-17Q1.xlsx', 'Jan', 'D5:AE8932');
wind5Jan=JanData(:,24);
wind10Jan=zeros(4464,1);windHJan=zeros(744,1);windDJan=zeros(31,1);
%10-min averages
for i=1:4464
    wind10Jan(i)=sum(wind5Jan((2*(i-1)+1):(2*i)))/2; 
end
%Houly averages
for i=1:744    
    windHJan(i)=sum(wind10Jan((6*(i-1)+1):(6*i)))/6;        
end 
%Daily averages
for i=1:31
    windDJan(i)=sum(windHJan((24*(i-1)+1):(24*i)))/24;
end
maxminY(monID,:)=[min(wind10Jan) max(wind10Jan) min(windHJan) max(windHJan)...
    min(windDJan) max(windDJan)];
tenminAv(1:totH*6,monID)=wind10Jan;
hourlyAv(1:totH,monID)=windHJan;
dailyAv(1:totD,monID)=windDJan;

%%%%%%%%%%%%%% 3h, 6h and 12h averages
wind3HJan=zeros(totH/3,1);wind6HJan=zeros(totH/6,1);wind12HJan=zeros(totH/12,1);
% 3h averages
for i=1:totH/3
    wind3HJan(i)=sum(windHJan((3*(i-1)+1):(3*i)))/3;
end
% 6h averages
for i=1:totH/6
    wind6HJan(i)=sum(windHJan((6*(i-1)+1):(6*i)))/6;
end
% 12h averages
for i=1:(totH/12)
    wind12HJan(i)=sum(windHJan((12*(i-1)+1):(12*i)))/12;
end
hourly3Av(1:totH/3,monID)=wind3HJan;
hourly6Av(1:totH/6,monID)=wind6HJan;
hourly12Av(1:totH/12,monID)=wind12HJan;


%%%%%%%%%%%%%Non zero counts
[ monNZ ] = nzCountfn( wind10Jan,windHJan,totD );
windNZ10(1:totD,monID)=monNZ(:,1);
windNZh(1:totD,monID)=monNZ(:,2);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%FEBRUARY%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
monID=2;totD=28;totH=totD*24;
disp('Now reading Feb wind speed data...')
FebData=xlsread('C:\Users\Rajat\Documents\MATLAB\IOFiles\WRAV\WindData-VSSUT-17Q1.xlsx', 'Feb', 'D5:AE8068');
wind5Feb=FebData(:,24);
wind10Feb=zeros(4032,1);windHFeb=zeros(672,1);windDFeb=zeros(28,1);
%10-min averages
for i=1:4032
    wind10Feb(i)=sum(wind5Feb((2*(i-1)+1):(2*i)))/2; 
end
%Hourly averages
for i=1:672    
    windHFeb(i)=sum(wind10Feb((6*(i-1)+1):(6*i)))/6;        
end 
%Daily averages
for i=1:28
    windDFeb(i)=sum(windHFeb((24*(i-1)+1):(24*i)))/24;
end
maxminY(monID,:)=[min(wind10Feb) max(wind10Feb) min(windHFeb) max(windHFeb)...
         min(windDFeb) max(windDFeb)];
tenminAv(1:totH*6,monID)=wind10Feb;
hourlyAv(1:totH,monID)=windHFeb;
dailyAv(1:totD,monID)=windDFeb;

%%%%%%%%%%%%%% 3h, 6h and 12h averages
wind3HFeb=zeros(totH/3,1);wind6HFeb=zeros(totH/6,1);wind12HFeb=zeros(totH/12,1);
% 3h averages
for i=1:totH/3
    wind3HFeb(i)=sum(windHFeb((3*(i-1)+1):(3*i)))/3;
end
% 6h averages
for i=1:totH/6
    wind6HFeb(i)=sum(windHFeb((6*(i-1)+1):(6*i)))/6;
end
% 12h averages
for i=1:(totH/12)
    wind12HFeb(i)=sum(windHFeb((12*(i-1)+1):(12*i)))/12;
end
hourly3Av(1:totH/3,monID)=wind3HFeb;
hourly6Av(1:totH/6,monID)=wind6HFeb;
hourly12Av(1:totH/12,monID)=wind12HFeb;

%%%%%%%%%%%%%Non zero counts
[ monNZ ] = nzCountfn( wind10Feb,windHFeb,totD );
windNZ10(1:totD,monID)=monNZ(:,1);
windNZh(1:totD,monID)=monNZ(:,2);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%MARCH%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
monID=3;totD=31;totH=totD*24;
disp('Now reading Mar wind speed data...')
MarData=xlsread('C:\Users\Rajat\Documents\MATLAB\IOFiles\WRAV\WindData-VSSUT-17Q1.xlsx', 'Mar', 'D5:AE8932');
wind5Mar=MarData(:,24);
wind10Mar=zeros(4464,1);windHMar=zeros(744,1);windDMar=zeros(31,1);
%10-min averages
for i=1:4464
    wind10Mar(i)=sum(wind5Mar((2*(i-1)+1):(2*i)))/2; 
end
%Hourly averages
for i=1:744    
    windHMar(i)=sum(wind10Mar((6*(i-1)+1):(6*i)))/6;        
end 
%Daily averages
for i=1:31
    windDMar(i)=sum(windHMar((24*(i-1)+1):(24*i)))/24;
end
maxminY(monID,:)=[min(wind10Mar) max(wind10Mar) min(windHMar) max(windHMar)...
         min(windDMar) max(windDMar)];
tenminAv(1:totH*6,monID)=wind10Mar;
hourlyAv(1:totH,monID)=windHMar;
dailyAv(1:totD,monID)=windDMar;

%%%%%%%%%%%%%% 3h, 6h and 12h averages
wind3HMar=zeros(totH/3,1);wind6HMar=zeros(totH/6,1);wind12HMar=zeros(totH/12,1);
% 3h averages
for i=1:totH/3
    wind3HMar(i)=sum(windHMar((3*(i-1)+1):(3*i)))/3;
end
% 6h averages
for i=1:totH/6
    wind6HMar(i)=sum(windHMar((6*(i-1)+1):(6*i)))/6;
end
% 12h averages
for i=1:(totH/12)
    wind12HMar(i)=sum(windHMar((12*(i-1)+1):(12*i)))/12;
end
hourly3Av(1:totH/3,monID)=wind3HMar;
hourly6Av(1:totH/6,monID)=wind6HMar;
hourly12Av(1:totH/12,monID)=wind12HMar;

%%%%%%%%%%%%%Non zero counts
[ monNZ ] = nzCountfn( wind10Mar,windHMar,totD );
windNZ10(1:totD,monID)=monNZ(:,1);
windNZh(1:totD,monID)=monNZ(:,2);


%%%%%%%%%%%%%%%%%%%%%%%%%APRIL%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
monID=4;totD=30;totH=totD*24;
disp('Now reading Apr wind speed data...')
AprData=xlsread('C:\Users\Rajat\Documents\MATLAB\IOFiles\WRAV\WindData-VSSUT-17Q2.xlsx', 'Apr', 'D5:AE8644');
wind5Apr=AprData(:,24);wind10Apr=zeros(4320,1);
windHApr=zeros(720,1);windDApr=zeros(30,1);
size(wind5Apr,1);
%10 min averages
for i=1:4320 %720*6   
    wind10Apr(i)=sum(wind5Apr((2*(i-1)+1):(2*i)))/2;        
end 
%hourly averages
for i=1:720    
    windHApr(i)=sum(wind10Apr((6*(i-1)+1):(6*i)))/6;        
end 
%daily averages
for i=1:30
    windDApr(i)=sum(windHApr((24*(i-1)+1):(24*i)))/24;
end
%Min Max wind speeds
maxminY(monID,:)=[min(wind10Apr) max(wind10Apr) min(windHApr) max(windHApr)...
         min(windDApr) max(windDApr)];
tenminAv(1:totH*6,monID)=wind10Apr;
hourlyAv(1:totH,monID)=windHApr;
dailyAv(1:totD,monID)=windDApr;

%%%%%%%%%%%%%% 3h, 6h and 12h averages
wind3HApr=zeros(totH/3,1);wind6HApr=zeros(totH/6,1);wind12HApr=zeros(totH/12,1);
% 3h averages
for i=1:totH/3
    wind3HApr(i)=sum(windHApr((3*(i-1)+1):(3*i)))/3;
end
% 6h averages
for i=1:totH/6
    wind6HApr(i)=sum(windHApr((6*(i-1)+1):(6*i)))/6;
end
% 12h averages
for i=1:(totH/12)
    wind12HApr(i)=sum(windHApr((12*(i-1)+1):(12*i)))/12;
end
hourly3Av(1:totH/3,monID)=wind3HApr;
hourly6Av(1:totH/6,monID)=wind6HApr;
hourly12Av(1:totH/12,monID)=wind12HApr;

%%%%%%%%%%%%%Non zero counts
[ monNZ ] = nzCountfn( wind10Apr,windHApr,totD );
windNZ10(1:totD,monID)=monNZ(:,1);
windNZh(1:totD,monID)=monNZ(:,2);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%MAY%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
monID=5;totD=31;totH=totD*24;
%Data avaialble for both 5-min (D5:D4192) and 10-min averages 
%349+395=744
%Data Lost from 25-May-2017 11:50 am to 28-05-2017 4 pm
%This is replaced by 21-May-2017 11:50 am to 24-May-2017 4 pm
disp('Now reading May wind speed data...')
MayData=xlsread('C:\Users\Rajat\Documents\MATLAB\IOFiles\WRAV\WindData-VSSUT-17Q2.xlsx', 'May', 'D5:AE6562');
MayData1=MayData(1:4188,:);%4188/12=349 hours
MayData2=MayData(4189:6558,:);%2370/6=395 hours
wind5May=MayData1(:,24);wind10MayO=MayData2(:,24);
wind10May=zeros(4464,1);windHMay=zeros(744,1);windDMay=zeros(31,1);
%%%% 349 hours of 5 min averages and 395 hours of 10 min averages
% 10 min averages
for i=1:2094 %349*6
    wind10May(i)=sum(wind5May((2*(i-1)+1):(2*i)))/2;        
end 
for i=2095:4464
    wind10May(i)=wind10MayO(i-2094);
end
% Hourly averages
for i=1:744 
    windHMay(i)=sum(wind10May((6*(i-1)+1):(6*i)))/6;        
end 
% Daily averages
for i=1:31
    windDMay(i)=sum(windHMay((24*(i-1)+1):(24*i)))/24;
end
%Min Max wind speeds
maxminY(monID,:)=[min(wind10May) max(wind10May) min(windHMay) max(windHMay)...
         min(windDMay) max(windDMay)];
tenminAv(1:totH*6,monID)=wind10May;
hourlyAv(1:totH,monID)=windHMay;
dailyAv(1:totD,monID)=windDMay;

%%%%%%%%%%%%%% 3h, 6h and 12h averages
wind3HMay=zeros(totH/3,1);wind6HMay=zeros(totH/6,1);wind12HMay=zeros(totH/12,1);
% 3h averages
for i=1:totH/3
    wind3HMay(i)=sum(windHMay((3*(i-1)+1):(3*i)))/3;
end
% 6h averages
for i=1:totH/6
    wind6HMay(i)=sum(windHMay((6*(i-1)+1):(6*i)))/6;
end
% 12h averages
for i=1:(totH/12)
    wind12HMay(i)=sum(windHMay((12*(i-1)+1):(12*i)))/12;
end
hourly3Av(1:totH/3,monID)=wind3HMay;
hourly6Av(1:totH/6,monID)=wind6HMay;
hourly12Av(1:totH/12,monID)=wind12HMay;

%%%%%%%%%%%%%Non zero counts
[ monNZ ] = nzCountfn( wind10May,windHMay,totD );
windNZ10(1:totD,monID)=monNZ(:,1);
windNZh(1:totD,monID)=monNZ(:,2);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% JUNE %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
monID=6;totD=30;totH=totD*24;
disp('Now reading June wind speed data...')
JuneData=xlsread('C:\Users\Rajat\Documents\MATLAB\IOFiles\WRAV\WindData-VSSUT-17Q2.xlsx', 'June', 'D5:AE4324');
windHJune=zeros(720,1);windDJune=zeros(30,1);
% 10 min averages
wind10June=JuneData(:,24);
% hourly averages
for i=1:720    
    windHJune(i)=sum(wind10June((6*(i-1)+1):(6*i)))/6;        
end 
% daily averages
for i=1:30
    windDJune(i)=sum(windHJune((24*(i-1)+1):(24*i)))/24;
end
% Min Max 
maxminY(monID,:)=[min(wind10June) max(wind10June) min(windHJune) max(windHJune)...
         min(windDJune) max(windDJune)];
tenminAv(1:totH*6,monID)=wind10June;
hourlyAv(1:totH,monID)=windHJune;
dailyAv(1:totD,monID)=windDJune;

%%%%%%%%%%%%%% 3h, 6h and 12h averages
wind3HJune=zeros(totH/3,1);wind6HJune=zeros(totH/6,1);wind12HJune=zeros(totH/12,1);
% 3h averages
for i=1:totH/3
    wind3HJune(i)=sum(windHJune((3*(i-1)+1):(3*i)))/3;
end
% 6h averages
for i=1:totH/6
    wind6HJune(i)=sum(windHJune((6*(i-1)+1):(6*i)))/6;
end
% 12h averages
for i=1:(totH/12)
    wind12HJune(i)=sum(windHJune((12*(i-1)+1):(12*i)))/12;
end
hourly3Av(1:totH/3,monID)=wind3HJune;
hourly6Av(1:totH/6,monID)=wind6HJune;
hourly12Av(1:totH/12,monID)=wind12HJune;

%%%%%%%%%%%%%Non zero counts
[ monNZ ] = nzCountfn( wind10June,windHJune,totD );
windNZ10(1:totD,monID)=monNZ(:,1);
windNZh(1:totD,monID)=monNZ(:,2);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% JULY %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
monID=7;totD=31;totH=totD*24;
disp('Now reading July wind speed data...')
JulyData=xlsread('C:\Users\Rajat\Documents\MATLAB\IOFiles\WRAV\WindData-VSSUT-17Q3.xlsx', 'July', 'D5:AE4468');
windHJuly=zeros(744,1);windDJuly=zeros(31,1);
% 10 minute averages
wind10July=JulyData(:,24);
% Hourly averages
for i=1:744    
    windHJuly(i)=sum(wind10July((6*(i-1)+1):(6*i)))/6;        
end 
% Daily averages
for i=1:31
    windDJuly(i)=sum(windHJuly((24*(i-1)+1):(24*i)))/24;
end
% Min Max
maxminY(monID,:)=[min(wind10July) max(wind10July) min(windHJuly) max(windHJuly)...
         min(windDJuly) max(windDJuly)];
tenminAv(1:totH*6,monID)=wind10July;
hourlyAv(1:totH,monID)=windHJuly;
dailyAv(1:totD,monID)=windDJuly;

%%%%%%%%%%%%%Non zero counts
[ monNZ ] = nzCountfn( wind10July,windHJuly,totD );
windNZ10(1:totD,monID)=monNZ(:,1);
windNZh(1:totD,monID)=monNZ(:,2);

%%%%%%%%%%%%%% 3h, 6h and 12h averages
wind3HJuly=zeros(totH/3,1);wind6HJuly=zeros(totH/6,1);wind12HJuly=zeros(totH/12,1);
% 3h averages
for i=1:totH/3
    wind3HJuly(i)=sum(windHJuly((3*(i-1)+1):(3*i)))/3;
end
% 6h averages
for i=1:totH/6
    wind6HJuly(i)=sum(windHJuly((6*(i-1)+1):(6*i)))/6;
end
% 12h averages
for i=1:(totH/12)
    wind12HJuly(i)=sum(windHJuly((12*(i-1)+1):(12*i)))/12;
end
hourly3Av(1:totH/3,monID)=wind3HJuly;
hourly6Av(1:totH/6,monID)=wind6HJuly;
hourly12Av(1:totH/12,monID)=wind12HJuly;

%%%%%%%%%%%%%Non zero counts
[ monNZ ] = nzCountfn( wind10July,windHJuly,totD );
windNZ10(1:totD,monID)=monNZ(:,1);
windNZh(1:totD,monID)=monNZ(:,2);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% AUG %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
monID=8;totD=31;totH=totD*24;
disp('Now reading Aug wind speed data...')
AugData=xlsread('C:\Users\Rajat\Documents\MATLAB\IOFiles\WRAV\WindData-VSSUT-17Q3.xlsx', 'Aug', 'D5:AE4468');
windHAug=zeros(744,1);windDAug=zeros(31,1);
% 10 min averages
wind10Aug=AugData(:,24);
% Hourly averages
for i=1:744    
    windHAug(i)=sum(wind10Aug((6*(i-1)+1):(6*i)))/6;        
end 
% Daily averages
for i=1:31
    windDAug(i)=sum(windHAug((24*(i-1)+1):(24*i)))/24;
end
% Min Max
maxminY(monID,:)=[min(wind10Aug) max(wind10Aug) min(windHAug) max(windHAug)...
         min(windDAug) max(windDAug)];
tenminAv(1:totH*6,monID)=wind10Aug;
hourlyAv(1:totH,monID)=windHAug;
dailyAv(1:totD,monID)=windDAug;

%%%%%%%%%%%%%% 3h, 6h and 12h averages
wind3HAug=zeros(totH/3,1);wind6HAug=zeros(totH/6,1);wind12HAug=zeros(totH/12,1);
% 3h averages
for i=1:totH/3
    wind3HAug(i)=sum(windHAug((3*(i-1)+1):(3*i)))/3;
end
% 6h averages
for i=1:totH/6
    wind6HAug(i)=sum(windHAug((6*(i-1)+1):(6*i)))/6;
end
% 12h averages
for i=1:(totH/12)
    wind12HAug(i)=sum(windHAug((12*(i-1)+1):(12*i)))/12;
end
hourly3Av(1:totH/3,monID)=wind3HAug;
hourly6Av(1:totH/6,monID)=wind6HAug;
hourly12Av(1:totH/12,monID)=wind12HAug;

%%%%%%%%%%%%%Non zero counts
[ monNZ ] = nzCountfn( wind10Aug,windHAug,totD );
windNZ10(1:totD,monID)=monNZ(:,1);
windNZh(1:totD,monID)=monNZ(:,2);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% SEPTEMBER %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
monID=9;totD=30;totH=totD*24;
disp('Now reading Sep wind speed data...')
SepData=xlsread('C:\Users\Rajat\Documents\MATLAB\IOFiles\WRAV\WindData-VSSUT-17Q3.xlsx', 'Sep', 'D5:AE4324');
windHSep=zeros(720,1);windDSep=zeros(30,1);
% 10 min averages
wind10Sep=SepData(:,24);
% hourly averages
for i=1:720    
    windHSep(i)=sum(wind10Sep((6*(i-1)+1):(6*i)))/6;        
end 
% daily averages
for i=1:30
    windDSep(i)=sum(windHSep((24*(i-1)+1):(24*i)))/24;
end
% Min Max
maxminY(monID,:)=[min(wind10Sep) max(wind10Sep) min(windHSep) max(windHSep)...
         min(windDSep) max(windDSep)];
tenminAv(1:totH*6,monID)=wind10Sep;
hourlyAv(1:totH,monID)=windHSep;
dailyAv(1:totD,monID)=windDSep;

%%%%%%%%%%%%%% 3h, 6h and 12h averages
wind3HSep=zeros(totH/3,1);wind6HSep=zeros(totH/6,1);wind12HSep=zeros(totH/12,1);
% 3h averages
for i=1:totH/3
    wind3HSep(i)=sum(windHSep((3*(i-1)+1):(3*i)))/3;
end
% 6h averages
for i=1:totH/6
    wind6HSep(i)=sum(windHSep((6*(i-1)+1):(6*i)))/6;
end
% 12h averages
for i=1:(totH/12)
    wind12HSep(i)=sum(windHSep((12*(i-1)+1):(12*i)))/12;
end
hourly3Av(1:totH/3,monID)=wind3HSep;
hourly6Av(1:totH/6,monID)=wind6HSep;
hourly12Av(1:totH/12,monID)=wind12HSep;

%%%%%%%%%%%%%Non zero counts
[ monNZ ] = nzCountfn( wind10Sep,windHSep,totD );
windNZ10(1:totD,monID)=monNZ(:,1);
windNZh(1:totD,monID)=monNZ(:,2);


%%%%%%%%%%%%%%%%%%%%%%%%%% OCTOBER %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
monID=10;totD=31;totH=totD*24;
disp('Now reading Oct wind speed data...')
OctData=xlsread('C:\Users\Rajat\Documents\MATLAB\IOFiles\WRAV\WindData-VSSUT-Current.xlsx', 'Oct', 'D5:AE4468');
windHOct=zeros(744,1);windDOct=zeros(31,1);
% 10 min averages
wind10Oct=OctData(:,24);
% Hourly averages
for i=1:744    
    windHOct(i)=sum(wind10Oct((6*(i-1)+1):(6*i)))/6;        
end 
% Daily averages
for i=1:31
    windDOct(i)=sum(windHOct((24*(i-1)+1):(24*i)))/24;
end
% Min Max
maxminY(monID,:)=[min(wind10Oct) max(wind10Oct) min(windHOct) max(windHOct)...
         min(windDOct) max(windDOct)];
tenminAv(1:totH*6,monID)=wind10Oct;
hourlyAv(1:totH,monID)=windHOct;
dailyAv(1:totD,monID)=windDOct;

%%%%%%%%%%%%%% 3h, 6h and 12h averages
wind3HOct=zeros(totH/3,1);wind6HOct=zeros(totH/6,1);wind12HOct=zeros(totH/12,1);
% 3h averages
for i=1:totH/3
    wind3HOct(i)=sum(windHOct((3*(i-1)+1):(3*i)))/3;
end
% 6h averages
for i=1:totH/6
    wind6HOct(i)=sum(windHOct((6*(i-1)+1):(6*i)))/6;
end
% 12h averages
for i=1:(totH/12)
    wind12HOct(i)=sum(windHOct((12*(i-1)+1):(12*i)))/12;
end
hourly3Av(1:totH/3,monID)=wind3HOct;
hourly6Av(1:totH/6,monID)=wind6HOct;
hourly12Av(1:totH/12,monID)=wind12HOct;

%%%%%%%%%%%%%Non zero counts
[ monNZ ] = nzCountfn( wind10Oct,windHOct,totD );
windNZ10(1:totD,monID)=monNZ(:,1);
windNZh(1:totD,monID)=monNZ(:,2);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% NOVEMBER %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
monID=11;totD=30;totH=totD*24;
disp('Now reading Nov wind speed data...')
NovData=xlsread('C:\Users\Rajat\Documents\MATLAB\IOFiles\WRAV\WindData-VSSUT-Current.xlsx', 'Nov', 'D5:AE4324');
windHNov=zeros(720,1);windDNov=zeros(30,1);
% 10 min averages
wind10Nov=NovData(:,24);
% Hourly averages
for i=1:720    
    windHNov(i)=sum(wind10Nov((6*(i-1)+1):(6*i)))/6;        
end 
% Daily averages
for i=1:30
    windDNov(i)=sum(windHNov((24*(i-1)+1):(24*i)))/24;
end
% Min Max
maxminY(monID,:)=[min(wind10Nov) max(wind10Nov) min(windHNov) max(windHNov)...
         min(windDNov) max(windDNov)];
tenminAv(1:totH*6,monID)=wind10Nov;
hourlyAv(1:totH,monID)=windHNov;
dailyAv(1:totD,monID)=windDNov;

%%%%%%%%%%%%%% 3h, 6h and 12h averages
wind3HNov=zeros(totH/3,1);wind6HNov=zeros(totH/6,1);wind12HNov=zeros(totH/12,1);
% 3h averages
for i=1:totH/3
    wind3HNov(i)=sum(windHNov((3*(i-1)+1):(3*i)))/3;
end
% 6h averages
for i=1:totH/6
    wind6HNov(i)=sum(windHNov((6*(i-1)+1):(6*i)))/6;
end
% 12h averages
for i=1:(totH/12)
    wind12HNov(i)=sum(windHNov((12*(i-1)+1):(12*i)))/12;
end
hourly3Av(1:totH/3,monID)=wind3HNov;
hourly6Av(1:totH/6,monID)=wind6HNov;
hourly12Av(1:totH/12,monID)=wind12HNov;

%%%%%%%%%%%%%Non zero counts
[ monNZ ] = nzCountfn( wind10Nov,windHNov,totD );
windNZ10(1:totD,monID)=monNZ(:,1);
windNZh(1:totD,monID)=monNZ(:,2);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% DECEMBER %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
monID=12;totD=31;totH=totD*24;
%Data avaialble for both 10-min (D5:D3850) and 5-min (D3851:D5086) averages 
disp('Now reading Dec wind speed data...')
DecData=xlsread('C:\Users\Rajat\Documents\MATLAB\IOFiles\WRAV\WindData-VSSUT-16Dec.xlsx', 'Dec', 'D5:AE5086');
DecData1=DecData(1:3846,:);%3846/6=641 hours
DecData2=DecData(3847:5082,:);%1236/12=103 hours
wind10DecO=DecData1(:,24);wind5Dec=DecData2(:,24);
wind10Dec=zeros(4464,1);windHDec=zeros(744,1);windDDec=zeros(31,1);
% 10 min averages
for j=1:3846 %641*6    
    wind10Dec(j)=wind10DecO(j);         
end 
i=0;
for j=3847:4464 %744*6=4464
    i=i+1;
    wind10Dec(j)=sum(wind5Dec((2*(i-1)+1):(2*i)))/2;
end
% Hourly averages
for i=1:744        
    windHDec(i)=sum(wind10Dec((6*(i-1)+1):(6*i)))/6;
end 
% Daily averages
for i=1:31
    windDDec(i)=sum(windHDec((24*(i-1)+1):(24*i)))/24;
end
% Min Max
maxminY(monID,:)=[min(wind10Dec) max(wind10Dec) min(windHDec) max(windHDec)...
         min(windDDec) max(windDDec)];
tenminAv(1:totH*6,monID)=wind10Dec;
hourlyAv(1:totH,monID)=windHDec;
dailyAv(1:totD,monID)=windDDec;

%%%%%%%%%%%%%% 3h, 6h and 12h averages
wind3HDec=zeros(totH/3,1);wind6HDec=zeros(totH/6,1);wind12HDec=zeros(totH/12,1);
% 3h averages
for i=1:totH/3
    wind3HDec(i)=sum(windHDec((3*(i-1)+1):(3*i)))/3;
end
% 6h averages
for i=1:totH/6
    wind6HDec(i)=sum(windHDec((6*(i-1)+1):(6*i)))/6;
end
% 12h averages
for i=1:(totH/12)
    wind12HDec(i)=sum(windHDec((12*(i-1)+1):(12*i)))/12;
end
hourly3Av(1:totH/3,monID)=wind3HDec;
hourly6Av(1:totH/6,monID)=wind6HDec;
hourly12Av(1:totH/12,monID)=wind12HDec;

%%%%%%%%%%%%%Non zero counts
[ monNZ ] = nzCountfn( wind10Dec,windHDec,totD );
windNZ10(1:totD,monID)=monNZ(:,1);
windNZh(1:totD,monID)=monNZ(:,2);

%%%%%%%%%%%%%%RESULTS FOR ALL THE MONTHS%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
disp('Now writing results...')

xlswrite('C:\Users\Rajat\Documents\MATLAB\IOFiles\ANNio\VWSden.xlsx', tenminAv, '10M', 'D6:O4494');
xlswrite('C:\Users\Rajat\Documents\MATLAB\IOFiles\ANNio\VWSden.xlsx', hourlyAv, 'Hourly', 'D6:O749');
xlswrite('C:\Users\Rajat\Documents\MATLAB\IOFiles\ANNio\VWSden.xlsx', dailyAv, 'Daily', 'D6:O36');

xlswrite('C:\Users\Rajat\Documents\MATLAB\IOFiles\ANNio\VWSden.xlsx', hourly3Av, 'H3', 'D6:O253');
xlswrite('C:\Users\Rajat\Documents\MATLAB\IOFiles\ANNio\VWSden.xlsx', hourly6Av, 'H6', 'D6:O129');
xlswrite('C:\Users\Rajat\Documents\MATLAB\IOFiles\ANNio\VWSden.xlsx', hourly12Av, 'H12', 'D6:O67');

xlswrite('C:\Users\Rajat\Documents\MATLAB\IOFiles\ANNio\VWSden.xlsx', maxminY, 'MinMax', 'D6:I17');
% xlswrite('C:\Users\Rajat\Documents\MATLAB\IOFiles\WRAV\WRAVres.xlsx', windNZ10, 'NZ', 'D6:O36');
% xlswrite('C:\Users\Rajat\Documents\MATLAB\IOFiles\WRAV\WRAVres.xlsx', windNZh, 'NZ', 'Q6:AB36');













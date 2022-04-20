function niwePlotDistSfn(summer,rainy,autumn,winter)
%% This function plots the frequency histogram and fitted distributions
% for NIWE data
%@Author: Rajat Kanti Samal, Date: 03-June-2020



%% Frequency distribution 
% datacount=size(summer,1);
% [maxClass,class,noOfHours,frequency,cumuFreq,midClassSpeed,averageClassSpeed]=niweFreqDistFn(summer,datacount);
% histogram(windData,'Normalization','probability');

%% Read parameters of the marginal distributions
disp('Now reading parameters of marginal distributions of seasonal data...')
paramsAll=xlsread('C:\Users\RAJAT\Documents\MATLAB\IOFiles\NIWEio\NIWEres.xlsx', 'distS', 'C6:D25');
paramsAll2=xlsread('C:\Users\RAJAT\Documents\MATLAB\IOFiles\NIWEio\NIWEres.xlsx', 'distS2', 'C6:E25');
disp('Now reading parameters of mixture distributions of seasonal data...')
paramsMix=xlsread('C:\Users\RAJAT\Documents\MATLAB\IOFiles\NIWEio\NIWEresMix.xlsx', 'distS', 'C6:G24');

%% Marginal distributions for Summer
maxD=max(summer);
xS=0:0.1:maxD;
kEV=paramsAll2(5,1);sigmaEV=paramsAll2(5,2);muEV=paramsAll2(5,3); % Generalized Extreme Value
pd = makedist('GeneralizedExtremeValue','k',kEV,'sigma',sigmaEV,'mu',muEV);
pdf_EVS=pdf(pd,xS);

%% Marginal distributions for Rainy
maxD=max(rainy);
xR=0:0.1:maxD;
k=paramsAll(6,1);c=paramsAll(6,2); % Weibull
pd = makedist('Weibull','a',c,'b',k);
pdf_WR=pdf(pd,xR);
muNk=paramsAll2(9,1);omega=paramsAll2(9,2); % Nakagami
pd = makedist('Nakagami','mu',muNk,'omega',omega);
pdf_NkR=pdf(pd,xR);
kEV=paramsAll2(10,1);sigmaEV=paramsAll2(10,2);muEV=paramsAll2(10,3); % Generalized Extreme Value
pd = makedist('GeneralizedExtremeValue','k',kEV,'sigma',sigmaEV,'mu',muEV);
pdf_EVR=pdf(pd,xR);

%% Marginal distributions for Autumn
maxD=max(autumn);
xA=0:0.1:maxD;
muLL=paramsAll2(13,1);sigmaLL=paramsAll2(13,2); % Loglogistic
pd = makedist('Loglogistic','mu',muLL,'sigma',sigmaLL);
pdf_LLA=pdf(pd,xA);

%% Marginal Distributitions for Winter
maxD=max(autumn);
xW=0:0.1:maxD;
muN=paramsAll(20,1);sigmaN=paramsAll(20,2); % Normal
pd = makedist('Normal','mu',muN,'sigma',sigmaN);
pdf_NW=pdf(pd,xW);
muLo=paramsAll2(17,1);sigmaLo=paramsAll2(17,2); % Logistic
pd = makedist('Logistic','mu',muLo,'sigma',sigmaLo);
pdf_LoW=pdf(pd,xW);

%% Define mixture distributions as anonymous functions
pdf_WW = @(x,p,c1,k1,c2,k2) ...
                         p*wblpdf(x,c1,k1) + (1-p)*wblpdf(x,c2,k2);
pdf_GW = @(x,p,c1,k1,c2,k2) ...
                         p*wblpdf(x,c1,k1) + (1-p)*gampdf(x,k2,c2);
xTrunc = 0; 
pdf_TNW = @(x,p,c,k,mu,sigma) ...
                         p*wblpdf(x,c,k) + (1-p)*(normpdf(x,mu,sigma) ./ (1-normcdf(xTrunc,mu,sigma)));
pdf_TNTN = @(x,p,mu1,sigma1,mu2,sigma2) ...
                         p*(normpdf(x,mu1,sigma1) ./ (1-normcdf(xTrunc,mu1,sigma1)))...
                         + (1-p)*(normpdf(x,mu2,sigma2) ./ (1-normcdf(xTrunc,mu2,sigma2)));
                     
%% Calculate PDF values for plotting
% Summer
xS2 = xS(xS > xTrunc);
pdf_TNWvalS=pdf_TNW(xS2,paramsMix(3,1),paramsMix(3,2),paramsMix(3,3),paramsMix(3,4),paramsMix(3,5));
% Rainy
xR2 = xR(xR > xTrunc);
pdf_TNWvalR=pdf_TNW(xR2,paramsMix(8,1),paramsMix(8,2),paramsMix(8,3),paramsMix(8,4),paramsMix(8,5));
% Autumn
pdf_WWvalA=pdf_WW(xA,paramsMix(11,1),paramsMix(11,2),paramsMix(11,3),paramsMix(11,4),paramsMix(11,5));
pdf_GWvalA=pdf_GW(xA,paramsMix(12,1),paramsMix(12,2),paramsMix(12,3),paramsMix(12,4),paramsMix(12,5));
% Winter
pdf_WWvalW=pdf_WW(xW,paramsMix(16,1),paramsMix(16,2),paramsMix(16,3),paramsMix(16,4),paramsMix(16,5));
pdf_GWvalW=pdf_GW(xW,paramsMix(17,1),paramsMix(17,2),paramsMix(17,3),paramsMix(17,4),paramsMix(17,5));
xW2 = xW(xW > xTrunc);
pdf_TNWvalW=pdf_TNW(xW2,paramsMix(18,1),paramsMix(18,2),paramsMix(18,3),paramsMix(18,4),paramsMix(18,5));

%% Plot distributions   
figure(1)
datacount=size(summer,1);
[maxClass,class,noOfHours,frequency,cumuFreq,midClassSpeed,averageClassSpeed]=niweFreqDistFn(summer,datacount);
bar(midClassSpeed,frequency);
hold all;
plot(xS,pdf_EVS,'-k','LineWidth',2)
plot(xS2,pdf_TNWvalS,'-og','LineWidth',2)
legend('Histogram','GEV','TNW','Orientation','Vertical')
ylabel('Probability','fontsize',12,'fontweight','b','color','k')
xlabel('Wind Speed(m/s)','fontsize',12,'fontweight','b','color','k')
title('Summer Season','fontsize',12,'fontweight','b','color','k')

figure(2)
datacount=size(rainy,1);
[maxClass,class,noOfHours,frequency,cumuFreq,midClassSpeed,averageClassSpeed]=niweFreqDistFn(rainy,datacount);
bar(midClassSpeed,frequency);
hold all;
plot(xR,pdf_WR,'-k','LineWidth',2)
plot(xR,pdf_NkR,'-og','LineWidth',2)
plot(xR,pdf_EVR,'--b','LineWidth',2)
plot(xR2,pdf_TNWvalR,'-+r','LineWidth',2)
legend('Histogram','Weibull','Nakagami','GEV','TNW','Orientation','Vertical')
ylabel('Probability','fontsize',12,'fontweight','b','color','k')
xlabel('Wind Speed(m/s)','fontsize',12,'fontweight','b','color','k')
title('Rainy Season','fontsize',12,'fontweight','b','color','k')

figure(3)
datacount=size(autumn,1);
[maxClass,class,noOfHours,frequency,cumuFreq,midClassSpeed,averageClassSpeed]=niweFreqDistFn(autumn,datacount);
bar(midClassSpeed,frequency);
hold all;
plot(xA,pdf_LLA,'-k','LineWidth',2)
plot(xA,pdf_WWvalA,'-og','LineWidth',2)
plot(xA,pdf_GWvalA,'--b','LineWidth',2)
legend('Histogram','Loglogistics','WW','GW','Orientation','Vertical')
ylabel('Probability','fontsize',12,'fontweight','b','color','k')
xlabel('Wind Speed(m/s)','fontsize',12,'fontweight','b','color','k')
title('Autumn Season','fontsize',12,'fontweight','b','color','k')

%subplot(2,2,4)
figure(4)
datacount=size(winter,1);
[maxClass,class,noOfHours,frequency,cumuFreq,midClassSpeed,averageClassSpeed]=niweFreqDistFn(winter,datacount);
bar(midClassSpeed,frequency);
hold all;
plot(xW,pdf_NW,'-k','LineWidth',2)
plot(xW,pdf_LoW,'-og','LineWidth',2)
plot(xW,pdf_WWvalW,'--b','LineWidth',2)
plot(xW,pdf_GWvalW,'-.r','LineWidth',2)
plot(xW2,pdf_TNWvalW,'-+y','LineWidth',2)
legend('Histogram','Normal','Logistics','WW','GW','TNW','Orientation','Vertical')
ylabel('Probability','fontsize',12,'fontweight','b','color','k')
xlabel('Wind Speed(m/s)','fontsize',12,'fontweight','b','color','k')
title('Winter Season','fontsize',12,'fontweight','b','color','k')










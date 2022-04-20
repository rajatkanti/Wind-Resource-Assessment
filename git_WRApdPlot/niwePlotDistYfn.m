function niwePlotDistYfn(windData)
%% This function plots the frequency histogram and fitted distributions
% for NIWE data
%@Author: Rajat Kanti Samal, Date: 03-June-2020



%% Frequency distribution 
datacount=size(windData,1);
[maxClass,class,noOfHours,frequency,cumuFreq,midClassSpeed,averageClassSpeed]=niweFreqDistFn(windData,datacount);
%histogram(windData,'Normalization','probability');

%% Read parameters of the marginal distributions
disp('Now reading parameters of marginal distributions of yearly data...')
paramsAll=xlsread('C:\Users\RAJAT\Documents\MATLAB\IOFiles\NIWEio\NIWEres.xlsx', 'distY', 'C6:E15');
k=paramsAll(1,1);c=paramsAll(1,2); % Weibull
a=paramsAll(2,1);b=paramsAll(2,2); % Gamma
muL=paramsAll(3,1);sigma=paramsAll(3,2); % Lognormal
muI=paramsAll(4,1);lambda=paramsAll(4,2); % Inverse Gaussian
muN=paramsAll(5,1);sigmaN=paramsAll(5,2); % Normal
beta=paramsAll(6,1);gamma=paramsAll(6,2); % Birnbaum Saunders
muLo=paramsAll(7,1);sigmaLo=paramsAll(7,2); % Logistic
muLL=paramsAll(8,1);sigmaLL=paramsAll(8,2); % Loglogistic
muNk=paramsAll(9,1);omega=paramsAll(9,2); % Nakagami
kEV=paramsAll(10,1);sigmaEV=paramsAll(10,2);muEV=paramsAll(10,3); % Generalized Extreme Value

%% Data range    
maxD=max(windData);
x=0:0.1:maxD;

%% Generate PDF
pd = makedist('Weibull','a',c,'b',k);
pdf_W=pdf(pd,x);
pd = makedist('Gamma','a',a,'b',b);
pdf_G=pdf(pd,x);
pd = makedist('Lognormal','mu',muL,'sigma',sigma);
pdf_L=pdf(pd,x);
pd = makedist('InverseGaussian','mu',muI,'lambda',lambda);
pdf_I=pdf(pd,x);
pd = makedist('Normal','mu',muN,'sigma',sigmaN);
pdf_N=pdf(pd,x);
pd = makedist('BirnbaumSaunders','beta',beta,'gamma',gamma);
pdf_BS=pdf(pd,x);
pd = makedist('Logistic','mu',muLo,'sigma',sigmaLo);
pdf_Lo=pdf(pd,x);
pd = makedist('Loglogistic','mu',muLL,'sigma',sigmaLL);
pdf_LL=pdf(pd,x);
pd = makedist('Nakagami','mu',muNk,'omega',omega);
pdf_Nk=pdf(pd,x);
pd = makedist('GeneralizedExtremeValue','k',kEV,'sigma',sigmaEV,'mu',muEV);
pdf_EV=pdf(pd,x);

%% Plot distributions   
figure(1)
bar(midClassSpeed,frequency);
hold all;
plot(x,pdf_W,'-k','LineWidth',2)
plot(x,pdf_G,'-og','LineWidth',2)
plot(x,pdf_L,'--b','LineWidth',2)
plot(x,pdf_I,'-.r','LineWidth',2)  
plot(x,pdf_N,'-+y','LineWidth',2)
legend('Histogram','Weibull','Gamma','Lognormal','Inv. Gaussian','Normal','Orientation','Vertical')
ylabel('Probability','fontsize',12,'fontweight','b','color','k')
xlabel('Wind Speed(m/s)','fontsize',12,'fontweight','b','color','k')
% title('Daily Averages (Year)')

figure(2)
bar(midClassSpeed,frequency);
hold all;
plot(x,pdf_BS,'-k','LineWidth',2)
plot(x,pdf_Lo,'-og','LineWidth',2)
plot(x,pdf_LL,'--b','LineWidth',2)
plot(x,pdf_Nk,'-.r','LineWidth',2)  
plot(x,pdf_EV,'-+y','LineWidth',2)
legend('Histogram','Birnbaum Saunders','Logistic','Loglogistic','Nakagami','Generalized EV','Orientation','Vertical')
ylabel('Probability','fontsize',12,'fontweight','b','color','k')
xlabel('Wind Speed(m/s)','fontsize',12,'fontweight','b','color','k')











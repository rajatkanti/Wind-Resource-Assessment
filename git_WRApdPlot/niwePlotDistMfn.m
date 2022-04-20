function niwePlotDistMfn(monData)
%% This function plots the frequency histogram and fitted distributions
% for NIWE data
%@Author: Rajat Kanti Samal, Date: 06-June-2020



%% Frequency distribution 
% datacount=size(summer,1);
% [maxClass,class,noOfHours,frequency,cumuFreq,midClassSpeed,averageClassSpeed]=niweFreqDistFn(summer,datacount);
% histogram(windData,'Normalization','probability');
totD=[31 28 31 30 31 30 31 31 30 31 30 31];
%% Read parameters of the marginal distributions
disp('Now reading parameters of marginal distributions of monthly data...')
paramsM=xlsread('C:\Users\RAJAT\Documents\MATLAB\IOFiles\NIWEio\NIWEres.xlsx', 'distM', 'C6:E65');
paramsM2=xlsread('C:\Users\RAJAT\Documents\MATLAB\IOFiles\NIWEio\NIWEres.xlsx', 'distM2', 'C6:E65');
disp('Now reading parameters of mixture distributions of monthly data...')
paramsMix=xlsread('C:\Users\RAJAT\Documents\MATLAB\IOFiles\NIWEio\NIWEresMix.xlsx', 'distM', 'C6:G64');

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

%% Distributions for Jan-Apr
figure(1)
for monID=1:4
    totH=totD(monID)*24;
    windDataM=monData(1:totH,monID);
    idx=(monID-1)*5; 
    % x-axis
    maxD=max(windDataM);
    x=0:0.1:maxD;
    %% Plot histogram    
    subplot(2,2,monID)
    datacount=size(windDataM,1);
    [maxClass,class,noOfHours,frequency,cumuFreq,midClassSpeed,averageClassSpeed]=niweFreqDistFn(windDataM,datacount);
    bar(midClassSpeed,frequency);
    hold all;
    %% Plot fitted distributions
    switch(monID)
        case 1 % TNTN
            x = x(x > xTrunc);
            pdf_TNTNval=pdf_TNTN(x,paramsMix(idx+4,1),paramsMix(idx+4,2),paramsMix(idx+4,3),paramsMix(idx+4,4),paramsMix(idx+4,5));
            plot(x,pdf_TNTNval,'-g','LineWidth',2)
            % legend('Hist','TNTN','Orientation','Vertical')
            title('Jan (TNTN)','fontsize',10,'fontweight','b','color','k')
        case 2 % Normal
            muN=paramsM(idx+5,1);sigmaN=paramsM(idx+5,2); 
            pd = makedist('Normal','mu',muN,'sigma',sigmaN);
            pdf_NW=pdf(pd,x);
            plot(x,pdf_NW,'-g','LineWidth',2)
            % legend('Hist','Normal','Orientation','Vertical','fontsize',8)
            title('Feb (Normal)','fontsize',10,'fontweight','b','color','k')
        case 3 % TNW
            x = x(x > xTrunc);
            pdf_TNWval=pdf_TNW(x,paramsMix(idx+3,1),paramsMix(idx+3,2),paramsMix(idx+3,3),paramsMix(idx+3,4),paramsMix(idx+3,5));
            plot(x,pdf_TNWval,'-g','LineWidth',2)
            % legend('Hist','TNW','Orientation','Vertical')
            title('Mar (TNW)','fontsize',10,'fontweight','b','color','k')
        case 4 % TNW
            x = x(x > xTrunc);
            pdf_TNWval=pdf_TNW(x,paramsMix(idx+3,1),paramsMix(idx+3,2),paramsMix(idx+3,3),paramsMix(idx+3,4),paramsMix(idx+3,5));
            plot(x,pdf_TNWval,'-g','LineWidth',2)
            % legend('Hist','TNW','Orientation','Vertical')
            title('Apr (TNW)','fontsize',10,'fontweight','b','color','k')
    end
    ylabel('Probability','fontsize',10,'fontweight','b','color','k')
    xlabel('Wind Speed(m/s)','fontsize',10,'fontweight','b','color','k')
end

%% Distributions for May-Aug
figure(2)
for monID=5:8
    totH=totD(monID)*24;
    windDataM=monData(1:totH,monID);
    idx=(monID-1)*5; 
    % x-axis
    maxD=max(windDataM);
    x=0:0.1:maxD;
    %% Plot histogram
    subplot(2,2,monID-4)
    datacount=size(windDataM,1);
    [maxClass,class,noOfHours,frequency,cumuFreq,midClassSpeed,averageClassSpeed]=niweFreqDistFn(windDataM,datacount);
    bar(midClassSpeed,frequency);
    hold all;
    %% Plot fitted distributions
    switch(monID)
        case 5 % TNW
            x = x(x > xTrunc);
            pdf_TNWval=pdf_TNW(x,paramsMix(idx+3,1),paramsMix(idx+3,2),paramsMix(idx+3,3),paramsMix(idx+3,4),paramsMix(idx+3,5));
            plot(x,pdf_TNWval,'-g','LineWidth',2)
            % legend('Hist','TNW','Orientation','Vertical')
            title('May (TNW)','fontsize',10,'fontweight','b','color','k')
        case 6 % TNW
            x = x(x > xTrunc);
            pdf_TNWval=pdf_TNW(x,paramsMix(idx+3,1),paramsMix(idx+3,2),paramsMix(idx+3,3),paramsMix(idx+3,4),paramsMix(idx+3,5));
            plot(x,pdf_TNWval,'-g','LineWidth',2)
            % legend('Hist','TNW','Orientation','Vertical')
            title('June (TNW)','fontsize',10,'fontweight','b','color','k')
        case 7 % TNW
            kEV=paramsM2(idx+5,1);sigmaEV=paramsM2(idx+5,2);muEV=paramsM2(idx+5,3);
            pd = makedist('GeneralizedExtremeValue','k',kEV,'sigma',sigmaEV,'mu',muEV);
            pdf_EVS=pdf(pd,x);
            plot(x,pdf_EVS,'-g','LineWidth',2)
            % legend('Hist','TNW','Orientation','Vertical')
            title('July (GEV)','fontsize',10,'fontweight','b','color','k')
        case 8 % TNTN
            x = x(x > xTrunc);
            pdf_TNTNval=pdf_TNTN(x,paramsMix(idx+4,1),paramsMix(idx+4,2),paramsMix(idx+4,3),paramsMix(idx+4,4),paramsMix(idx+4,5));
            plot(x,pdf_TNTNval,'-g','LineWidth',2)
            % legend('Hist','TNTN','Orientation','Vertical')
            title('Aug (TNTN)','fontsize',10,'fontweight','b','color','k')
    end
    ylabel('Probability','fontsize',10,'fontweight','b','color','k')
    xlabel('Wind Speed(m/s)','fontsize',10,'fontweight','b','color','k')
end

%% Distributions for Sep-Dec
figure(3)
for monID=9:12
    totH=totD(monID)*24;
    windDataM=monData(1:totH,monID);
    idx=(monID-1)*5; 
    % x-axis
    maxD=max(windDataM);
    x=0:0.1:maxD;
    %% Plot histogram
    subplot(2,2,monID-8)
    datacount=size(windDataM,1);
    [maxClass,class,noOfHours,frequency,cumuFreq,midClassSpeed,averageClassSpeed]=niweFreqDistFn(windDataM,datacount);
    bar(midClassSpeed,frequency);
    hold all;
    %% Plot fitted distributions
    switch(monID)
        case 9 % TNW
            x = x(x > xTrunc);
            pdf_TNWval=pdf_TNW(x,paramsMix(idx+3,1),paramsMix(idx+3,2),paramsMix(idx+3,3),paramsMix(idx+3,4),paramsMix(idx+3,5));
            plot(x,pdf_TNWval,'-g','LineWidth',2)
            % legend('Hist','TNW','Orientation','Vertical')
            title('Sep (TNW)','fontsize',10,'fontweight','b','color','k')
        case 10 % GW
            x = x(x > xTrunc);
            pdf_GWval=pdf_GW(x,paramsMix(idx+2,1),paramsMix(idx+2,2),paramsMix(idx+2,3),paramsMix(idx+2,4),paramsMix(idx+2,5));
            plot(x,pdf_GWval,'-g','LineWidth',2)
            % legend('Hist','TNW','Orientation','Vertical')
            title('Oct (GW)','fontsize',10,'fontweight','b','color','k')
        case 11 % TNW
            x = x(x > xTrunc);
            pdf_WWval=pdf_WW(x,paramsMix(idx+1,1),paramsMix(idx+1,2),paramsMix(idx+1,3),paramsMix(idx+1,4),paramsMix(idx+1,5));
            plot(x,pdf_WWval,'-g','LineWidth',2)
            % legend('Hist','TNW','Orientation','Vertical')
            title('Nov (WW)','fontsize',10,'fontweight','b','color','k')
        case 12 % TNTN
            x = x(x > xTrunc);
            pdf_WWval=pdf_WW(x,paramsMix(idx+1,1),paramsMix(idx+1,2),paramsMix(idx+1,3),paramsMix(idx+1,4),paramsMix(idx+1,5));
            plot(x,pdf_WWval,'-g','LineWidth',2)
            % legend('Hist','TNW','Orientation','Vertical')
            title('Dec (WW)','fontsize',10,'fontweight','b','color','k')
    end
    ylabel('Probability','fontsize',10,'fontweight','b','color','k')
    xlabel('Wind Speed(m/s)','fontsize',10,'fontweight','b','color','k')
end












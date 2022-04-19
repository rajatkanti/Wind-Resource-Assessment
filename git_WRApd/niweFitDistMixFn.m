function []=niweFitDistMixFn(periodC,monID,sID,windData)
%% This programs fits mixture probability distributions to NIWE data
% using mle function of MATLAB
% Refer "Fitting Custom Univariate Distributions"
%@Author: Rajat Kanti Samal, This version date: 29-May-2020


%% Fit distributions
x=windData;
for distC=10:10
    fprintf('Mixture Distribution ID: %d \n',distC);
    switch(distC)
        case 5 % Fit two component mixture weibull distribution        
            %% Using Anonymous functions
            pdf_WW = @(x,p,c1,k1,c2,k2) ...
                             p*wblpdf(x,c1,k1) + (1-p)*wblpdf(x,c2,k2);
            lb = [0 0 0 0 0];
            ub = [1 Inf Inf Inf Inf];        
            start = [0.5 5 2 5 2];   
            options = statset('MaxIter',500, 'MaxFunEvals',800);
            params = mle(x, 'pdf',pdf_WW, 'start',start, 'lower',lb, 'upper',ub,'options',options);      

        case 6 % Gamma-Weibull mixture distribution
            %% Using Anonymous functions
            pdf_GW = @(x,p,c1,k1,c2,k2) ...
                             p*wblpdf(x,c1,k1) + (1-p)*gampdf(x,k2,c2);
            lb = [0 0 0 0 0];
            ub = [1 Inf Inf Inf Inf];        
            start = [0.5 5 2 5 2];   
            options = statset('MaxIter',500, 'MaxFunEvals',3000);
            params = mle(x, 'pdf',pdf_GW, 'start',start, 'lower',lb, 'upper',ub,'options',options);  
        case 7 % Truncated Normal- Weibull mixture distribution
            %% Using Anonymous functions
            pd=fitdist(windData,'normal'); % to obtain the start parameters        
            xTrunc = 0;
            x = x(x > xTrunc);        
            pdf_TNW = @(x,p,c,k,mu,sigma) ...
                             p*wblpdf(x,c,k) + (1-p)*(normpdf(x,mu,sigma) ./ (1-normcdf(xTrunc,mu,sigma)));
            lb = [0 0 0 0 0];
            ub = [1 Inf Inf Inf Inf];        
            start = [0.5 5 2 pd.mu pd.sigma];   
            options = statset('MaxIter',500, 'MaxFunEvals',800);
            params = mle(x, 'pdf',pdf_TNW, 'start',start, 'lower',lb, 'upper',ub,'options',options); 
        case 8 % Truncated Normal-Truncated Normal
            pd=fitdist(windData,'normal'); % to obtain the start parameters        
            xTrunc = 0;
            x = x(x > xTrunc);        
            pdf_TNTN = @(x,p,mu1,sigma1,mu2,sigma2) ...
                             p*(normpdf(x,mu1,sigma1) ./ (1-normcdf(xTrunc,mu1,sigma1)))...
                             + (1-p)*(normpdf(x,mu2,sigma2) ./ (1-normcdf(xTrunc,mu2,sigma2)));
            lb = [0 0 0 0 0];
            ub = [1 Inf Inf Inf Inf];        
            start = [0.5 pd.mu pd.sigma pd.mu pd.sigma];   
            options = statset('MaxIter',300, 'MaxFunEvals',600);
            params = mle(x, 'pdf',pdf_TNTN, 'start',start, 'lower',lb, 'upper',ub,'options',options); 
            
        case 10 % Truncated Normal using MLE
            pd=fitdist(windData,'normal'); % to obtain the start parameters        
            xTrunc = 0;
            x = x(x > xTrunc); 
            pdf_TN = @(x,mu1,sigma1) ...
                             normpdf(x,mu1,sigma1) ./ (1-normcdf(xTrunc,mu1,sigma1));
            lb = [0 0];
            ub = [Inf Inf];        
            start = [pd.mu pd.sigma];   
            options = statset('MaxIter',300, 'MaxFunEvals',600);
            params = mle(x, 'pdf',pdf_TN, 'start',start, 'lower',lb, 'upper',ub,'options',options); 
                             
    end




    %%%%%%%%%%%%%%%%%%%%%%%% GOODNESS-OF-FIT TESTS %%%%%%%%%%%%%%%%%%%%%%%%%%%%
    sigGOF=0.01;% Significance of goodness-of-fit tests
    [hChi,pChi,chiStat,cvChi,hKS,pKS,ksStat,cvKS]=niweGOFmixfn(distC,params,windData,sigGOF);
    gofRes=[hChi,pChi,chiStat,cvChi,hKS,pKS,ksStat,cvKS];
    if distC==10
        params = [NaN params(1) params(2) NaN NaN];
    end
    paramsEst=[params gofRes];

    switch(periodC)
        case 1
            [ pSheet,pCol ] = niweDistYcol( distC );
        case 2
            [ pSheet,pCol ] = niweDistMcol( monID,distC );
        case 3
            [ pSheet,pCol ] = niweDistScol( sID,distC );
    end       


    disp('Now writing parameters...')
    %xlswrite('C:\Users\Rajat\Documents\MATLAB\IOFiles\WRAV\WRAVresMix.xlsx', paramsEst, pSheet, pCol );
    xlswrite('C:\Users\Rajat\Documents\MATLAB\IOFiles\NIWEio\NIWEresMix.xlsx', paramsEst, pSheet, pCol );

end







       











function [hChi,pChi,chiStat,cvChi,hKS,pKS,ksStat,cvKS]=niweGOFmixfn(distC,params,windData,sigGOF)

%This function performs goodness-of-fit tests.
% Functions of MATLAB Statistics Toolbox are used. 

x=windData;

switch(distC)
    
    case 5 % Weibull-Weibull
        p=params(1);c1=params(2);k1=params(3);c2=params(4);k2=params(5);
        cdf_WW = @(x,p,c1,k1,c2,k2) ...
                         p*wblcdf(x,c1,k1) + (1-p)*wblcdf(x,c2,k2);
        test_cdf = {cdf_WW,p,c1,k1,c2,k2};  
        test_cdf2 = [x,cdf_WW(x,p,c1,k1,c2,k2)];  
        % test_cdf = {@cdfWWfn,params};       
        
    case 6 % Gamma-Weibull    
        p=params(1);c1=params(2);k1=params(3);c2=params(4);k2=params(5);
        cdf_GW = @(x,p,c1,k1,c2,k2) ...
                         p*wblcdf(x,c1,k1) + (1-p)*gamcdf(x,k2,c2);
        test_cdf = {cdf_GW,p,c1,k1,c2,k2};  
        test_cdf2 = [x,cdf_GW(x,p,c1,k1,c2,k2)];  
        
    case 7 % Truncated Normal-Weibull
        p=params(1);c=params(2);k=params(3);mu=params(4);sigma=params(5);
        xTrunc = 0;
        x = x(x > xTrunc);
        cdf_TNW = @(x,p,c,k,mu,sigma) ...
                         p*wblcdf(x,c,k) + (1-p)*(normcdf(x,mu,sigma) ./ (1-normcdf(xTrunc,mu,sigma)));
        test_cdf = {cdf_TNW,p,c,k,mu,sigma};  
        test_cdf2 = [x,cdf_TNW(x,p,c,k,mu,sigma)];
        
    case 8 % Truncated Normal - Truncated Normal
        p=params(1);mu1=params(2);sigma1=params(3);mu2=params(4);sigma2=params(5);
        xTrunc = 0;x = x(x > xTrunc);
        cdf_TNTN = @(x,p,mu1,sigma1,mu2,sigma2) ...
                         p*(normcdf(x,mu1,sigma1) ./ (1-normcdf(xTrunc,mu1,sigma1)))...
                         + (1-p)*(normcdf(x,mu2,sigma2) ./ (1-normcdf(xTrunc,mu2,sigma2)));
        test_cdf = {cdf_TNTN,p,mu1,sigma1,mu2,sigma2};  
        test_cdf2 = [x,cdf_TNTN(x,p,mu1,sigma1,mu2,sigma2)];
    case 10 % Truncated Normal
        mu=params(1);sigma=params(2);
        xTrunc = 0;x = x(x > xTrunc);
        cdf_TN = @(x,mu,sigma) ...
                         normcdf(x,mu,sigma) ./ (1-normcdf(xTrunc,mu,sigma));
        test_cdf = {cdf_TN,mu,sigma};  
        test_cdf2 = [x,cdf_TN(x,mu,sigma)];
end
    
% disp('Now performing Chi-square test')
%h = chi2gof(x,'cdf',{@normcdf,mean(x),std(x)};
[h,p,chistat] = chi2gof(windData,'CDF',test_cdf,'Alpha',sigGOF);
hChi=h;pChi=p;chiStat=chistat.chi2stat;
dfChi=chistat.df;% Degrees of freedom
cvChi=chi2inv(1-sigGOF,double(dfChi));



% disp('Now performing K-S test with kstest')
hKS=1;pKS=0;ksStat=0;cvKS=0;
[h,p,ksstat,cv] = kstest(windData,'CDF',test_cdf2,'Alpha',sigGOF);   
hKS=h;pKS=p;ksStat=ksstat;cvKS=cv;
    
end% End of function











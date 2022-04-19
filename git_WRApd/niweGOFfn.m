
function [hChi,pChi,chiStat,cvChi,hKS,pKS,ksStat,cvKS]=niweGOFfn(distC,params,windData,sigGOF)
%This function performs goodness-of-fit tests.
% Functions of MATLAB Statistics Toolbox are used. 

switch(distC)
    
    case 1 % Weibull
        k=params(1);
        c=params(2);
        test_cdf = makedist('Weibull','a',c,'b',k);
        
    case 2 % Gamma
        a=params(1);
        b=params(2);
        test_cdf = makedist('Gamma','a',a,'b',b);
    case 3 % Lognormal (prob.LognormalDistribution class)
        mu=params(1);
        sigma=params(2);
        test_cdf = makedist('Lognormal','mu',mu,'sigma',sigma);
        
    case 4 % Inverse Gaussian
        mu=params(1);
        lambda=params(2);
        test_cdf = makedist('InverseGaussian','mu',mu,'lambda',lambda);
    case 9 % Truncated Normal
        mu=params(1);
        sigma=params(2);
        test_cdf = makedist('Normal','mu',mu,'sigma',sigma);
    case 11
        beta=params(1);
        gamma=params(2);
        test_cdf = makedist('BirnbaumSaunders','beta',beta,'gamma',gamma);
    case 12
        mu=params(1);
        sigma=params(2);
        test_cdf = makedist('Logistic','mu',mu,'sigma',sigma);
    case 13
        mu=params(1);
        sigma=params(2);
        test_cdf = makedist('Loglogistic','mu',mu,'sigma',sigma);
    case 14
        mu=params(1);
        omega=params(2);
        test_cdf = makedist('Nakagami','mu',mu,'omega',omega);
    case 15
        k=params(1);
        sigma=params(2);
        mu=params(3);
        test_cdf = makedist('GeneralizedExtremeValue','k',k,'sigma',sigma,'mu',mu);
    case 16
        b=params(1);
        test_cdf = makedist('Rayleigh','b',b);
end
    
%disp('Now performing Chi-square test')
[h,p,chistat] = chi2gof(windData,'CDF',test_cdf,'Alpha',sigGOF);
hChi=h;pChi=p;chiStat=chistat.chi2stat;
dfChi=chistat.df;% Degrees of freedom
cvChi=chi2inv(1-sigGOF,double(dfChi));

%disp('Now performing K-S test with kstest')
[h,p,ksstat,cv] = kstest(windData,'CDF',test_cdf,'Alpha',sigGOF);   
hKS=h;pKS=p;ksStat=ksstat;cvKS=cv;
    
end% End of function











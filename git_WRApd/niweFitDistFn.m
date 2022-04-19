
function []=niweFitDistFn(periodC,monID,sID,windData)
% This function fits probability distributions to NIWE wind data
%@Author: Rajat Kanti Samal, This version date: 26-May-2020

%%%%%%%%%%%%%%%%%%%% Plot Frequency Distribution %%%%%%%%%%%%%%%%%%%%%%%%%%
% mFactor=1;%No multiplication factor
% histogram(windData);

%%%%%%%%%%%%%%%%%%%%% PD estimation %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 1-Weibull; 2-Gamma; 3-Lognormal; 4-InvGaussian; 5-Normal
% distC=input('Enter distribution choice-->');
for distC=1:4
    params=zeros(1,3);%Assuming a maximum of three parameters
    fprintf('Distribution ID: %d \n',distC);
    switch(distC)
        case 1
            pd=fitdist(windData,'Weibull');
            params(1)=pd.B;% shape  parameter
            params(2)=pd.A;% scale parameter
        case 2
            pd=fitdist(windData,'Gamma');
            params(1)=pd.a;% shape parameter
            params(2)=pd.b;% scale parameter
        case 3
            pd=fitdist(windData,'Lognormal');
            params(1)=pd.mu;% log mean parameter
            params(2)=pd.sigma;% log standard deviation parameter
        case 4
            pd=fitdist(windData,'InverseGaussian');
            params(1)=pd.mu;% scale parameter
            params(2)=pd.lambda;% shape parameter
        case 9
            pd=fitdist(windData,'Normal');
            params(1)=pd.mu;%mean
            params(2)=pd.sigma;%standard deviation
        case 11
            pd=fitdist(windData,'BirnbaumSaunders');
            params(1)=pd.beta;% scale parameter
            params(2)=pd.gamma;% shape parameter
        case 12
            pd=fitdist(windData,'Logistic');
            params(1)=pd.mu;% mean
            params(2)=pd.sigma;% scale parameter
        case 13
            pd=fitdist(windData,'Loglogistic');
            params(1)=pd.mu;% log mean parameter
            params(2)=pd.sigma;% log scale parameter
        case 14
            pd=fitdist(windData,'Nakagami');
            params(1)=pd.mu;% shape parameter
            params(2)=pd.omega;% scale parameter
        case 15
            pd=fitdist(windData,'GeneralizedExtremeValue');
            params(1)=pd.k;% shape parameter
            params(2)=pd.sigma;% scale parameter
            params(3)=pd.mu;% location parameter
        case 16
            pd=fitdist(windData,'Rayleigh');
            params(1)=pd.b;% defining parameter
    end

    %%%%%%%%%%%%%%%%%%%%%%%% GOODNESS-OF-FIT TESTS %%%%%%%%%%%%%%%%%%%%%%%%%%%%
    sigGOF=0.01;% Significance of goodness-of-fit tests
    [hChi,pChi,chiStat,cvChi,hKS,pKS,ksStat,cvKS]=niweGOFfn(distC,params,windData,sigGOF);
    gofRes=[hChi,pChi,chiStat,cvChi,hKS,pKS,ksStat,cvKS];

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
    xlswrite('C:\Users\RAJAT\Documents\MATLAB\IOFiles\MERRAio\NIWERE\NIWEresRe10.xlsx', paramsEst, pSheet, pCol );

end% End of for loop for distributions


       










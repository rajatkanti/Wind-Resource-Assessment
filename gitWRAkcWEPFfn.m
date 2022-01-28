function [kWEP,cWEP]=gitWRAkcWEPFfn(meanWindSpeed1,meanWindSpeed3)
% This function estimates k and c using Wind Energy Pattern Factor method
%   Weibull shape and scale parameters
% $Author: Dr. Rajat Kanti Samal$ $Date: 2022/01/25 18:23:52 $    $Version: 1.0 $
% $Veer Surendra Sai University of Technology, Burla, Odisha, India$


Epf=meanWindSpeed3/(meanWindSpeed1^3);
kWEP=1+3.69/(Epf*Epf);
cWEP=meanWindSpeed1/gamma(1+(1/kWEP));


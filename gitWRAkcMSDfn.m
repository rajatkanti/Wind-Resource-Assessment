%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Estimation of k and c from Mean and Standard Deviation

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [kMSD,cMSD]=gitWRAkcMSDfn(meanWindData,sdWindData)
% This function estimates k and c from Mean and Standard Deviation
%   (1)-arithmatic mean; (2)-root mean square; (3)-cubic mean
% $Author: Dr. Rajat Kanti Samal$ $Date: 2022/01/25 18:23:52 $    $Version: 1.0 $
% $Veer Surendra Sai University of Technology, Burla, Odisha, India$


kMSD=zeros(3,1);cMSD=zeros(3,1);%MSD means mean standard deviation method
for n=1:3
    kMSD(n)=(sdWindData(n)/meanWindData(n))^(-1.086);
    cMSD(n)=meanWindData(n)/gamma(1+(1/kMSD(n)));
end

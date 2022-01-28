function [kModMLE, cModMLE, iterModMLE]=gitWRAkcModMLEfn(maxClass,frequency,averageClassSpeed)
% This function estimates k and c using using modified MLE (G-S method is used)
%   Weibull shape and scale parameters
% $Author: Dr. Rajat Kanti Samal$ $Date: 2022/01/25 18:23:52 $    $Version: 1.0 $
% $Veer Surendra Sai University of Technology, Burla, Odisha, India$


kModMLE=2.0;%initial guess
iterModMLE=0;
bins=maxClass;
dk=100;

sum3=0;

for i=1:bins
    if frequency(i) ~=0
        sum3=sum3+(log(averageClassSpeed(i))*frequency(i));
    end
end

% disp ('Iteration   f     dk        k')
while abs(dk) >= 0.001 && iterModMLE <100
    iterModMLE = iterModMLE + 1;
    
    sum1=0;
    for i=1:bins
        if frequency(i) ~=0
        sum1=sum1+((averageClassSpeed(i)^kModMLE)*log(averageClassSpeed(i))*frequency(i));
        end
    end
    
    
    sum2=0;
    for i=1:bins
        sum2=sum2+((averageClassSpeed(i)^kModMLE)*frequency(i));
    end
    
    
    f = 1/((sum1/sum2)-(sum3));
    dk = f-kModMLE;%f is nothing but k; it has been rearranged
    kModMLE = kModMLE + dk;
%     fprintf('%f\n', iter), disp([f, dk,k1])
end

%Calculation of c
sum4=0;
for i=1:bins
    sum4=sum4+((averageClassSpeed(i)^kModMLE)*frequency(i));
end
cModMLE=(sum4)^(1/kModMLE);

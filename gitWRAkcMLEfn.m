function [kMLE, cMLE, iterMLE]=gitWRAkcMLEfn(windData,datacount)
% This function estimates k and c using using MLE (G-S method is used)
%   Weibull shape and scale parameters
% $Author: Dr. Rajat Kanti Samal$ $Date: 2022/01/25 18:23:52 $    $Version: 1.0 $
% $Veer Surendra Sai University of Technology, Burla, Odisha, India$


kMLE=2.0;%initial guess
iterMLE=0;
n=0;
for i=1:datacount
    if windData(i)~= 0
        n=n+1;
    end
end
sum3=0;
dk=100;
for i=1:n
    sum3=sum3+log(windData(i));
end
% disp ('Iteration   f     dk        k')
while abs(dk) >= 0.001 && iterMLE <100
    iterMLE = iterMLE + 1;
    
    sum1=0;
    for i=1:n
        sum1=sum1+(windData(i)^kMLE)*log(windData(i));
    end
    
    sum2=0;
    for i=1:n
        sum2=sum2+(windData(i)^kMLE);
    end
    
    f = 1/((sum1/sum2)-(sum3/n));
    dk = f-kMLE;%f is nothing but k; it has been rearranged
    kMLE = kMLE + dk;
%     fprintf('%f\n', iter), disp([f, dk,k1])
end

%Calculation of c
sum4=0;
for i=1:n
    sum4=sum4+(windData(i)^kMLE);
end
cMLE=(sum4/n)^(1/kMLE);







function [kLQ, cLQ]=gitWRAkcLQfn(maxClass,averageClassSpeed,cumuFreq)
%% This function estimates k and c using Least Square Method
%   Weibull shape and scale parameters
% $Author: Dr. Rajat Kanti Samal$ $Date: 2022/01/25 18:23:52 $    $Version: 1.0 $
% $Veer Surendra Sai University of Technology, Burla, Odisha, India$


%% Last interval to be left out to avoid log of zero
x=zeros(maxClass-1,1); y=zeros(maxClass-1,1);
sumxi=0; sumyi=0; sumxi2=0; sumxiyi=0;
fprintf('\n\n');
%disp ('xi             yi');
lqn=maxClass;
for i=1:(maxClass-1)%last bin to be excluded as CF=1; log (0)=Inf    
    %exclude the class with zero frequency from regression
    %caculate xi, yi but do not add in least square equations
    if(averageClassSpeed(i)==0)
        x(i)=log(averageClassSpeed(i));
        y(i)=log(-log(1-cumuFreq(i)));
        %fprintf('%d     %f      %f   \n',i, x(i), y(i))
        lqn=lqn-1;
        continue;
    end
    x(i)=log(averageClassSpeed(i));
    y(i)=log(-log(1-cumuFreq(i)));
    
    sumxi=sumxi+x(i);
    sumxi2=sumxi2+(x(i))^2;
    sumyi=sumyi+y(i);
    sumxiyi=sumxiyi+(x(i)*y(i));
    
    %fprintf('%d     %f      %f   \n',i, x(i), y(i))
end

%% this function cannot plot accurately and some values of x may be zero
% plot(x,y)

A(1,1)=lqn-1;
A(1,2)=sumxi;%summation xi
A(2,1)=sumxi;%summation xi
A(2,2)=sumxi2;%summation xi2

C(1,1)=sumyi;%summation yi
C(1,2)=sumxiyi; %summation xiyi
A;
C';

X=C/double(A); 
a=X(1); b=X(2); %Solving the least square equations

cLQ=exp(-a/b); kLQ=b;




function [ errMes ] = reERRfn( windData,windDataR )
%This function computes error measures of comparison
%   MBE,MAE,RMSE are computed

datacount=size(windData,1) 
tmp=0; tmp2=0; tmp3=0; 
for i=1:datacount
    tmp=tmp+(windData(i)-windDataR(i));
    tmp2=tmp2+abs(windData(i)-windDataR(i));
    tmp3=tmp3+(windData(i)-windDataR(i))^2;
end

MBE=(1/datacount)*tmp; 
MAE=(1/datacount)*tmp2;
RMSE=sqrt((1/datacount)*tmp3); 

meanWS=mean(windData)
rMBE=(MBE/meanWS)*100;
rMAE=(MAE/meanWS)*100;
rRMSE=(RMSE/meanWS)*100;

errMes=[MBE MAE RMSE rMBE rMAE rRMSE]; 

end % end of function 


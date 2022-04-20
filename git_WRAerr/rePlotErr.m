%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This program plots the error measures of NIWE and MERRA comparison
% MATLAB Statistics Toolbox is used
% $Author: Dr. Rajat Kanti Samal$ $Date: 15-Aug-2020 $    $Version: 1.0 $
% $Veer Surendra Sai University of Technology, Burla, Odisha, India$


clc;
clear;

%% Read Data
disp('Now reading wind data error measures...')
niweErr=xlsread('C:\Users\RAJAT\Documents\MATLAB\IOFiles\MERRAio\NIWERE\REniweRes.xlsx', 'Err50', 'D11:O22');
rMAEha=niweErr(:,5); rRMSEha=niweErr(:,6); 
rMAEda=niweErr(:,11); rRMSEda=niweErr(:,12); 

mon=[1 2 3 4 5 6 7 8 9 10 11 12];
monN = {'Jan'; 'Feb'; 'Mar'; 'Apr'; 'May'; 'Jun'; 'Jul'; 'Aug'; 'Sep'; 'Oct'; 'Nov'; 'Dec'};

%% Plot Results
figure(1)
subplot(2,1,1)
plot(mon,rMAEha,'-ob','LineWidth',2)
hold all;
plot(mon,rMAEda,'-+r','LineWidth',2)
set(gca,'xtick',[1:12],'xticklabel',monN)
ylabel('rMAE (%)','fontsize',12,'fontweight','b','color','k')
xlabel('Month','fontsize',12,'fontweight','b','color','k')
legend('HA','DA')
%title('Central Tendency','fontsize',12,'fontweight','b','color','k')
subplot(2,1,2)
plot(mon,rRMSEha,'-ob','LineWidth',2)
hold all; 
plot(mon,rRMSEda,'-+r','LineWidth',2)
set(gca,'xtick',[1:12],'xticklabel',monN)
ylabel('rRMSE (%)','fontsize',12,'fontweight','b','color','k')
xlabel('Month','fontsize',12,'fontweight','b','color','k')
%legend('Measured','MERRA-2')





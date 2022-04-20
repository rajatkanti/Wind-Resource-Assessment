%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This programs plots the NIWE-MERRA correlation across months...
% MATLAB Statistics Toolbox is used
% $Author: Dr. Rajat Kanti Samal$ $Date: 15-Aug-2020 $    $Version: 1.0 $
% $Veer Surendra Sai University of Technology, Burla, Odisha, India$

clc;
clear;

%% Read data
disp('Now reading correlation values...')
windCorr20=xlsread('C:\Users\RAJAT\Documents\MATLAB\IOFiles\MERRAio\REniweRes.xlsx', 'Corr20', 'F11:G22');
windCorr50=xlsread('C:\Users\RAJAT\Documents\MATLAB\IOFiles\MERRAio\REniweRes.xlsx', 'Corr50', 'H11:I22');

haCorMon=zeros(12,2);daCorMon=zeros(12,2);
haCorMon(:,1)=windCorr20(:,1); haCorMon(:,2)=windCorr50(:,1);
daCorMon(:,1)=windCorr20(:,2); daCorMon(:,2)=windCorr50(:,2);

mon=[1 2 3 4 5 6 7 8 9 10 11 12];
monN = {'Jan'; 'Feb'; 'Mar'; 'Apr'; 'May'; 'Jun'; 'Jul'; 'Aug'; 'Sep'; 'Oct'; 'Nov'; 'Dec'};

% for mon=1:12
%     monID(mon)=mon;
% end

%% Plot correlation
figure(1)
subplot(2,1,1)
bar([haCorMon(1,:); haCorMon(2,:); haCorMon(3,:); haCorMon(4,:); haCorMon(5,:); haCorMon(6,:); ...
    haCorMon(7,:); haCorMon(8,:); haCorMon(9,:); haCorMon(10,:); haCorMon(11,:); haCorMon(12,:)])
set(gca,'xtick',[1:12],'xticklabel',monN)
xlabel('Month','fontsize',12,'fontweight','b','color','k')
ylabel('Correlation','fontsize',12,'fontweight','b','color','k')
legend('10M','50M','Orientation','vertical')
title('Hourly Average Data','fontsize',12,'fontweight','b','color','k')
subplot(2,1,2)
bar([daCorMon(1,:); daCorMon(2,:); daCorMon(3,:); daCorMon(4,:); daCorMon(5,:); daCorMon(6,:); ...
    daCorMon(7,:); daCorMon(8,:); daCorMon(9,:); daCorMon(10,:); daCorMon(11,:); daCorMon(12,:)])
set(gca,'xtick',[1:12],'xticklabel',monN)
xlabel('Month','fontsize',12,'fontweight','b','color','k')
ylabel('Correlation','fontsize',12,'fontweight','b','color','k')
%legend('10M','50M','Orientation','vertical')
title('Daily Average Data','fontsize',12,'fontweight','b','color','k')



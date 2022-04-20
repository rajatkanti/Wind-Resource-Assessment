function reRegPlotfn( windData,windDataR )
%This function plots the regression plot
%   between measured and MERRA-2 data

%% R= corrcoef(windData,windDataN);
            
%% Fit Regression equations
x=windData;y=windDataR;
p = polyfit(x,y,1);
yfit = polyval(p,x);
yresid = y - yfit;
SSresid = sum(yresid.^2);
SStotal = (length(y)-1) * var(y);
rsq = 1 - SSresid/SStotal           

%% Plot
plot(windData,windDataR,'o')
hold on;
plot(windData,yfit,'r--')  
%plot(windData,windData,'r--')  
legend('Data','Model','Orientation','Vertical')
ylabel('NASA wind speed(m/s)','fontsize',12,'fontweight','b','color','k')
xlabel('Measured wind speed (m/s)','fontsize',12,'fontweight','b','color','k')

end % end of function 


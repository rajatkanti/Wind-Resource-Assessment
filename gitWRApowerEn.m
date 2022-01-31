%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Illustrative Example on Wind Resource Assessment
% This program computes power, energy and turbine performance index.
% Choices: (1-simulation; 2-extrapolation; 3-frequency distribution; 
% Choices: (4-estimation of parameters; 5-plot PDF)
% $Author: Dr. Rajat Kanti Samal$ $Date: 2022/01/29 15:09 $    $Version: 1.0$
% $Veer Surendra Sai University of Technology, Burla, Odisha, India$


clc;
clear;

datacount=8760; %N=8760=>Simulation is for hourly averages for an year

choice = input('Enter choice-->');

switch(choice)
    case 1 %% Convert wind speed to wind power
        % disp('Now reading simulated wind speed data...')
        % windData=xlsread('C:\Users\RAJAT\Documents\MATLAB\IOFiles\gitIO\gitWRAio.xlsx', 'Data', 'C6:C8765');        
        %% Simulation of wind speed using Weibull distribution
        k=2; % shape parameter
        c=15; % scale parameter
        R=rand(datacount,1); % generate N random numbers
        windData=c*(-log (R)).^(1/k); %from inverse method from Weibull CDF
        %% Convert wind speed to wind power
        turData = [2500 3 12 25 80]; % Rated Power (kW), Cut-in, rated , cut-out speeds
        Prated=turData(1);Vcutin=turData(2);Vrated=turData(3);Vfurling=turData(4);hubHeight=turData(5);
        Pe=zeros(datacount,1);
        EnergyTS=0;
        for count=1:datacount
            Pe(count)=gitWTPCfn(windData(count),Prated,Vcutin,Vrated,Vfurling);%Power in kW for each hour
            EnergyTS=EnergyTS+Pe(count)*1; %Energy in kWh
        end
        emissionFactor=0.8; % ton/MWh
        emissionReduction=EnergyTS*emissionFactor;
        EnergyTSmu=EnergyTS/1000000; emissionReductionMU=emissionReduction/1000000;
        disp('Energy(kWh)        EmissionRed(tCO2)')
        fprintf('%10.2f                  %10.2f\n', EnergyTS, emissionReduction)
        disp('Energy(MU)        EmissionRed(million tCO2)')
        fprintf('%10.3f                  %10.3f\n', EnergyTSmu, emissionReductionMU)

        disp('Now writing hourly power output to file...')
        xlswrite('C:\Users\RAJAT\Documents\MATLAB\IOFiles\gitIO\gitWRAio.xlsx', Pe, 'Power', 'D6:D8765');     
end
















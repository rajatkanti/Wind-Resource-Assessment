%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Illustrative Example on Wind Resource Assessment
% Time series data is simulated using inverse method.
% k and c are re-estimated using various methods.
% chi square goodness-of-fit test is performed on results. 
% Choices: (1-simulation; 2-extrapolation; 3-frequency distribution; 
% Choices: (4-estimation of parameters; 5-plot PDF)
% $Author: Dr. Rajat Kanti Samal$ $Date: 2022/01/25 18:23:52 $    $Version: 1.0 $
% $Veer Surendra Sai University of Technology, Burla, Odisha, India$


clc;
clear;

datacount=8760; %N=8760=>Simulation is for hourly averages for an year

choice = input('Enter choice-->');

switch(choice)
    case 1 
        %% Simulation of wind speed using Weibull distribution
        k=2; % shape parameter
        c=8; % scale parameter
        R=rand(datacount,1); % generate N random numbers
        windData=c*(-log (R)).^(1/k); %from inverse method from Weibull CDF
        meanSD=[mean(windData) std(windData)];
        disp('Now writing simulated wind speeds to output file...')
        xlswrite('C:\Users\RAJAT\Documents\MATLAB\IOFiles\gitIO\gitWRAio.xlsx', windData, 'Data', 'C6:C8765');
        xlswrite('C:\Users\RAJAT\Documents\MATLAB\IOFiles\gitIO\gitWRAio.xlsx', meanSD, 'Data', 'D6:E6');
        
    case 2 
        %% Extrapolation of Wind data to hub height
        disp('Now reading simulated wind speed data...')
        windData=xlsread('C:\Users\RAJAT\Documents\MATLAB\IOFiles\gitIO\gitWRAio.xlsx', 'Data', 'C6:C8765');
        % Height correction
        h1=10; h2=[10 30 50 80 100]; windDataN=zeros(8760,5);                
        % Extrapolate wind speed using power law        
        for h=1:5
            % Calculation of alpha; [Panofsky and Dutton]
            zgm=sqrt(h1*h2(h));
            z0=0.5; % 0.5 for Parklands, bushes, numerous obstacles
            alpha=1/log(zgm/z0);
            % power law
            windDataN(:,h)=windData*((h2(h)/h1)^alpha);    
        end
        disp('Now writing extrapolated values of wind speed...')
        xlswrite('C:\Users\RAJAT\Documents\MATLAB\IOFiles\gitIO\gitWRAio.xlsx', windDataN, 'Data', 'I6:M8765');
        
    case 3
        %% Frequency distribution              
        disp('Now reading simulated wind speed data...')
        windData=xlsread('C:\Users\RAJAT\Documents\MATLAB\IOFiles\gitIO\gitWRAio.xlsx', 'Data', 'C6:C8765');
        
        %  Mean of wind speed, wind speed squared, wind speed cube
        [monthlyAverage,meanWindSpeed]=gitWRAmeanfn(windData,datacount);
        disp('Now writing monthly averages...')
        xlswrite('C:\Users\RAJAT\Documents\MATLAB\IOFiles\gitIO\gitWRAio.xlsx', monthlyAverage, 'Data', 'F6:F17');
        
        % frequency distribution
        [maxClass,class,noOfHours,frequency,cumuFreq,midClassSpeed,averageClassSpeed]=gitWRAfreqDistfn(windData,datacount);
        
        %% bar chart
        bar(averageClassSpeed,noOfHours)
        xlabel('Wind Speed','fontsize',14,'fontweight','b','color','k')
        ylabel('Number of hours','fontsize',14,'fontweight','b','color','k')
        
        
        
        
        %% for display on console
        disp('class       hours         frequency       cum freq           av. speed')
        for i=1:maxClass
        fprintf ('  %d          %d          %5.4f          %5.4f            %5.2f \n', class(i),noOfHours(i), frequency(i),cumuFreq(i), averageClassSpeed(i))
        end
        
    case 4
        %% Parameter estimation
        % Read data
        disp('Now reading simulated wind speed data...')
        windData=xlsread('C:\Users\RAJAT\Documents\MATLAB\IOFiles\gitIO\gitWRAio.xlsx', 'Data', 'C6:C8765');
        
        % frequency distribution
        [maxClass,class,noOfHours,frequency,cumuFreq,midClassSpeed,averageClassSpeed]=gitWRAfreqDistfn(windData,datacount);
                
        % arithmatic, square root and cubic mean
        [meanWindData,sdWindData]=gitWRAmeansdfn(maxClass,datacount,noOfHours,averageClassSpeed);
        [monthlyAverage,meanWindSpeed]=gitWRAmeanfn(windData,datacount);
        
                
        % Estimation of k and c
        [kLQ cLQ]=gitWRAkcLQfn(maxClass,averageClassSpeed,cumuFreq);
        [kMLE cMLE iterMLE]=gitWRAkcMLEfn(windData,datacount);
        [kModMLE cModMLE iterModMLE]=gitWRAkcModMLEfn(maxClass,frequency,averageClassSpeed);
        [kMSD cMSD]=gitWRAkcMSDfn(meanWindData,sdWindData);
        [kWEP cWEP]=gitWRAkcWEPFfn(meanWindSpeed(1),meanWindSpeed(3));
        
        % disp ('kLQ       cLQ')
        % fprintf('%5.4f    %5.4f\n\n',kLQ,cLQ)
        %  
        % disp ('kMLE      cMLE       iterMLE')
        % fprintf('%5.4f    %5.4f        %d\n\n',kMLE,cMLE,iterMLE)
        %  
        % disp ('kModMLE   cModMLE    iterModMLE')
        % fprintf('%5.4f    %5.4f        %d\n\n',kModMLE,cModMLE,iterModMLE)
        % 
        % disp ('kMSD   cMSD')
        % for n=1:3
        %     fprintf('%5.4f    %5.4f\n\n',kMSD(n),cMSD(n))
        % end
        % 
        % disp ('kWEP       cWEP')
        % fprintf('%5.4f    %5.4f\n\n',kWEP,cWEP)
        
        %Chi-square test
        [chi2CalLQ]=gitWRAkcChi2fn(kLQ,cLQ,maxClass,datacount,noOfHours);
        [chi2CalMLE]=gitWRAkcChi2fn(kMLE,cMLE,maxClass,datacount,noOfHours);
        [chi2CalModMLE]=gitWRAkcChi2fn(kModMLE,cModMLE,maxClass,datacount,noOfHours);
        [chi2CalMSD(1)]=gitWRAkcChi2fn(kMSD(1),cMSD(1),maxClass,datacount,noOfHours);
        [chi2CalMSD(2)]=gitWRAkcChi2fn(kMSD(2),cMSD(2),maxClass,datacount,noOfHours);
        [chi2CalMSD(3)]=gitWRAkcChi2fn(kMSD(3),cMSD(3),maxClass,datacount,noOfHours);
        [chi2CalWEP]=gitWRAkcChi2fn(kWEP,cWEP,maxClass,datacount,noOfHours);
        
        %% Theoretical values for chi2
        smallbinscount=0;
        for i=1:maxClass
            if noOfHours(i)<5
                smallbinscount=smallbinscount+1;        
            end
        end
        if smallbinscount==1
            binsForChi2=maxClass-smallbinscount;
        else
            binsForChi2=maxClass-smallbinscount+1;
        end
        smallbinscount;
        binsForChi2;
        degreesOfFreedom=binsForChi2-2-1;
        chi2Th05=chi2inv(0.95,double(degreesOfFreedom)); %The value of chi2 is below this value 95% of time
        chi2Th01=chi2inv(0.99,double(degreesOfFreedom)); %The value of chi2 is below this value 95% of time
        
        %% consolidating results
        kCal=[kLQ kMLE kModMLE kMSD(1) kMSD(2) kMSD(3) kWEP]
        cCal=[cLQ cMLE cModMLE cMSD(1) cMSD(2) cMSD(3) cWEP]
        chi2Cal=[chi2CalLQ chi2CalMLE chi2CalModMLE chi2CalMSD(1) chi2CalMSD(2) chi2CalMSD(3) chi2CalWEP];
        chi2Th=[double(degreesOfFreedom) chi2Th05 chi2Th01];
        
        %% Writing to I/O
        disp('Now writing output...')
        xlswrite('C:\Users\RAJAT\Documents\MATLAB\IOFiles\gitIO\gitWRAio.xlsx', kCal', 'Parameters', 'D4:D10');
        xlswrite('C:\Users\RAJAT\Documents\MATLAB\IOFiles\gitIO\gitWRAio.xlsx', cCal', 'Parameters', 'E4:E10');
        xlswrite('C:\Users\RAJAT\Documents\MATLAB\IOFiles\gitIO\gitWRAio.xlsx', chi2Cal', 'Parameters', 'F4:F10');
        xlswrite('C:\Users\RAJAT\Documents\MATLAB\IOFiles\gitIO\gitWRAio.xlsx', chi2Th, 'Parameters', 'E14:F14');

    case 5
        %% Weibull PDF
        % Read data
        disp('Now reading simulated wind speed data...')
        windData=xlsread('C:\Users\RAJAT\Documents\MATLAB\IOFiles\gitIO\gitWRAio.xlsx', 'Data', 'C6:C8765');
        % frequency distribution
        [maxClass,class,noOfHours,frequency,cumuFreq,midClassSpeed,averageClassSpeed]=gitWRAfreqDistfn(windData,datacount);
       
        k=2; c=8; h2=10; 
        U=0:0.1:25;
        f=wblpdf(U,c,k);        
        bar(midClassSpeed,frequency)
        hold all;
        plot(U,f);
        title(['Simulated Data at H=',int2str(h2)])
        xlabel('Wind Speed(m/s)')
        ylabel('Frequency')


end
















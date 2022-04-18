%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This program computes PN,CF and TPI for a fixed value of k and c.
% The turbine parameters need to be provided as inputs
% $Author: Dr. Rajat Kanti Samal$ $Date: 21-Apr-2020 $    $Version: 1.0 $
% $Veer Surendra Sai University of Technology, Burla, Odisha, India$

clc;
clear;

%% Turbine data
turData=[1500 3 9 25 80];
power=turData(1);Vcutin=turData(2);Vrated=turData(3);Vfurling=turData(4);hubHeight=turData(5);

p=Vcutin/Vrated;%4/13;%0.275;%Vrated/Vcutin; typical values for indian site
q=Vfurling/Vrated;%1.85;%Vfurling/Vrated


%% Select k,c corresponding to hub height
kOrig=2.00; cOrig=6.72;
%[kExt, cExt]= wraotKCextfn(kOrig,cOrig,hubHeight);
kExt=kOrig; cExt=cOrig;
k=kExt; 
c=cExt;%6.81;

%% Compute TPI
VrBYc=0.0:0.05:4.0;
VrBYc(1)=0.01;
size1=1;
size2=size(VrBYc,2);

%% Calculation of capacity factor and normalized power
CF=zeros(size1,size2);
NP=zeros(size1,size2);

for i=1:size1
    for j=1:size2
        term1=(p^3)*exp(-((p*VrBYc(j))^k(i)));        
        term2=(3*gamma(3/k(i)))/(k(i)*VrBYc(j)^3);
        term3=gammainc(VrBYc(j)^k(i),3/k(i))-gammainc((p*VrBYc(j))^k(i),3/k(i));
        term4=exp(-((q*VrBYc(j))^k(i)));
        CF(i,j)=term1+term2*term3-term4;
        NP(i,j)=CF(i,j)*(VrBYc(j)^3);        
    end
end
CF;
NP;

 
%% Calculation of NPmax and CFmax
NPmax=zeros(size1,1);
CFmax=zeros(size1,1);
NPCFmax=zeros(size1,1);
indexNPmax=zeros(size1,1);
indexCFmax=zeros(size1,1);
for i=1:size1
    [NPmax(i),indexNPmax(i)]=max(NP(i,1:size2));
    [CFmax(i),indexCFmax(i)]=max(CF(i,1:size2));
    NPCFmax(i)=NPmax(i)*CFmax(i);
end
indexNPmax;
indexCFmax;
NPmax;
CFmax;

%% Calculation of TPI
TPI=zeros(size1,size2);
for i=1:size1
    for j=1:size2
        TPI(i,j)=(NP(i,j)*CF(i,j))/(NPmax(i)*CFmax(i));
    end
end
TPI;


%% Calculation of TPImax
TPImax=zeros(size1,1);
indexTPImax=zeros(size1,1);
for i=1:size1
    [TPImax(i),indexTPImax(i)]=max(TPI(i,1:size2));    
end
TPImax;
indexTPImax;

VrBYcTur=Vrated/c;
for i=2:size2
    if VrBYcTur>VrBYc(i-1) && VrBYcTur<=VrBYc(i)
       VrBYcTurIndex=i;
       NPtur=NP(VrBYcTurIndex);
       CFtur=CF(VrBYcTurIndex);
       TPItur=TPI(VrBYcTurIndex);
    end
end
NPbyNPmax=(NPtur/NPmax)*100;

disp('No    k          c      p            q           PNmax        CFmax      TPImax')
fprintf('%d     %4.2f     %4.2f     %5.4f       %5.4f      %5.4f       %5.4f    %5.4f\n\n',1,k,c,p,q,NPmax,CFmax,TPImax)

disp('Vr/c      NP/NPmax      NP       CF         TPI')
fprintf('%5.4f   %5.4f   %5.4f    %5.4f       %5.4f\n',VrBYcTur,NPbyNPmax,NPtur,CFtur,TPItur)

pncftpi=[k,c,p,q,NPmax,CFmax,TPImax,VrBYcTur,NPbyNPmax,NPtur,CFtur,TPItur];


%% Plot TPI
% plotTPI(size2,VrBYc,NP,CF,TPI);
%Plot normalized power
plot(VrBYc,NP(1,1:size2),'--','LineWidth',2)
hold all;
%Plot capacity factor
plot(VrBYc,CF(1,1:size2),'-*','LineWidth',2)
%Plot TPI in the same plot
plot(VrBYc,TPI(1,1:size2),'-o','LineWidth',2)

% title('Turbine Performance Curve','fontsize',14,'fontweight','b','color','k')
legend('NP','CF','TPI')
xlabel('Normalized Rated Speed (Vr/c)','fontsize',14,'fontweight','b','color','k')
ylabel('CF,NP,TPI','fontsize',14,'fontweight','b','color','k')





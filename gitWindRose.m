%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This programs plots wind rose for hourly wind speed and direction
% The turbine parameters need to be provided as inputs
% This program uses the WindRose function by Daniel Pereira 
% $Author: Dr. Rajat Kanti Samal$ $Date: 11-May-2021 $    $Version: 1.0 $
% $Veer Surendra Sai University of Technology, Burla, Odisha, India$

clc;
clear; 

%% Read data
periodC=1; %input('Enter Period: 1-Year;2-Month;3-Seasons-->'); 
mon=16; % 0-year; 1-12 months; 13-16 winter to autumn.
disp('Now reading wind speed data...')
windSpeed = wraotDataRfn( periodC,mon );
speed = windSpeed; 
disp('Now reading wind direction data...')
windDir = wraotDirRfn( periodC,mon );
direction = windDir; 

%% Define options for the wind rose 
Options = {'anglenorth',0,... 'The angle in the north is 0 deg (this is the reference from our data, but can be any other)
           'angleeast',90,... 'The angle in the east is 90 deg
           'labels',{'N (0°)','E (90°)','S (180°)','W (270°)'},... 'If you change the reference angles, do not forget to change the labels.
           'freqlabelangle',45};

%% Launch the windrose with necessary output arguments.
[figure_handle,count,speeds,directions,Table] = WindRose(direction,speed,Options);


function [power]=gitWTPCfn(v,Prated,Vcutin,Vrated,Vfurling)
%% This function implements linear power curve of wind turbines
%   the turbine parameters need to be provided as inputs
% $Author: Dr. Rajat Kanti Samal$ $Date: 2022/01/29 18:23:52 $    $Version: 1.0 $
% $Veer Surendra Sai University of Technology, Burla, Odisha, India$

if(v<Vcutin)
    power=0;
elseif (v>=Vcutin && v<Vrated)
    power=Prated*((v-Vcutin)/(Vrated-Vcutin));
elseif (v>=Vrated && v<Vfurling)
    power=Prated;
elseif (v>=Vfurling) 
    power=0;
else
    disp('No such wind speed.')
end

end % end of function


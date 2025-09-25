%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%                    LATEXtools                         %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%  This  file  is  free software ;  it  is distributed  in  %
%%  the hope that  it  will  be  useful,  but  without  any  %
%%  warranty.  You  can  redistribute  it and/or modify  it  %
%%  under  the  terms  of  the  GNU  General Public License  %
%%  as  published  by  the   Free  Software  Foundation  at  %
%%       http://www.gnu.org/copyleft/gpl.html                %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%
%% This function listen the vessel frame on the vessel intranet
%% and provide the actual vessel position
%%
%% NB: tested only on Linux
%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%
%% 27/05/17 andrea.doglioli@univ-amu.fr and gilles.rougier@ifremer.fr: creation
%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [time,lon,lat]=get_vessel_frame(port)

%%% the Linux command nc allow to listen the different frames
%%% passing by the chosen port.
%%% To obtain lon and lat use the $INGGA frame
%%% the function can be developed to listen other frame and 
%%% provide more information (e.g. depth, speed, etc.)
result=['------'];
while ~strcmp(result(1:6),'$INGGA')
mycommand=['nc -l -u -p ',num2str(port),' -w0'];
[status,result]=system(mycommand);
end

%%% time assigned using the day of the computer and the hour of the
%%% of the listen frame
time=datenum([datestr(now,'ddmmyy '),result(8:13)],'ddmmyy HHMMSS');
%%% coordinate are converted in the degree.decimal convention
lat=degmin_to_decideg(str2num(result(18:19)),str2num(result(20:27)));
lon=degmin_to_decideg(str2num(result(31:33)),str2num(result(34:41)));

return




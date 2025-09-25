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
%This script reads the ascii file output of an hyperterminal connected by serail port to the vessel poisiotning system
% and writea .mat file
%%% !!!! CHECK number of lines in order to obtain verctors time,lon and lat of the same size!!!!
%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%
%% 03/05/16 AD: new version
%% 24/06/13 : andrea.doglioli@univ-amu.fr : first official release
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear;close all;
%%
scriptname=mfilename;eval(['help ',scriptname]);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%
LATEXtools_cruise
LATEXtools_param

%function [time_vessel,lon_vessel,lat_vessel]=get_vessel_frame_fromfile(fname)
fname='Navigation_Trimble_BHO-BBP_20180430';

fid=fopen([fname,'.TXT']);
string = textscan(fid,'%s');
pipo=string{:};
fclose(fid);

piposize=size(pipo);

idat=0;

for i=1:piposize;

linepipo=pipo(i);

linepipotxt=linepipo{:};

[iii,jjj]=size(linepipotxt);

if (jjj>3)


%$GPZDA,093110.02,29,04,2018
if strcmp(linepipotxt(1:6),'$GPZDA')

idat=idat+1;

HH=str2num(linepipotxt(8:9));
MM=str2num(linepipotxt(10:11));
SS=str2num(linepipotxt(12:13));
dd=str2num(linepipotxt(18:19));
mm=str2num(linepipotxt(21:22));
yy=str2num(linepipotxt(24:27));

time_vessel(idat)=datenum(yy,mm,dd,HH,MM,SS);
%datestr(time_vessel,'dd-mmm-yy HH:MM:SS')

%pause
elseif strcmp(linepipotxt(1:6),'$GPRMC')

%$GPRMC,093110.00,A,3932.88636132,N,00238.01900505,E,0.035,202.042,290418,1.0190,E,D*0C
latdeg=str2num(linepipotxt(20:21));
latmin=str2num(linepipotxt(22:32));

lat_vessel(idat)=degmin_to_decideg(latdeg,latmin);

londeg=str2num(linepipotxt(35:38));
lonmin=str2num(linepipotxt(39:49));

lon_vessel(idat)=degmin_to_decideg(londeg,lonmin);

%pause
end%if

%lat=degmin_to_decideg(str2num(res(18:19)),str2num(res(20:27)));
%lon=degmin_to_decideg(str2num(res(31:33)),str2num(res(34:41)))

end%if

end%for

save([cruise_name,'/data/',fname,'.mat'],'time_vessel','lon_vessel','lat_vessel')


return




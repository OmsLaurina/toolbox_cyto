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
%% Script for drawing a geographical map with satellite CHL-a  
%% and CHL-a from onboard fluorimeter
%% 
%% INPUT : coastline .mat file
%%         colormap_Pierre.txt
%%
%% OUTPUT: PNG file with a m_map plot
%%
%% ALGORITHM: computation of the projection and plotting
%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%
%% 03/05/16 AD: new version
%% 24/06/13 : andrea.doglioli@univ-amu.fr : first official release
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [time_CYTO_nav,lon_CYTO_nav,lat_CYTO_nav]=load_CYTO_nav

load('BIOSWOT-Medtrimble.mat')%%% date of the beginne of the cruise ontaine with get_vessel_fram_from_file

[trash,inisize]=size(time_vessel);

time_CYTO_nav=time_vessel;
lat_CYTO_nav=lat_vessel;
lon_CYTO_nav=lon_vessel;

%%%%%
fname='SWOT_Navigation_Cytometre.log.modif'

fid=fopen([fname]);
%$GPRMC 095442.00 A 3908.32919515 N 00510.47730438 E 8.353 240.236 010518 1.5867 E D*0D
format = '%s %s %s %s %s %s %s %d %d %s %d %s %s';
data= textscan(fid,format);
fclose(fid);

pipo=data{:};
piposize=size(pipo);

for i=1:piposize

HHMMSS=data{2}(i);
HHMMSS_txt=HHMMSS{:};
ddmmyy=data{10}(i);
ddmmyy_txt=ddmmyy{:};

HH=str2num(HHMMSS_txt(1:2));
MM=str2num(HHMMSS_txt(3:4));
SS=str2num(HHMMSS_txt(5:6));
dd=str2num(ddmmyy_txt(1:2));
mm=str2num(ddmmyy_txt(3:4));
yy=str2num(ddmmyy_txt(5:6))+2000;

time_CYTO_nav(inisize+i)=datenum(yy,mm,dd,HH,MM,SS);
%datestr(time_CYTO_nav(inisize+i),'dd-mmm-yy HH:MM:SS')
%pause

lat=data{4}(i);
lat_txt=lat{:};
latdeg=str2num(lat_txt(1:2));
latmin=str2num(lat_txt(3:13));
lat_CYTO_nav(inisize+i)=degmin_to_decideg(latdeg,latmin);

lon=data{6}(i);
lon_txt=lon{:};
londeg=str2num(lon_txt(1:3));
lonmin=str2num(lon_txt(4:14));
lon_CYTO_nav(inisize+i)=degmin_to_decideg(londeg,lonmin);


end%for

save([fname,'.mat'],'time_CYTO_nav','lon_CYTO_nav','lat_CYTO_nav')


return


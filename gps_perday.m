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
%% Divise GPS data day per day
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%
%% 12/04/2023 Laurina Oms
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear;close all;
%%
scriptname=mfilename;eval(['help ',scriptname]);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

run('set_dir_global.m');

global dir_gps
CSWOT_NAV = readtable('CSWOT_NAV.txt','HeaderLines', 1, 'Delimiter', '\t');
time = CSWOT_NAV.Var1;
lat = CSWOT_NAV.Var2;
lon = CSWOT_NAV.Var3;
filename = 'GPS';
fname = fullfile(dir_gps, filename);
save(fname, 'time','lat','lon');

plot(lon,lat)

load(fullfile(dir_gps, 'GPS.mat'));

datetime_array = time;%datetime(time, 'ConvertFrom','datenum', 'Format','yyyy-MM-dd HH:mm:SS');
unique_dates = unique(dateshift(datetime_array, 'start', 'day'));

for i = 1:length(unique_dates)
    indices = find(dateshift(datetime_array, 'start', 'day') == unique_dates(i));
    date_gps = time(indices);
    lat_gps = lat(indices);
    lon_gps = lon(indices);
    filename = strcat('GPS_', datestr(unique_dates(i), 'yyyy-mm-dd'), '.mat');
    
    fname = fullfile(dir_gps, filename);
    save(fname, 'date_gps', 'lat_gps', 'lon_gps');
end
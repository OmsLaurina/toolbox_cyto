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
%% This script create a .mat with synchronize date from cytometry file with date from GPS files
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%
%% 27/03/2023 Laurina Oms
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear;close all;
%%
scriptname=mfilename;eval(['help ',scriptname]);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%run('transform_cyto_files.m');

run('set_dir_global.m');
global dir_global dir_output_global_L2
dir = dir(fullfile(dir_global, 'data/cyto/L2/calypsotest/mat_cyto_*'));
files = {dir.name}';

global dir_gps
load(fullfile(dir_gps, 'GPS.mat'));
time_interval=[datenum('17-Feb-2022 00:00:00') datenum('11-Mar-2022 00:00:00')];

%!!! Define the time interval for cytometry data
ii = find(GPS.time>time_interval(1) & GPS.time<time_interval(2));
lon_gps = GPS.lon(ii)';
lat_gps = GPS.lat(ii)';
time_vessel=GPS.time(ii);
time_gps = datetime(time_vessel', 'ConvertFrom','datenum', 'Format','yyyy-MM-dd HH:mm:SS');

% % TEST with random positions
% start_date = datetime(2023,03,20);
% end_date = datetime(2023,03,26);
% lon_gps = 2 + 1*rand(1,1000);
% lat_gps = 48 + 1*rand(1,1000);
% % lon_gps=decideg_to_degmin(lon_gps,'lon');
% % lat_gps=decideg_to_degmin(lat_gps,'lat');
% time_vessel = start_date + (end_date - start_date).*rand(1,1000);
% time_gps = time_vessel';

A=table(time_gps',lon_gps',lat_gps');
A = renamevars(A, 'Var1', 'common_date');
A = renamevars(A, 'Var2', 'longitude');
A = renamevars(A, 'Var3', 'latitude');
%A.date_gps = time_gps;
A = table2timetable(A);

for i = 1:numel(files)
    load(files{i});
    time_cyto=datetime(T.Time,'Format','yyyy-MM-dd HH:mm:SS');
    B = table(time_cyto);
    B.date_cyto = time_cyto;
    B = table2timetable(B);
    C = synchronize(A,B,'hourly','mean');
    C = rmmissing(C);
    phyto_groups=T(:,2:end);
    DATA = horzcat(C,T(:,2:end));
    %DATA(:, {'date_gps', 'date_cyto'}) = [];
    
    fname = fullfile(dir_output_global_L2, sprintf('final_%s.mat', cell2mat(files(i))));
    save(fname, 'DATA');
    
    disp(i)
end
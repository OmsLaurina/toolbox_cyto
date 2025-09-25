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

run('transform_cyto_files.m');
%run('gps_perday.m');
run('save_nav.m');

clear;close all;

global dir_global dir_output_global_L2
dircyto = dir(fullfile(dir_output_global_L2, 'mat_cyto_*'));
files = {dircyto.name}';

global dir_gps
dirgps = dir(fullfile(dir_gps, 'GPS.mat'));
files_gps = {dirgps.name}';

for i = 1:numel(files)
    
    load(files{i});
    time_cyto=datetime(T.Time,'Format','yyyy-MM-dd HH:mm:SS');
    B = table(time_cyto);
    B.date_cyto = time_cyto;
    B = table2timetable(B);
    
    load(files_gps{1});
    %time_gps = datetime(date_gps, 'ConvertFrom','datenum', 'Format','yyyy-MM-dd HH:mm:SS');
    time_gps = time;
    lon_gps = lon;
    lat_gps = lat;
    A=table(time_gps, lon_gps,lat_gps);
    A.date_gps = time_gps;
    A = table2timetable(A);

    % Obtenir les dates communes à une marge d'erreur de 2 minutes
    %[~, ia, ib] = intersect(round(datenum(date_gps)./(1/24/60)), round(datenum(T.Time)./(1/24/60)), 'stable');
    [~, ia, ib] = intersect(round(datenum(A.date_gps)./(1/24)), round(datenum(T.Time)./(1/24)), 'stable');

    % Sélectionner les données correspondantes aux dates communes
    A_common = A(ia,:);
    B_common = B(ib,:);
    phyto_groups=T(:,2:end);
    DATA = horzcat(A_common,T(:,2:end));
    DATA(:, {'date_gps'}) = [];
    fname = fullfile(dir_output_global_L2, sprintf('final_%s.mat', cell2mat(files(i))));
    save(fname, 'DATA');
end
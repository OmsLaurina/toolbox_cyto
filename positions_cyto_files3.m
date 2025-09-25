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
run('save_nav.m');

clear;close all;

global dir_output_global_L2
dircyto = dir(fullfile(dir_output_global_L2, 'mat_cyto_*'));
files = {dircyto.name}';

% dirchl = dir(fullfile(dir_output_global_L2, 'mat_chl_*'));
% files_chl = {dirchl.name}';

global dir_gps_L1
dirgps = dir(fullfile(dir_gps_L1, '2023*.mat'));
files_gps = {dirgps.name}';

for i = 1:numel(files)
    
    load(files{i});
    time_cyto=datetime(T.Time,'Format','yyyy-MM-dd HH:mm:SS');
    time_cyto_num=datenum(time_cyto);
    
    load(files_gps{i});
    time_gps_num=date_gps+datenum('30-Dec-1899');
    
    lat_interp = interp1(time_gps_num, lat_gps, time_cyto_num);
    lon_interp = interp1(time_gps_num, lon_gps, time_cyto_num);

    DATA=addvars(T, lat_interp, lon_interp);

    plot(lon_interp, lat_interp)
    hold on

    fname = fullfile(dir_output_global_L2, sprintf('final_%s.mat', cell2mat(files(i))));
    save(fname, 'DATA');
end

%%% SAME FOR CHL FILES

% for i = 1:numel(files_chl)
%     
%     load(files_chl{i});
%     time_cyto=datetime(T_chl.Time,'Format','yyyy-MM-dd HH:mm:SS');
%     time_cyto_num=datenum(time_cyto);
%     
%     load(files_gps{i});
%     time_gps_num=date_gps+datenum('30-Dec-1899');
%     
%     lat_interp = interp1(time_gps_num, lat_gps, time_cyto_num);
%     lon_interp = interp1(time_gps_num, lon_gps, time_cyto_num);
% 
%     DATA_chl=addvars(T_chl, lat_interp, lon_interp);
% 
%     plot(lon_interp, lat_interp)
%     hold on
% 
%     fname = fullfile(dir_output_global_L2, sprintf('final_%s.mat', cell2mat(files_chl(i))));
%     save(fname, 'DATA_chl');
% end


% %FOR MAPPING
% data_cell = cell(1, numel(files));
% 
% for i = 1:numel(files)
%     
%     load(files{i});
%     time_cyto=datetime(T.Time,'Format','yyyy-MM-dd HH:mm:SS');
%     time_cyto_num=datenum(time_cyto);
%     
%     load(files_gps{i});
%     time_gps_num=date_gps+datenum('30-Dec-1899');
%     
%     lat_interp = interp1(time_gps_num, lat_gps, time_cyto_num);
%     lon_interp = interp1(time_gps_num, lon_gps, time_cyto_num);
% 
%     DATA=addvars(T, lat_interp, lon_interp);
%     data_cell{i} = table2timetable(DATA);
% 
% end
% max_len = max(cellfun(@(x) height(x), data_cell));
% 
% var_names = DATA.Properties.VariableNames;
% var_names=var_names(2:10);
% data_fixed = cellfun(@(x) [x; array2table(NaN(max_len-height(x), width(x)), 'VariableNames', var_names)], data_cell, 'UniformOutput', false);
% DATA = vertcat(data_fixed{:});
% 
% 
% fname = fullfile(dir_output_global_L2, sprintf('final_%s.mat', cell2mat(files(i))));
% save(fname, 'DATA');
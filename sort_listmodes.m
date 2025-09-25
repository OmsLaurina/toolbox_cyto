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
% Select phyto for FLR6 and FLR25
%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%
%% 06/04/2023 Laurina Oms
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear;close all;
%%
scriptname=mfilename;eval(['help ',scriptname]);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%NS
date_start = datetime('2018-05-08');
date_end = datetime('2018-05-10');
files = dir('data_cyto/Processed_*/2018-*');
dir_names = {};

for i = 1:length(files)
    if files(i).isdir && ~strcmp(files(i).name,'.') && ~strcmp(files(i).name,'..')
        folder_date = datetime(files(i).name,'InputFormat','yyyy-MM-dd');
        if folder_date >= date_start && folder_date <= date_end
            dir_names = [dir_names; files(i).name];
        end
    end
end
disp(dir_names);

%FLR6
for i = 1:length(dir_names)
    if i ==1
        cd(['data_cyto/Processed_FLR6/' dir_names{i}]);
    else
        cd 'data_cyto/Processed_FLR6/'
        cd([dir_names{i}]);
    end
    
    files_FLR6 = dir('*.csv');
    files_FLR6 = files_FLR6(endsWith({files_FLR6.name}, 'synechococcus.csv') | endsWith({files_FLR6.name}, 'red_pico_euk.csv')| endsWith({files_FLR6.name}, 'red_pico_2.csv'));

    for k = 1:length(files_FLR6)
        disp(['- ' files_FLR6(k).name]);
    end
    
    cd('../../..');
    
    str_start='FLR6 ';
    str_end='_';

    for j = 1:length(files_FLR6)
        name_files = {files_FLR6(j).name};
        time = extractBetween(name_files, str_start, str_end);
        time = strrep(time,'h',':');
        time_str = string(time);
        name_phyto = extractBetween(name_files, 'FLR6 ', '.csv');
        name_phyto = string(name_phyto);
        T=datetime(time);
        data=readtable(char(name_files), 'Delimiter', ',');
        T = repmat(T, size(data,1), 1);
        D = timetable(T,data);
        D.Properties.RowTimes = D.Properties.RowTimes - minutes(20);

        fname = fullfile('outputs/', sprintf('listmode_%s.mat', name_phyto));
        save(fname, 'D');
    end
end

%FLR25
for i = 1:length(dir_names)
    if i ==1
        cd(['data_cyto/Processed_FLR25/' dir_names{i}]);
    else
        cd 'data_cyto/Processed_FLR25/'
        cd([dir_names{i}]);
    end
    
    files_FLR25 = dir('*.csv');
    files_FLR25 = files_FLR25(endsWith({files_FLR25.name}, 'microphyto_Listmode.csv') | endsWith({files_FLR25.name}, 'red_nano_euk_Listmode.csv')| endsWith({files_FLR25.name}, 'red-nano-euk-sws_Listmode.csv')| endsWith({files_FLR25.name}, 'red-pico-euk-3_Listmode.csv')| endsWith({files_FLR25.name}, 'pico_HFLR_Listmode.csv'));

    for k = 1:length(files_FLR25)
        disp(['- ' files_FLR25(k).name]);
    end

    cd('../../..');
    
    str_start='IIF ';
    str_end='_';
    for j = 1:length(files_FLR25)
        name_files = {files_FLR25(j).name};
        time = extractBetween(name_files, str_start, str_end);
        time = strrep(time,'h',':');
        time_str = string(time);
        name_phyto = extractBetween(name_files, 'IIF ', 'Listmode.csv');
        name_phyto = string(name_phyto);
        T=datetime(time);
        data=readtable(char(name_files), 'Delimiter', ',');
        T = repmat(T, size(data,1), 1);
        D = timetable(T,data);

        fname = fullfile('outputs/', sprintf('listmode_%s.mat', name_phyto));
        save(fname, 'D');
    end

end

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
%% This script create a .mat with synchronize date from cytometry listmode file with date from TSG files
%% and separated data by water masses
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%
%% 27/03/2023 Laurina Oms
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear;close all;
%%
scriptname=mfilename;eval(['help ',scriptname]);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

run('sort_listmodes.m');

clear;close all;

dir_listmode = dir('outputs/listmode*');
out1='water_A/';
out2='water_B/';
% out3='/home/loms/Documents/rODEo_share/Hipp_WE/Listmode_files/water_A/';
% out4='/home/loms/Documents/rODEo_share/Hipp_WE/Listmode_files/water_B/';
files = {dir_listmode.name}';

% TSG data for positions
f_txt2csv('Bureau/STAGE_M2_v2/DATA_PHY_BIOSWOT2018/TSG/DATA/cuve_data.txt', 'inputs/TSG.csv')
TSG = readtable('TSG.csv', 'Delimiter', ',');
lon = TSG.Var4;
lat = TSG.Var3;
Date = TSG.Var1;
Heure = TSG.Var2;

date_time = datetime(string(Date), 'Format', 'yyyy-MM-dd');
heure_time = datetime(string(Heure), 'Format', 'HH:mm:ss');
Time_TSG = datetime([date_time + hours(heure_time.Hour) + minutes(heure_time.Minute) + seconds(heure_time.Second)], 'Format', 'yyyy-MM-dd HH:mm:ss');
Time_TSG_num=datenum(Time_TSG);

A=table(Time_TSG,lon,lat);

%NS
time_interval_NS=[datenum('11-May-2018 02:00:00') datenum('13-May-2018 8:30:00')];
NS = find(Time_TSG_num>=time_interval_NS(1) & Time_TSG_num<=time_interval_NS(2));
time_NS=A.Time_TSG(NS);
lat_NS=A.lat(NS);
lon_NS=A.lon(NS);
data_NS=A(NS,:);

waterA = find(lat_NS>=38.5);
time_NS_waterA=time_NS(waterA);
lat_NS_waterA=lat_NS(waterA);
lon_NS_waterA=lon_NS(waterA);
data_NS_waterA=data_NS(waterA,:);

waterB = find(lat_NS<38.5);
time_NS_waterB=time_NS(waterB);
lat_NS_waterB=lat_NS(waterB);
lon_NS_waterB=lon_NS(waterB);
data_NS_waterB=data_NS(waterB,:);

% %WE
% time_interval_WE=[datenum('08-May-2018 15:30:00') datenum('10-May-2018 17:30:00')];
% WE = find(Time_TSG_num>=time_interval_WE(1) & Time_TSG_num<=time_interval_WE(2));
% time_WE=A.Time_TSG(WE);
% lat_WE=A.lat(WE);
% lon_WE=A.lon(WE);
% data_WE=A(WE,:);
% 
% waterA = find(lon_WE>=4);
% time_WE_waterA=time_WE(waterA);
% lat_WE_waterA=lat_WE(waterA);
% lon_WE_waterA=lon_WE(waterA);
% data_WE_waterA=data_WE(waterA,:);
% 
% waterB = find(lon_WE<4);
% time_WE_waterB=time_WE(waterB);
% lat_WE_waterB=lat_WE(waterB);
% lon_WE_waterB=lon_WE(waterB);
% data_WE_waterB=data_WE(waterB,:);

% Loop on files listmodes to separate by water masses
%NS
for i = 1:numel(files)
    load(files{i});
    time_listmode=datetime(D.T,'Format','yyyy-MM-dd HH:mm:SS');
    
    if ismember(time_listmode-minutes(9),time_NS_waterA)
        disp('cc')
        fname = fullfile(out1, sprintf('%s', string(files{i})));
        save(fname, 'D');
    end
     if ismember(time_listmode-minutes(9),time_NS_waterB)
        disp('nn')
        fname = fullfile(out2, sprintf('%s', string(files{i})));
        save(fname, 'D'); 
    end
end

% %WE
% for i = 1:numel(files)
%     load(files{i});
%     time_listmode=datetime(D.T,'Format','yyyy-MM-dd HH:mm:SS');
%     
%     if ismember(time_listmode-minutes(9),time_WE_waterA)
%         disp('waterA')
%         fname = fullfile(out3, sprintf('%s', string(files{i})));
%         save(fname, 'D');
%     end
%      if ismember(time_listmode-minutes(9),time_WE_waterB)
%         disp('waterB')
%         fname = fullfile(out4, sprintf('%s', string(files{i})));
%         save(fname, 'D'); 
%     end
% end

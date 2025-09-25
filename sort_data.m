%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%         Separe data by hippodrome and by water masses       %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Author : Laurina Oms                                       %%%
%%% Creation : 06/04/2023                                      %%%     
%%% Region : Mediteranean Sea                                  %%%
%%% cruise : PROTEVS-SWOT 2018                                 %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear;close all;

% import data
f_txt2csv('data_CYTO.txt', 'inputs/data_CYTO.csv')
data=readtable('data_CYTO.csv');

% outputs directories
out1='/home/loms/Documents/rODEo_share/Hipp_NS/Position_abundances_files/water_A/cyto_NS_waterA.csv';
out2='/home/loms/Documents/rODEo_share/Hipp_NS/Position_abundances_files/water_B/cyto_NS_waterB.csv';
out3='/home/loms/Documents/rODEo_share/Hipp_WE/Position_abundances_files/water_A/cyto_WE_waterA.csv';
out4='/home/loms/Documents/rODEo_share/Hipp_WE/Position_abundances_files/water_B/cyto_WE_waterB.csv';

%
time=data.Time;
time_num=datenum(time);
lat=data.Lat;
lon=data.Lon;

%!!! Define the time interval for hipp NS ans hipp WE

%%%% NS
time_interval_NS=[datenum('11-May-2018 02:00:00') datenum('13-May-2018 8:30:00')];
NS = find(time_num>=time_interval_NS(1) & time_num<=time_interval_NS(2));
time_NS=time(NS);
lat_NS=lat(NS);
lon_NS=lon(NS);
data_NS=data(NS,:);

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

writetable(data_NS_waterA,out1)
writetable(data_NS_waterB,out2)

%%%% WE
time_interval_WE=[datenum('08-May-2018 15:30:00') datenum('10-May-2018 17:30:00')];
WE = find(time_num>=time_interval_WE(1) & time_num<=time_interval_WE(2));
time_WE=time(WE);
lat_WE=lat(WE);
lon_WE=lon(WE);
data_WE=data(WE,:);

waterA = find(lon_WE>=4);
time_WE_waterA=time_WE(waterA);
lat_WE_waterA=lat_WE(waterA);
lon_WE_waterA=lon_WE(waterA);
data_WE_waterA=data_WE(waterA,:);

waterB = find(lon_WE<4);
time_WE_waterB=time_WE(waterB);
lat_WE_waterB=lat_WE(waterB);
lon_WE_waterB=lon_WE(waterB);
data_WE_waterB=data_WE(waterB,:);

writetable(data_WE_waterA,out3)
writetable(data_WE_waterB,out4)

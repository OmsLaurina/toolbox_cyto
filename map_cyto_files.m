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
%% This script plot map of phytoP abundances
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%
%% 27/03/2023 Laurina Oms
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear;close all;
%%
scriptname=mfilename;eval(['help ',scriptname]);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

run('positions_cyto_files3.m');

clear;close all;

global dir_output_global_L3 dir_output_global_L2

dircyto = dir(fullfile(dir_output_global_L2, 'final_mat_cyto_files_2023_05_14*'));
files = {dircyto.name}';

dirchl = dir(fullfile(dir_output_global_L2, 'final_mat_chl_files_2023_05_14*'));
files_chl = {dirchl.name}';

tsgdate='TSG_lonlat_20230514*';

load('utils/gumby.mat')

% min_lon = 4.9;
% max_lon = 5.5;
% min_lat = 40.3;
% max_lat = 41.3;

min_lon = 4.8;
max_lon = 6;
min_lat = 42.1;
max_lat = 43.1;


%Choose your time interval to get the transect
time_interval=[datenum('14-May-2023 00:00:00') datenum('14-May-2023 23:59:59')];
transect='mapping';
% time_interval=[datenum('24-Apr-2023 05:00:00') datenum('24-Apr-2023 10:00:00')];
% transect='transect1';
% time_interval=[datenum('24-Apr-2023 10:00:00') datenum('24-Apr-2023 14:00:00')];
% transect='transect2';
% time_interval=[datenum('24-Apr-2023 17:00:00') datenum('24-Apr-2023 21:00:00')];
% transect='transect3';
% time_interval=[datenum('24-Apr-2023 21:00:00') datenum('25-Apr-2023 01:00:00')];
% transect='transect4';
% time_interval=[datenum('25-Apr-2023 01:00:00') datenum('25-Apr-2023 05:00:00')];
% transect='transect5';


 for i = 1:numel(files)
    load(files{i});
    lon = DATA.lon_interp;
    lat = DATA.lat_interp;
    time = DATA.Time;
    time_str = extractBefore(string(time(1)),' ');
    phyto = DATA(:,2:end-2);
   % phyto = DATA(:,1:end-2);
    
    for j = 1:width(phyto)
        names = phyto.Properties.VariableNames;
        name_phyto=names{:,j};
        ab = phyto(:,j);
   
    ii =find(datenum(time)>time_interval(1) & datenum(time)<time_interval(2));

    h = figure('Visible', 'off', 'NumberTitle', 'off', 'Name', num2str(j));
    hold on
    m_proj('mercator','lon',[min_lon max_lon],'lat',[min_lat max_lat]);
    m_gshhs_h('save','med');
    m_usercoast('med','patch',[.7 .7 .7],'edgecolor','k');
    m_grid('box','fancy','tickdir','in');
    xlabel('Longitude');
    ylabel('Latitude');
    hold on
    abund = ab.Variables;
    m_scatter(lon(ii),lat(ii),20,abund(ii),'filled');
    cbar = colorbar;
    colormap;
    colorTitleHandle = get(cbar,'Title');
    titleString = ({'Abundance','[ \it {cells.cm^{-3}} ]',''});
    set(colorTitleHandle ,'String',titleString);
    hold on
    title({time_str, name_phyto})

    saveas(h,fullfile(pwd,dir_output_global_L3, sprintf('%s%s%s.pdf', time_str, name_phyto,transect)));
    end
    disp(i)  
 end

%%%% MAP PROXY CHL

 for i = 1:numel(files_chl)
    load(files_chl{i});
    lon = DATA_chl.lon_interp;
    lat = DATA_chl.lat_interp;
    time = DATA_chl.Time;
    time_str = extractBefore(string(time(1)),' ');
    chl = DATA_chl(:,2:end-2);
    PROX=[];

    for j = 1:height(chl)
        proxy = mean(table2array(chl(j,:)));
        PROX=[PROX,proxy];
        %PROX=PROX';
    end
   
    ii =find(datenum(time)>time_interval(1) & datenum(time)<time_interval(2));

    h = figure('Visible', 'off', 'NumberTitle', 'off', 'Name', num2str(i));
    hold on
    m_proj('mercator','lon',[min_lon max_lon],'lat',[min_lat max_lat]);
    m_gshhs_h('save','gumby');
    m_usercoast('med','patch',[.7 .7 .7],'edgecolor','k');
    m_grid('box','fancy','tickdir','in');
    xlabel('Longitude');
    ylabel('Latitude');
    hold on
    %proxy_chl= proxy.Variables;
    m_scatter(lon(ii),lat(ii),20,PROX(ii),'filled');
    cbar = colorbar;
    colormap;
    colorTitleHandle = get(cbar,'Title');
    titleString = ({'Total FLR','[ \it {FLR/ml} ]',''});
    set(colorTitleHandle ,'String',titleString);
    hold on
    title({time_str})

    saveas(h,fullfile(pwd,dir_output_global_L3, sprintf('%s%s.pdf', time_str,'chl')));
    disp(i)  
 end

%%% TSG vs CYTO

global dir_tsg_L1 dir_tsg_L2

dir_filestsg = dir(fullfile(dir_tsg_L1, tsgdate));
files_tsg = {dir_filestsg.name}';
load(files_tsg{1})
time_tsg_num=TSG.date_tsg+datenum('30-Dec-1899');


%Salinity
 for i = 1:numel(files)
     load(files{i});
     T_interp = interp1(time_tsg_num, TSG.T_tsg, datenum(DATA.Time));
     S_interp = interp1(time_tsg_num, TSG.S_tsg, datenum(DATA.Time));
     phyto = DATA(:,2:end-2);

     for j = 1:width(phyto)
        names = phyto.Properties.VariableNames;
        name_phyto=names{:,j};
        ab = phyto(:,j);
        ii =find(datenum(time)>time_interval(1) & datenum(time)<time_interval(2));
        abund = ab.Variables;
    
        k = figure('Visible', 'off', 'NumberTitle', 'off', 'Name', num2str(j));
        hold on
        lon = DATA.lon_interp;
        lat = DATA.lat_interp;
        time = DATA.Time;
        time_str = extractBefore(string(time(1)),' ');
        yyaxis left
        scatter(time(ii),abund(ii),'filled')
        hold on
        plot(time(ii),abund(ii))
        yyaxis right
        scatter(time(ii), S_interp(ii),'filled')
        hold on 
        plot(time(ii),S_interp(ii))
        title(name_phyto)
        %xlim([min_lat max_lat])
        saveas(k,fullfile(pwd,dir_output_global_L3, sprintf('%s%s%s%s.pdf', time_str, name_phyto,transect,'Salinity')));
     end
 end

 %Temperature
 for i = 1:numel(files)
     load(files{i});
     T_interp = interp1(time_tsg_num, TSG.T_tsg, datenum(DATA.Time));
     S_interp = interp1(time_tsg_num, TSG.S_tsg, datenum(DATA.Time));
     phyto = DATA(:,2:end-2);

     for j = 1:width(phyto)
        names = phyto.Properties.VariableNames;
        name_phyto=names{:,j};
        ab = phyto(:,j);
        ii =find(datenum(time)>time_interval(1) & datenum(time)<time_interval(2));
        abund = ab.Variables;
    
        k = figure('Visible', 'off', 'NumberTitle', 'off', 'Name', num2str(j));
        hold on
        lon = DATA.lon_interp;
        lat = DATA.lat_interp;
        time = DATA.Time;
        time_str = extractBefore(string(time(1)),' ');
        yyaxis left
        scatter(time(ii),abund(ii),'filled')
        hold on
        plot(time(ii),abund(ii))
        yyaxis right
        scatter(time(ii), T_interp(ii),'filled')
        hold on 
        plot(time(ii),T_interp(ii))
        title(name_phyto)
        %xlim([min_lat max_lat])
        saveas(k,fullfile(pwd,dir_output_global_L3, sprintf('%s%s%s%s.pdf', time_str, name_phyto,transect,'Temperature')));
     end
 end




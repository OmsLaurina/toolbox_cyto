%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%Convert cyto abundances (cell/cm3) into biomasses (mmolC/m3)%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Author : Laurina Oms                                       %%%
%%% Creation : 27/01/2023                                      %%%     
%%% Region : Mediteranean Sea                                  %%%
%%% cruise : PROTEVS-SWOT 2018                                 %%%
%%% Ref : Marrec et al (2018), Menden-Deuer & Lessard (2000)   %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear all, close all
%%

%load data of abundances and FWS

index_hipp = 302:392;

data_ab = dlmread('inputs/data_CYTO_NEW.txt');
data_ab = data_ab(index_hipp,:);

%get date of abundances data
year = data_ab(:,1);
month = data_ab(:,2);
day = data_ab(:,3);
hours = data_ab(:,4);
min = data_ab(:,5);
temp=data_ab(:,21);
sal=data_ab(:,20);
dates_ab = datenum([year,month,day]);

dateFormat = 'yyyy-MM-dd HH:mm:ss';

dates_ab_time = data_ab(:,1:6);
dates_ab_time = datetime(dates_ab_time,'InputFormat', dateFormat);

%get latitude,longitude
lat_ab = data_ab(:,24);
lon_ab = data_ab(:,23);

%extract abundances from files and specifical parameters for chosen group
chosen_group = 'Syne';

if  strcmp(chosen_group, 'Syne')
    ab=data_ab(:,7);
    data_FWS = readtable('inputs/FWS_ALL synechococcus .txt');
    get_PAR_vol_dates = readtable('inputs/PAR_volume_files synechococcus .txt'); %for small phyto
    a = 0.26;
    b = 0.86;
end

if  strcmp(chosen_group, 'PICO1')
    ab=data_ab(:,9);
    data_FWS = readtable('inputs/FWS_ALL red_pico_euk .txt');
    get_PAR_vol_dates = readtable('inputs/PAR_volume_files red_pico_euk .txt'); %for small phyto
    a = 0.26;
    b = 0.86;
end

if  strcmp(chosen_group, 'PICO2')
    ab=data_ab(:,10);
    opts = detectImportOptions('inputs/FWS_ALL red_pico_2 .txt'); opts = setvartype(opts,'double');
    data_FWS=readtable('inputs/FWS_ALL red_pico_2 .txt',opts);
    get_PAR_vol_dates = readtable('inputs/PAR_volume_files red_pico_2 .txt'); %for small phyto
    a = 0.26;
    b = 0.86;
end

if  strcmp(chosen_group, 'PICO3')
    ab=data_ab(:,11);
    opts = detectImportOptions('inputs/FWS_ALL red-pico-euk-3 .txt'); opts = setvartype(opts,'double');
    data_FWS=readtable('inputs/FWS_ALL red-pico-euk-3 .txt',opts);
    get_PAR_vol_dates = readtable('inputs/PAR_volume_files red-pico-euk-3 .txt'); %for small phyto
    a = 0.26;
    b = 0.86;
end

if  strcmp(chosen_group, 'PICOHFLR')
    ab=data_ab(:,15);
    opts = detectImportOptions('inputs/FWS_ALL pico_HFLR .txt'); opts = setvartype(opts,'double');
    data_FWS=readtable('inputs/FWS_ALL pico_HFLR .txt',opts);
    get_PAR_vol_dates = readtable('inputs/PAR_volume_files pico_HFLR .txt'); %for small phyto
    a = 0.26;
    b = 0.86;
end

if  strcmp(chosen_group, 'NANOsws')
    ab=data_ab(:,12);
    data_FWS = readtable('inputs/FWS_ALL red-nano-euk-sws .txt');
    get_PAR_vol_dates = readtable('inputs/PAR_volume_files red-nano-euk-sws .txt'); %for big phyto
    a = 0.433;
    b = 0.863;
end

if  strcmp(chosen_group, 'NANOred')
    ab=data_ab(:,13);
    data_FWS = readtable('inputs/FWS_ALL red_nano_euk .txt');
    get_PAR_vol_dates = readtable('inputs/PAR_volume_files red_nano_euk .txt'); %for big phyto
    a = 0.433;
    b = 0.863;
end

if  strcmp(chosen_group, 'MICRO')
    ab=data_ab(:,14);
    opts = detectImportOptions('inputs/FWS_ALL microphyto .txt'); opts = setvartype(opts,'double');
    data_FWS=readtable('inputs/FWS_ALL microphyto .txt',opts);
    get_PAR_vol_dates = readtable('inputs/PAR_volume_files microphyto .txt'); %for big phyto
    a = 0.433;
    b = 0.863;
end

% transform table
FWS = table2array(data_FWS(:,2:end));

%load data of PAR and get date of PAR data
PAR = get_PAR_vol_dates(:,5);
dates_stringPAR = char(table2array(get_PAR_vol_dates(:,1)));
dates_PAR = datetime(dates_stringPAR, 'InputFormat', dateFormat);
dates_PAR_num = datenum(dates_PAR);

%get data volume
volume_ech = get_PAR_vol_dates(:,4); %uL
volume_ech = table2array(volume_ech);
volume_ech = volume_ech./1000; %uL-->um3



%% Convert abundances to biomasses 

%calcul bioV [um3] methode 1
%coeff cytclus rapporté a un volume
beta_0 = -5.8702; %?
beta_1 = 0.9228;  %?
bioV_um3 = FWS.^beta_1*exp(beta_0);

%plot(log(FWS), log(ESD))

%calcul bioV methode 2
%biov [um3]
%bioV_um3=((4/3)*pi*(ESD./2).^3);

%calcul proportion
for i = 1:length(volume_ech)
    proportion = bioV_um3./volume_ech(i);
end

%calcul Qc [pgC/cell]
Qc=a*bioV_um3.^b;

%calcul biomasse de chaque jour [mmolC/m³]
Qc = Qc.*10^-12; %pg-->g
Qc = Qc./12.011; %g-->molC
Qc = Qc.*10^3; %molC-->mmolC

ab = ab.*10^6; %cm3-->m3

Qc_moy = mean(Qc,'omitnan'); %no NA
Qc_moy = mean(Qc_moy);

biom = ab.*Qc_moy;

% %Table with mean of each variables
% % ESD_moy = mean(ESD,'omitnan');
% % ESD_moy = mean(ESD_moy);
% bioV_moy = mean(bioV_um3,'omitnan');
% bioV_moy = mean(bioV_moy);
% biom_moy = mean(biom,'omitnan');
% 
% %T = table(ESD_moy, bioV_moy, biom_moy, 'VariableNames',{'ESD_mean','bioV_mean','biom_mean'});
% T = table(bioV_moy, biom_moy, 'VariableNames',{'bioV_mean','biom_mean'});
% nom_fichier = [chosen_group,'.mat'];
% chemin = fullfile('outputs/bioV_um3/', nom_fichier);
% save(chemin, 'T');

%% Interp datetime PAR to datetime data_ab

dt1 = dates_ab_time; % datetimes for dataset 1
y1 = ab; % values for dataset 1
dt2 = dates_PAR; % datetimes for dataset 2
y2 = PAR; % values for dataset 2

T1 = timetable(dt1,y1);
T2 = timetable(dt2,y2);

% Find common time range
timeRange = unique([T1.dt1; T2.dt2]);

% Create new timetable with common time range
T1 = T1(ismember(T1.dt1, timeRange), :);
T2 = T2(ismember(T2.dt2, timeRange), :);

% Convert T1 and T2 to arrays
dates1 = T1.dt1;
y1 = T1.y1;
dates2 = T2.dt2;
y2 = T2.y2;
y2 = table2array(y2);

% Convert dates1 and dates2 to numbers using datenum
dates1_num = datenum(dates1);
dates2_num = datenum(dates2);

% Interpolate y2 to match length of y1
y2_interp = interp1(dates2_num, y2, dates1_num);


%% figures

load('inputs/gumby.mat')
lon_min = 2;
lat_min = 37.5;
lon_max = 4.5;
lat_max = 39.5;

%choose lat_ab, lon_ab or PAR for color of points
cvariable=lat_ab;
cvariable_name='Latitude';

%     figure, hold on 
%     box on
%     grid on
% 	swarmchart(dates_ab,biom,30,cvariable,'Filled');
%     boxchart(dates_ab,biom,'BoxFaceColor',[.5 .5 .5],'BoxFaceAlpha',0.1)
%     datetick('x',19)
%     xlabel('Temps')
%     ylabel('Biomasse [mmolC/m³]')
%     colormap cool
%     cbar = colorbar;
%     colorTitleHandle = get(cbar,'Title');
%     titleString = ({cvariable_name});
%     set(colorTitleHandle ,'String',titleString);
% 	title(chosen_group)
%     filename1=['outputs/bioV_um3/boxplot_biom_lat',chosen_group];
%     print('-djpeg','-r300',filename1)
    
    
    %map
    figure('DefaultAxesFontSize',10)
    hold on
    m_proj('mercator','lon',[lon_min lon_max],'lat',[lat_min lat_max])
    hold on
    m_scatter(lon_ab,lat_ab,30,biom,'filled');
    hold on
    %m_gshhs_h('save','gumby');
    m_usercoast('gumby','patch',[.7 .7 .7],'edgecolor','k');
    m_grid('box','fancy','tickdir','in');
    xlabel('Longitude');
    ylabel('Latitude');
    cbar = colorbar;
    colorTitleHandle = get(cbar,'Title');
    titleString = ({'Biomasse [mmolC/m³]'});
    set(colorTitleHandle ,'String',titleString);
    filename2=['outputs/map_biomWE', chosen_group];
    print('-djpeg','-r300', filename2)
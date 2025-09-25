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
%% Define the working directory
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%
%% 12/04/2023 Laurina Oms
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear;close all;
%%
scriptname=mfilename;eval(['help ',scriptname]);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Set the worplace directory

global dir_global
dir_global='Bureau/';

% Set directory where outputs will be saved

global dir_output_global_L1 %stats files from cytoclus
% dir_output_global_L1='tools_Bioswot-med/files_cytoclus/L1/23*/FLR8/';
dir_output_global_L1='cyto_Bioswot-med/L1/23*/FLR8/';

global dir_output_global_L2 %csv files with positions
% dir_output_global_L2 ='tools_Bioswot-med/files_cytoclus/L2/FLR8/';
dir_output_global_L1='cyto_Bioswot-med/L2';

global dir_output_global_L3 %map
dir_output_global_L3='tools_Bioswot-med/files_cytoclus/L3/';

global dir_gps_L0
dir_gps_L0='tools_Bioswot-med/GPS/L0/';

global dir_gps_L1
dir_gps_L1='tools_Bioswot-med/GPS/L1/';

global dir_gps_L1
dir_gps_L2='tools_Bioswot-med/GPS/L2/';

global dir_tsg_L0
dir_tsg_L0 = 'tools_Bioswot-med/TSG/L0/';

global dir_tsg_L1
dir_tsg_L1 = 'tools_Bioswot-med/TSG/L1/';

global dir_tsg_L2
dir_tsg_L2 = 'tools_Bioswot-med/TSG/L2/';

global dir_PAR_L0
dir_PAR_L0='tools_Bioswot-med/PAR/L0/';

global dir_PAR_L1
dir_PAR_L1='tools_Bioswot-med/PAR/L1/';

global dir_ox_L0
dir_ox_L0 = 'tools_Bioswot-med/OX/L0/';

global dir_ox_L1
dir_ox_L1 = 'tools_Bioswot-med/OX/L1/';

global dir_ox_L2
dir_ox_L2 = 'tools_Bioswot-med/OX/L2/';

global dir_ox_L3
dir_ox_L3 = 'tools_Bioswot-med/OX/L3/';

global dir_ox_L4
dir_ox_L4 = 'tools_Bioswot-med/OX/L4/';

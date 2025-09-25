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
% This scripts transform the output .csv files from cytoclus to .csv files
% and .mat files with dot instead of coma as separator
%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%
%% 27/03/2023 Laurina Oms
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear;close all;
%%
scriptname=mfilename;eval(['help ',scriptname]);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

run('set_dir_global.m');

global dir_output_global_L1 dir_output_global_L2
dir = dir(fullfile(dir_output_global_L1, 'set_*'));
files = {dir.name}';

for i = 1:numel(files)
    FileName = files{i};
    Data = fileread(FileName);
    Data = strrep(Data, ',', '.');
    NewFileName = ['sep_dot_',FileName,num2str(i),'.csv'];
    outFilePath = fullfile(dir_output_global_L2, NewFileName);
    FID = fopen(outFilePath, 'w');
    fwrite(FID, Data, 'char');
    fclose(FID);
end

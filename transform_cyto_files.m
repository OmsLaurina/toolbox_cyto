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
%% This scripts make .mat files the cytometry files for classic groups
%% You can add other groups (l.51 to l.83)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%
%% 27/03/2023 Laurina Oms
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear;close all;
%%
scriptname=mfilename;eval(['help ',scriptname]);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

run('coma2dot_cyto_files.m');

clear;close all;

global dir_output_global_L2
dir = dir(fullfile(dir_output_global_L2, 'sep_*'));
files = {dir.name}';

%!!! WARNING !!! TO MODIFY(don't forget spaces):
str_start = 'FLR8 ';
str_end = '.cyz';

if strcmp(str_start, 'FLR8 ')

    for i = 1:numel(files)
        data = readtable(files{i}, 'Delimiter', ';');
        name = data(:,1);
        name = table2array(name);
        time = extractBetween(name, str_start, str_end);
        time = strrep(time,'h',':');
        time_str = string(time(1));
        time_str = extractBefore(time_str,' ');
        time_str = strrep(time_str,'-','_');
        time_char = char(time_str);
        [~,uniqueYearIndex] = unique(time(:,1),'stable');
        DATE = time(uniqueYearIndex,:);
        cluster = data.Set;
        abund = (data.Concentration_n__l_)*10^3; # conversion en cm3
        meanFLR = data.MeanFLRedTotal;
        
        T = timetable(datetime(DATE));
        T_chl = timetable(datetime(DATE));
        
        % !!!! Comment or uncomment the phytoplankton group below : 
        
            %OraPicoProk
            OraPicoProk_index = find(contains(cluster, 'OraPicoProk'));
            if ~isempty(OraPicoProk_index)
                OraPicoProk = abund(OraPicoProk_index);
                OraPicoProk_FLR = meanFLR(OraPicoProk_index);
                OraPicoProk_chl = (OraPicoProk./1000).*OraPicoProk_FLR;
                T = addvars(T, OraPicoProk);
                T_chl = addvars(T_chl,OraPicoProk_chl);
            end 
             
           %RedPico
           RedPico_index= find(~cellfun('isempty',regexp(cluster, '^RedPico$', 'once')));
            if ~isempty(RedPico_index)
                RedPico = abund(RedPico_index);
                RedPico_FLR = meanFLR(RedPico_index);
                RedPico_chl = (RedPico./1000).*RedPico_FLR;
                T = addvars(T, RedPico);
                T_chl = addvars(T_chl,RedPico_chl);
            end 
        
           %RedRedPico
           RedRedPico_index= find(~cellfun('isempty',regexp(cluster, '^RedRedPico$', 'once')));
           if ~isempty(RedRedPico_index)
                RedRedPico = abund(RedRedPico_index);
                RedRedPico_FLR = meanFLR(RedRedPico_index);
                RedRedPico_chl = (RedRedPico./1000).*RedRedPico_FLR;
                T = addvars(T, RedRedPico);
                T_chl = addvars(T_chl,RedRedPico_chl);
           end

           %A PARTIR DU 28/04 20H

           %HsNano
            HsNano_index = find(contains(cluster, 'HsNano'));
            if ~isempty(HsNano_index)
                HsNano = abund(HsNano_index);
                HsNano_FLR = meanFLR(HsNano_index);
                HsNano_chl = (HsNano./1000).*HsNano_FLR;
                T = addvars(T, HsNano);
                T_chl = addvars(T_chl,HsNano_chl);
            end 
    
            %RedNano
           RedNano_index= find(~cellfun('isempty',regexp(cluster, '^RedNano$', 'once')));
            if ~isempty(RedNano_index)
                RedNano = abund(RedNano_index);
                RedNano_FLR = meanFLR(RedNano_index);
                RedNano_chl = (RedNano./1000).*RedNano_FLR;
                T = addvars(T, RedNano);
                T_chl = addvars(T_chl,RedNano_chl);
            end 
    
            %RedRedNano
            RedRedNano_index = find(contains(cluster, 'RedRedNano'));
            if ~isempty(RedRedNano_index)
                RedRedNano = abund(RedRedNano_index);
                RedRedNano_FLR = meanFLR(RedRedNano_index);
                RedRedNano_chl = (RedRedNano./1000).*RedRedNano_FLR;
                T = addvars(T, RedRedNano);
                T_chl = addvars(T_chl,RedRedNano_chl);
            end 
    
            %HfNano
            HfNano_index = find(contains(cluster, 'HfNano'));
            if ~isempty(HfNano_index)
                HfNano = abund(HfNano_index);
                HfNano_FLR = meanFLR(HfNano_index);
                HfNano_chl = (HfNano./1000).*HfNano_FLR;
                T = addvars(T, HfNano);
                T_chl = addvars(T_chl,HfNano_chl);
            end 
       
        T = sortrows(T,'Time');
        T = timetable2table(T);

        T_chl = sortrows(T_chl,'Time');
        T_chl = timetable2table(T_chl);
        
        fname = fullfile(dir_output_global_L2, sprintf('mat_cyto_files_%s.mat', time_str));
        save(fname, 'T');

%         fname_chl = fullfile(dir_output_global_L2, sprintf('mat_chl_files_%s.mat', time_str));
%         save(fname_chl, 'T_chl');
    end
end

if strcmp(str_start, 'FLR25 ')

        for i = 1:numel(files)
        data = readtable(files{i}, 'Delimiter', ';');
        name = data(:,1);
        name = table2array(name);
        time = extractBetween(name, str_start, str_end);
        time = strrep(time,'h',':');
        time_str = string(time(1));
        time_str = extractBefore(time_str,' ');
        time_str = strrep(time_str,'-','_');
        time_char = char(time_str);
        [~,uniqueYearIndex] = unique(time(:,1),'stable');
        DATE = time(uniqueYearIndex,:);
        cluster = data.Set;
        abund = (data.Concentration_n__l_)*10^3;

        T = timetable(datetime(DATE));
        
        % !!!! Comment or uncomment the phytoplankton group below : 

        %OraNano
        OraNano_index = find(contains(cluster, 'OraNano'));
        if ~isempty(OraNano_index)
            OraNano = abund(OraNano_index);
            T = addvars(T, OraNano);
        end 

        %HsNano
        HsNano_index = find(contains(cluster, 'HsNano'));
        if ~isempty(HsNano_index)
            HsNano = abund(HsNano_index);
            T = addvars(T, HsNano);
        end 

        %RedNano
       RedNano_index= find(~cellfun('isempty',regexp(cluster, '^RedNano$', 'once')));
        %RedNano_index = find(contains(cluster, 'RedNano'));
        if ~isempty(RedNano_index)
            RedNano = abund(RedNano_index);
            T = addvars(T, RedNano);
        end 

        %RedRedNano
        RedRedNano_index = find(contains(cluster, 'RedRedNano'));
        if ~isempty(RedRedNano_index)
            RedRedNano = abund(RedRedNano_index);
            T = addvars(T, RedRedNano);
        end 

        %HfNano
        HfNano_index = find(contains(cluster, 'HfNano'));
        if ~isempty(HfNano_index)
            HfNano = abund(HfNano_index);
            T = addvars(T, HfNano);
        end 

%        %DivPico
%         DivPico_index = find(contains(cluster, 'DivPico'));
%         if ~isempty(DivPico_index)
%             DivPico = abund(DivPico_index);
%             T = addvars(T, DivPico);
%         end 
        
        T = sortrows(T,'Time');
        T = timetable2table(T);
        
        fname = fullfile(dir_output_global_L2, sprintf('mat_cyto_files_%s.mat', time_str));
        save(fname, 'T');

        end
end

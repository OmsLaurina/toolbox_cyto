#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Thu Sep 15 16:15:57 2022

@author: roustan

Reading nav and ths files 

few diagnostics plots
"""
import os , glob
import numpy as np 
import pandas as pd
import netCDF4 as nc 
from tools_GIB22 import datestr2num, datenum2str, read_txt
import matplotlib.pyplot as plt



### ---- Usefull functions ----- ### 

def openNC_THS(path) : 
    file=nc.Dataset(path,'r')
    time = file.variables['time'][:]
    temp = file.variables['temp'][:]
    salt = file.variables['salinity'][:]
    file.close()
    return time, temp, salt

def openNC_NAV(path) : 
    file=nc.Dataset(path,'r')
    time = file.variables['time'][:]
    lon = file.variables['long'][:]
    lat = file.variables['lat'][:]
    #depth = file.variables['depth'][:]
    file.close()
    return time, lon, lat

def convert_THS_Time(time): 
    date_ref = '1899-12-30 00:00:00'
    # date_ref= '2000-01-01 00:00:00'
    dt = datestr2num(date_ref)
    return time*86400 + dt 
    
def time_str2num(Time): 
    Time_num = np.zeros(len(Time))
    for i in range(len(Time)) :
        Time_num[i] = datestr2num(Time[i])
    return Time_num

def THS_NAV(date_start, date_end, path_THS = '/run/user/1000/gvfs/smb-share:server=at-nas,share=missioncourante/ARCHIV_NETCDF/DONNEES/THS',
            path_NAV = '/run/user/1000/gvfs/smb-share:server=at-nas,share=missioncourante/ARCHIV_NETCDF/DONNEES/NAV'): 
    
    
    filenames_THS = np.sort(glob.glob('%s/*hydrology-AT_SBE21_01.ths'%path_THS))
    filenames_NAV = np.sort(glob.glob('%s/*-shipnav-AT_CINNA.nav'%path_NAV))
    
    
    
    Time = np.array([])
    Temp = np.array([])
    Salt = np.array([])
    Lon = np.array([])
    Lat = np.array([])
    
    for f_t, f_n in zip(filenames_THS, filenames_NAV) : 
        day_t = f_t.split('/')[-1][:8]
        day_t = datestr2num(day_t[:4]+'-'+day_t[4:6]+'-'+day_t[6:] + ' 00:00') #begining of the file 
        day_n = f_n.split('/')[-1][:8]
        day_n = datestr2num(day_n[:4]+'-'+day_n[4:6]+'-'+day_n[6:] + ' 00:00') #begining of the file 
        if (day_n + 86400 < date_start) and (day_t +86400 < date_start) : #too far from the file  
            continue
        if day_n <= date_end : 
            time_n, lon, lat =  openNC_NAV(f_n) 
            time_n = convert_THS_Time(time_n)
            ind_in = np.where((date_start < time_n) & (time_n < date_end))
            time_n = time_n[ind_in]
            lon = lon[ind_in]
            lat = lat[ind_in]
    
        if day_t < date_end: 
            time_t, temp, salt = openNC_THS(f_t)
            time_t = convert_THS_Time(time_t)
            ind_in = np.where((date_start < time_t) & (time_t < date_end))
            lon_t = np.interp(time_t[ind_in], time_n, lon )
            lat_t = np.interp(time_t[ind_in], time_n, lat )
            Lon = np.concatenate([Lon, lon_t])
            Lat = np.concatenate([Lat, lat_t])
            Time = np.concatenate([Time, time_t[ind_in]])
            Temp = np.concatenate([Temp, temp[ind_in]])
            Salt = np.concatenate([Salt, salt[ind_in]])
        if day_t +86400 > date_end and day_n  + 86400 > date_end : #over
            print('end %s'%f_t)
            break
    return Time, Lon, Lat, Temp, Salt


def NAV_only(date_start, date_end, path_NAV = '/run/user/1000/gvfs/smb-share:server=at-nas,share=missioncourante/ARCHIV_NETCDF/DONNEES/NAV'): 
    
    filenames_NAV = np.sort(glob.glob('%s/*-shipnav-AT_CINNA.nav'%path_NAV))

    Time = np.array([])
    # Temp = np.array([])
    # Salt = np.array([])
    Lon = np.array([])
    Lat = np.array([])
    
    for f_n in filenames_NAV : 
        # day_t = f_t.split('/')[-1][:8]
        # day_t = datestr2num(day_t[:4]+'-'+day_t[4:6]+'-'+day_t[6:] + ' 00:00') #begining of the file 
        day_n = f_n.split('/')[-1][:8]
        day_n = datestr2num(day_n[:4]+'-'+day_n[4:6]+'-'+day_n[6:] + ' 00:00') #begining of the file 
        if (day_n + 86400 < date_start) : #too far from the file  
            continue
        if day_n <= date_end : 
            time_n, lon, lat =  openNC_NAV(f_n) 
            time_n = convert_THS_Time(time_n)
            ind_in = np.where((date_start < time_n) & (time_n < date_end))
            time_n = time_n[ind_in]
            lon = lon[ind_in]
            lat = lat[ind_in]
    
        # if day_t < date_end: 
        #     time_t, temp, salt = openNC_THS(f_t)
        #     time_t = convert_THS_Time(time_t)
        #     ind_in = np.where((date_start < time_t) & (time_t < date_end))
        #     lon_t = np.interp(time_t[ind_in], time_n, lon )
        #     lat_t = np.interp(time_t[ind_in], time_n, lat )
            
            Lon = np.concatenate([Lon, lon])
            Lat = np.concatenate([Lat, lat])
            Time = np.concatenate([Time, time_n])
            # Temp = np.concatenate([Temp, temp[ind_in]])
            # Salt = np.concatenate([Salt, salt[ind_in]])
        if day_n  + 86400 > date_end : #over
            print('end %s'%f_n)
            break
    return Time, Lon, Lat #, Temp, Salt
### ---------------------------- ### 


### --- Using example --- ###

##You might change a bit the path names in THS_NAV function 



# ### Select Dates 
# date_start = datestr2num('2023-03-21 08:59')
# date_end  =  datestr2num('2023-03-22 07:43')


# Time, Lon, Lat, Temp, Salt = THS_NAV(date_start, date_end)

### --- End of the example --- ###





advanced_options = False 

if advanced_options : 
    
    Give_radial = '/Users/roustan/Documents/These/GIB22/DATA/VMADCP/OS150/Radiale_SIPPICAN_FO_1_SI/ATL-GdG2022-150khz-BST-BST-025-STA_withW_DepthDetect.txt' 
    #Give_radial = None
    name = 'Radiale_SIPPICAN_FO_1_SI'
    Lat_print = True
    Lon_print = False
    if not Give_radial is None : 
        data_vmadcp = read_txt(Give_radial)
        date_start = np.array(data_vmadcp['Time'])[0]
        date_end = np.array(data_vmadcp['Time'])[-1]
    
    
    ### ---- Loading Tide ----- ###
    
    path_TIDE = '/Users/roustan/Documents/These/GIB22/DATA/MAREE/brest.txt'
    data = pd.read_csv(path_TIDE, sep = '\t')
    time_tide_s = np.array(data['Time'])
    time_tide = time_str2num(time_tide_s)
    Eta = np.array(data['Eta'])
    ind_in_tide = np.where((date_start <= time_tide) & (time_tide <= date_end))
    time_tide = time_tide[ind_in_tide]
    Eta = Eta[ind_in_tide]
    
    ### ----------------------- ###
    
    
    
    Time, Lon, Lat, Temp, Salt = THS_NAV(date_start, date_end)
    
    
    temp_salt_time_tide = True 
    duree = date_end - date_start
    dt = duree/10 
    t_ticks = [date_start + i*dt for i in range(11)]
    t_labels = [datenum2str(t)[8:13]+'h'+datenum2str(t)[14:16] for t in t_ticks]
    i_t = [np.argmin(np.abs(Time - t_t)) for t_t in t_ticks]
    Lon_labels = ['%.2f'%Lon[i] for i in i_t] 
    Lat_labels = ['%.2f'%Lat[i] for i in i_t] 
    
    if temp_salt_time_tide : 
        plt.figure()
        ax1 = plt.subplot(211)
        plt.scatter(Time, Temp, c = Temp, cmap='jet')
        plt.ylabel('Temp')
        if Lat_print : 
            plt.xticks(t_ticks, Lat_labels)
            plt.xlabel('Time')        
        elif Lon_print : 
            plt.xticks(t_ticks, Lon_labels)
            plt.xlabel('Time')        
        else : 
            plt.xticks(t_ticks, t_labels)
            plt.xlabel('Time')
    
        ax1_t = ax1.twinx()
        plt.plot(time_tide, Eta, label = 'Tide at Brest', linewidth = 3)
        plt.legend()
        plt.xlabel('Hauteur [m]')
        ax1 = plt.subplot(212)
        plt.scatter(Time, Salt, c=Salt, cmap = 'jet')
        plt.ylabel('Salinity')
        plt.xticks(t_ticks, t_labels)
        plt.suptitle('%s'%name)
    

    








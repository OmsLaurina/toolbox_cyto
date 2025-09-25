#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Wed Mar 22 15:48:55 2023

@author: alexandre
"""

from tools_nav import THS_NAV, NAV_only, datestr2num
import netCDF4 as nc4
import matplotlib.pyplot as plt
import numpy as np
import datetime as dt
from matplotlib import cm, ticker, rcParams
from tqdm import tqdm
import os
#import scipy.optimize as opt
#import scipy.ndimage as nd
import scipy.interpolate as interp

path_save='/media/alexandre/HDD/Documents/These/WEMSWOT/THS_NAV/'
    
#%%
date_max=dt.date(2023,4,17)
date_init=dt.date(2023,3,21)

str_max  =  datestr2num(dt.datetime.strftime(date_max,'%Y-%m-%d')+' 16:00')
str_init  =  datestr2num(dt.datetime.strftime(date_init,'%Y-%m-%d')+' 08:00')

Time0, Lon0, Lat0 = NAV_only(str_init, str_max)

#%%
Dt=int((str_max-str_init)/3600)
time_h=[] ; Str_h=[]
for h in tqdm(range(1,Dt)):
    date_h=dt.datetime(2023,3,21,8,0,0)+dt.timedelta(seconds=h*3600)
    Str_h+=[dt.datetime.strftime(date_h,'%Y-%m-%d %H:%M')]
    time_h+=[datestr2num(dt.datetime.strftime(date_h,'%Y-%m-%d %H:%M'))]
    
time_h=np.array(time_h)
Lon_i=interp.interp1d(Time0,Lon0)(time_h)
Lat_i=interp.interp1d(Time0,Lat0)(time_h)

#%%
f = open(path_save+'CSWOT_NAV.txt', 'w')
f.write('Date Hour \t Lat[deg decimaux] \t Lon[deg decimaux] \n')
for i in range(Dt-1):
    f.write(str(Str_h[i])+'  \t  '+'%3.5f'%Lat_i[i]+'  \t '+'%3.5f'%Lon_i[i])
    f.write(' \n ')
f.close()


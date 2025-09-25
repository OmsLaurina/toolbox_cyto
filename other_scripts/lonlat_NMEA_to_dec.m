%   lonlat_NMEA_to_dec(lonlat);  % Convert into degrees.decimal instead of degres minutes.decimal
%%% AD and GR 31/10/2015

function lonlat_decideg=lonlat_NMEA_to_dec(lonlat);

lldeg=fix(lonlat/100);
llmin=lonlat-lldeg*100;
lonlat_decideg=degmin_to_decideg(lldeg,llmin);

return

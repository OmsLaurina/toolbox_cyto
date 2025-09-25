README UTILISATION TOOLBOX CYTO FILES - REGLES DE NOMENCLATURE À RESPECTER ET UTILISATION
 
1. Traitement cytoclus :

nom groupes phytoplanctoniques : nomenclature standardisée cf Thyssen et al 2022 (https://www.frontiersin.org/articles/10.3389/fmars.2022.975877)
nom fichier cyz : "phyto-FLRX année-mois-jour heurehmin.cyz"

----------------------------------------------

2. Les fichiers GPS : 

format input = .mat
noms variables longitude/latitude/temps : 
lon = lon_gps
lat = lat_gps
temps = time_gps
% use gps_perday.mat to separate in n days the gps files
----------------------------------------------

QUELS SCRIPTS MODIFIER:

*Pour ajouter/supprimer des groupes modifiez uniquement le script "transform_cyto_files.m" (l51 à 91) en commentant ou non les groupes et en ajoutant/supprimant les noms à la ligne 90

*Il faut également modifier les lignes 33 et 34 de ce script en fonction du nom de fichier pour extraire la date

*Modifier aussi les noms des dir dans chaque script (à travailler pour ne plus avoir à faire ça)


Pour les scripts .py des positions: 

"Précisions : il faut aller chercher le bon path à mettre comme argument dans la fonction. Avec JB ce qu'on a fait c'est 1) monter les serveurs (smb://at-nas/missioncourante) puis 2) avec un navigateur faire clic droit et choisir l'option "Ouvrir dans un terminal" puis faire pwd"




clear all; close all;

load 'sunspotdata';
sbARMAModel(sunspot, 20, 4);

clear all;
load 'lynxdata';
sbARMAModel(lynx, 20, 4);
sbARMAModel(loglynx, 20, 4);


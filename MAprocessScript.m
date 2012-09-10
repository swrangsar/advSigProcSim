clear all; close all;

load 'sunspotdata';
levinsonDurbinMA(sunspot, 20);

clear all;
load 'lynxdata';
levinsonDurbinMA(lynx, 20);
levinsonDurbinMA(loglynx, 20);


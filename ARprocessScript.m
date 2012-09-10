clear all; close all;

load 'sunspotdata';
levinsonDurbin(sunspot, 20);

clear all;
load 'lynxdata';
levinsonDurbin(lynx, 20);
levinsonDurbin(loglynx, 20);


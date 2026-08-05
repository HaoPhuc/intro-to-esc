%% Prerequisies
clc; clear all; close all;

%% ESC parameters
% Most important parameters
dither_amplitude = 0.1;
dither_freqeuncy = 0.1;
optimizer_gain = 3e-4;

% Remaining parameters
dither_omega = dither_freqeuncy * 2 * pi;
highpass_cutoff_omega = dither_omega / pi;
lowpass_cutoff_omega = dither_omega / pi;
initial_ratio = 0.1;
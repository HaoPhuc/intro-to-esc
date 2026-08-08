%%% Prerequisies
clc; clear all; close all;

%%% ESC parameters

%% Initial parameters
% Adjustable parameters
dither_amplitude = 0.1;
dither_frequency = 0.1;
optimizer_gain = 3e-4;

% Time
t_total = 100;
dt = 0.01;

% System parameters
dither_omega = dither_frequency * 2 * pi;
highpass_cutoff_omega = dither_omega / pi;
lowpass_cutoff_omega = dither_omega / pi;
initial_ratio = 0.1;

%% Settings and background-calculations

% Dynamics (random for each run)
n_D_decay_rate = 1/(1.71 + (rand()-0.5)*0.2); % +- 0.1
n_T_decay_rate = 1/(1.66 + (rand()-0.5)*0.2); % +- 0.1

% Density controller
proportional_gain = 3.129;
integral_gain = 2.482;
total_density_reference = 11.5; % e19 removed for numerical stability
greenwald_density_limit = 11.9; % e19 removed for numerical stability

% Calculate transfer function of dynamics and discretize
n_D_dynamics = ss(-n_D_decay_rate, 1, 1, 0);
n_T_dynamics = ss(-n_T_decay_rate, 1, 1, 0);
n_D_dynamics_discretized = c2d(n_D_dynamics, dt);
n_T_dynamics_discretized = c2d(n_T_dynamics, dt);

% Calculate transfer functions of extremum seeking control and discretize
highpass_filter = tf([1, 0], [1, highpass_cutoff_omega]);
highpass_filter_discretized = c2d(highpass_filter, dt);
lowpass_filter = tf(lowpass_cutoff_omega, [1, lowpass_cutoff_omega]);
lowpass_filter_discretized = c2d(lowpass_filter, dt);

% Calculate initial steady state conditions
initial_nD = 0.25 * (1-initial_ratio) * total_density_reference;
initial_nT = 0.25 * initial_ratio * total_density_reference;

% Ideal fuel ration
ideal_ratio = n_T_decay_rate / (n_T_decay_rate + n_D_decay_rate);
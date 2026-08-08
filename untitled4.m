%% Prerequisites
clc; clear all; close all;

%% ESC parameters (starting values — can be changed live during tuning)
dither_amplitude = 0.1;
dither_frequency = 0.1;
optimizer_gain   = 3e-4;

% System parameters derived from dither frequency
dither_omega = dither_frequency * 2 * pi;
highpass_cutoff_omega = dither_omega / pi;
lowpass_cutoff_omega  = dither_omega / pi;
initial_ratio = 0.1;

%% Settings and background calculations
dt = 0.01;
t_total = 0;

% Dynamics (random each run)
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
[Ad_D, Bd_D, Cd_D, Dd_D] = ssdata(n_D_dynamics_discretized);
[Ad_T, Bd_T, Cd_T, Dd_T] = ssdata(n_T_dynamics_discretized);

% ESC filters, discretized
highpass_filter = tf([1, 0], [1, highpass_cutoff_omega]);
highpass_filter_discretized = c2d(highpass_filter, dt);
lowpass_filter = tf(lowpass_cutoff_omega, [1, lowpass_cutoff_omega]);
lowpass_filter_discretized = c2d(lowpass_filter, dt);
[num_hp, den_hp] = tfdata(highpass_filter_discretized, 'v');
[num_lp, den_lp] = tfdata(lowpass_filter_discretized, 'v');
zi_hp = zeros(max(length(num_hp),length(den_hp))-1,1);
zi_lp = zeros(max(length(num_lp),length(den_lp))-1,1);

% Initial steady-state conditions
initial_nD = 0.25 * (1-initial_ratio) * total_density_reference;
initial_nT = 0.25 * initial_ratio * total_density_reference;
ideal_ratio = n_T_decay_rate / (n_T_decay_rate + n_D_decay_rate);

%% States that persist across chunks
nD = initial_nD;
nT = initial_nT;
r_hat = 0;

% Full-run history (for P(t) and P(r))
t_hist = [];
P_hist = [];
r_hist = [];

% Per-chunk history (for P(a) and P(w) scatter)
a_hist = [];
w_hist = [];
P_avg_hist = [];

%% Figure with 4 subplots
figure;
subplot(2,2,1); h_Pt = plot(nan,nan,'b-'); xlabel('t'); ylabel('P'); title('P(t)'); grid on;
subplot(2,2,2); h_Pr = plot(nan,nan,'b-'); xlabel('r'); ylabel('P'); title('P(r)'); grid on;
subplot(2,2,3); h_Pa = plot(nan,nan,'ko','MarkerFaceColor','k'); xlabel('a'); ylabel('avg P'); title('P(a)'); grid on;
subplot(2,2,4); h_Pw = plot(nan,nan,'ko','MarkerFaceColor','k'); xlabel('\omega'); ylabel('avg P'); title('P(\omega)'); grid on;

%% Main tuning loop
running = true;
while running

    chunk_duration = input('Chunk duration in seconds (Enter=5): ');
    if isempty(chunk_duration), chunk_duration = 5; end

    t_chunk = (t_total : dt : t_total + chunk_duration)';
    n_steps = length(t_chunk);
    P_chunk = nan(n_steps,1);
    r_chunk = nan(n_steps,1);

    for k = 1:n_steps
        t_now = t_chunk(k);

        % --- ESC: perturb the current estimate ---
        r = r_hat + dither_amplitude * sin(dither_omega * t_now);

        % --- PLACEHOLDER PLANT COUPLING ---
        % ASSUMPTION: r sets the fueling ratio between D and T.
        % >>> Replace this with your actual actuator model. <
        u_D = r * total_density_reference;
        u_T = (1 - r) * total_density_reference;

        nD = Ad_D*nD + Bd_D*u_D;
        nT = Ad_T*nT + Bd_T*u_T;

        P = nD * nT;   % cost = fusion reactivity proxy

        % --- ESC: high-pass, demodulate, low-pass, integrate ---
        [hp_out, zi_hp] = filter(num_hp, den_hp, P, zi_hp);
        demod = hp_out * (2/dither_amplitude) * sin(dither_omega * t_now);
        [xi, zi_lp] = filter(num_lp, den_lp, demod, zi_lp);

        r_hat = r_hat + optimizer_gain * xi * dt;

        P_chunk(k) = P;
        r_chunk(k) = r;
    end

    % Append to full history
    t_hist = [t_hist; t_chunk];
    P_hist = [P_hist; P_chunk];
    r_hist = [r_hist; r_chunk];

    % Record this chunk's (a, w, avg P) for scatter plots
    a_hist(end+1) = dither_amplitude;
    w_hist(end+1) = dither_frequency;
    P_avg_hist(end+1) = mean(P_chunk, 'omitnan');

    % Update all 4 plots
    set(h_Pt, 'XData', t_hist, 'YData', P_hist);
    set(h_Pr, 'XData', r_hist, 'YData', P_hist);
    set(h_Pa, 'XData', a_hist, 'YData', P_avg_hist);
    set(h_Pw, 'XData', w_hist, 'YData', P_avg_hist);
    subplot(2,2,1); axis tight;
    subplot(2,2,2); axis tight;
    subplot(2,2,3); axis tight;
    subplot(2,2,4); axis tight;
    drawnow;

    t_total = t_total + chunk_duration;

    % Ask for new parameters
    resp = input(sprintf(['\nCurrent: amp=%.4g, freq=%.4g, gain=%.4g\n', ...
        'Enter new [amp freq gain] (Enter=keep, "q"=quit): '], ...
        dither_amplitude, dither_frequency, optimizer_gain), 's');

    if strcmpi(resp, 'q')
        running = false;
    elseif ~isempty(resp)
        vals = str2num(resp); %#ok<ST2NM>
        if numel(vals) == 3
            dither_amplitude = vals(1);
            dither_frequency = vals(2);
            optimizer_gain   = vals(3);
            % Recompute dependent quantities if frequency changed
            dither_omega = dither_frequency * 2 * pi;
        else
            disp('Could not parse — keeping previous values.');
        end
    end
end
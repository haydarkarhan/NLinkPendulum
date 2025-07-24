%%  This script produces Fig. 5 in the paper
%   Using the selected discretization method (DP), the EKF was used to
%   estimate the angular accelerations. This is converted to joint torques
%   by using Eq. (14). 

clc;clear;close;

EXPORTFIGURES = true;

% Load experiment 6 data
load("data/exp6.mat");

% Link inertias from Solidworks
IC_1   = 2.9315e-6;
IC_j   = 2.9994e-6;
IC_end = 7.6043e-6;

% Make vector to compute torques
I = IC_j*ones(1,10);
I(1) = IC_1;
I(end) = IC_end;

% Compute joint torques as per Eq. (14)
tau = ddth_ekf.*I;

currentDir = pwd;
cd("simulation");

% Load model
mdl = "ndof_simulation";
load_system(mdl);
run("load_params.m");

% Start simulating from this index to make sure inital conditions are well
% defined
idx = 51;

% Set initial condition for simulation
th0 = th_ekf(idx,:);
dth0 = dth_ekf(idx,:);

% Set simulation time and simulate
tsim = t(1:end-idx+1);
Tstop = tsim(end);
set_param(mdl, 'StopTime', num2str(Tstop));
out = sim(mdl);

cd(currentDir);

% Take only the real and estimated values from idx to end
tau = tau(idx:end,:);
th_ekf = th_ekf(idx:end,:);
dth_ekf = dth_ekf(idx:end,:);
th_real = th_real(idx:end,:);

% Squeeze simulated results
tau_sim = squeeze(out.tau_sim)';
th_sim = squeeze(out.th_sim)';
dth_sim = squeeze(out.dth_sim)';

% Select joint to output plots of
jidx = [1 2 8];

t = (0:0.01:10)';
t = t(idx:end) - t(idx);

%% Figure plotting
close all;

figureHeight = 2.5;
figureWidth = 7.16*2.54;

%% Angle figure
f2 = figure;

set(f2, 'DefaultAxesFontSize', 8);
set(f2, 'DefaultFigureColor', 'w');
set(f2, 'defaulttextinterpreter', 'tex');
set(f2, 'DefaultAxesFontName', 'times');

set(gcf, 'Units', 'centimeters');
set(gcf, 'Position', [70 21 figureWidth figureHeight*0.87]);
f2.Color = [1 1 1];
for i = 1:3
    subplot(1,3,i);
    plot(tsim, th_sim(:,jidx(i)), ':k', 'LineWidth', 1.5);
    hold on
    plot(t, th_real(:,jidx(i)), 'LineWidth', 1.3, 'Color', [1 0 0 0.25]);
    plot(t, th_ekf(:,jidx(i)), 'LineWidth', 1.8, 'Color',[0 0 1 0.8]);
    title("Joint " + jidx(i));
    if i == 3
        L2 = legend('Simulated', 'Real','Estimated','Location','east');
        L2.IconColumnWidth = 10;
        L2.Position(1) = 0.909;
        L2.Position(2) = 0.28;
        L2.EdgeColor = [1 1 1];
        ylim([-0.08 0.08])
    end
    if i == 1
        yy2 = ylabel({"Angle"; "[rad]"}, 'VerticalAlignment','bottom', 'HorizontalAlignment', 'center', 'FontWeight', 'bold');
    end
    xlim([0 4]);
    grid on;
    box off
    set(gca, "XTickLabel", {[]});
end

%% Angular velocity figure
f3 = figure;

set(f3, 'DefaultAxesFontSize', 8);
set(f3, 'DefaultFigureColor', 'w');
set(f3, 'defaulttextinterpreter', 'tex');
set(f3, 'DefaultAxesFontName', 'times');

set(gcf, 'Units', 'centimeters');
set(gcf, 'Position', [70 15 figureWidth figureHeight*0.8]);
f3.Color = [1 1 1];
for i = 1:3
    subplot(1,3,i);
    plot(tsim, dth_sim(:,jidx(i)), ':k', 'LineWidth', 1.5);
    hold on;
    plot(t, dth_ekf(:,jidx(i)), 'b', 'LineWidth', 1.8);
    if i == 3
        L3 = legend('Simulated', 'Estimated','Location','east');
        L3.IconColumnWidth = 10;
        L3.Position(1) = 0.909;
        L3.Position(2) = 0.4;
        L3.EdgeColor = [1 1 1];
        ylim([-1 1])
    end
    if i == 1
        yy3= ylabel({"Angular"; "velocity"; "[rad/s]"}, 'VerticalAlignment','bottom', 'HorizontalAlignment', 'center', 'FontWeight', 'bold');
        ylim([-3.5 3.5])
    end
    xlim([0 4]);
    grid on;
    box off
    set(gca, "XTickLabel", {[]});
end

%% Torque figure
f1 = figure;

set(f1, 'DefaultAxesFontSize', 8);
set(f1, 'DefaultFigureColor', 'w');
set(f1, 'defaulttextinterpreter', 'tex');
set(f1, 'DefaultAxesFontName', 'times');

set(gcf, 'Units', 'centimeters');
set(gcf, 'Position', [70 10 figureWidth figureHeight]);
f1.Color = [1 1 1];
for i = 1:3
    subplot(1,3,i);
    plot(tsim, tau_sim(:,jidx(i)), ':k', 'LineWidth', 1.2);
    hold on;
    plot(t, tau(:,jidx(i)), 'b', 'LineWidth', 1.4);
    
    if i == 3
        L1 = legend('Simulated', 'Estimated','Location','east');
        L1.IconColumnWidth = 10;
        L1.Position(1) = 0.909;
        L1.Position(2) = 0.45;
        L1.EdgeColor = [1 1 1];
        ylim([-7e-5 7e-5])
    end
    if i == 1
        yy1 = ylabel({"Torque"; "[Nm]"}, 'VerticalAlignment','bottom', 'HorizontalAlignment', 'center', 'FontWeight', 'bold');
    end
    xlabel("Time [s]", 'FontWeight', 'bold')
    xlim([0 4])
    grid on
    box off
    
end

%% Export figures
if EXPORTFIGURES == true
    dt = string(datetime('now', 'Format', 'ddMMyyyy-HHmm'));
    filename = 'AngleOutput-' + dt + '.eps';
    export_fig(filename, '-c[Inf Inf Inf 38]', f2);

    filename = 'AngVelOutput-' + dt + '.eps';
    export_fig(filename, '-c[Inf Inf Inf 38]', f3);

    filename = 'TorqueOutput-' + dt + '.eps';
    export_fig(filename, '-c[Inf Inf Inf 38]', f1);
end

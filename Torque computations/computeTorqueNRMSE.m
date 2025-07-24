%%  This script computes TABLE III in the paper.
%   The accelerations were estimated online. Gathered data is post
%   processed here to compare the estimated torques (which are computed
%   using Eq. (14)) with the torques that come from the simulation model
%   ndof_simulation.slx

clc;clear;

RMSE = zeros(10, 6);
NRMSE = zeros(10, 6);

% Iterate through 6 experiments
for i = 1:6
    % Load data
    filename = "data\exp" + i + ".mat";
    load(filename);

    % Inertias are obtained from Solidworks analysis
    IC_1   = 2.9315e-6;
    IC_j   = 2.9994e-6;
    IC_end = 7.6043e-6;

    % Make an inertia vector to multiply with torque signal
    I = IC_j*ones(1,10);
    I(1) = IC_1;
    I(end) = IC_end;

    % Multiply accelerations with inertias for torque as per Eq. (14)
    tau_ekf = ddth_ekf.*I;

    currentDir = pwd;
    cd("simulation")

    % Load Simulink model
    mdl = "ndof_simulation";
    load_system("ndof_simulation");

    % Load Simulink Simscape Multibody parameters
    run("load_params.m");

    % Start Simulation from 0.5 seconds (this is done for a better estimate
    % of initial conditions
    idx = 51;
    set_param(mdl, 'StopTime', '9.5');
    
    % Assign initial conditions
    th0 = th_ekf(idx,:);
    dth0 = dth_ekf(idx,:);

    % Start simulating and output torques obtained from simulation
    out = sim(mdl);

    cd(currentDir);
    tau_sim = squeeze(out.tau_sim)';

    % Compute RMSE and NRMSE
    for j = 1:10
        RMSE(j,i) = sqrt(sum((tau_sim(:,j) - tau_ekf(idx:end,j)).^2))/length(tau_sim(:,j));
        NRMSE(j,i) = RMSE(j,i)/(max(tau_sim(:,j)) - min(tau_sim(:,j)));
    end
end

% Turn into percentages
NRMSE = NRMSE*100;

% Remove certain joints for a more compact table
NRMSE([3 4 6 9], :) = [];

% Round to 2 digits after decimal
NRMSE = round(NRMSE, 2);
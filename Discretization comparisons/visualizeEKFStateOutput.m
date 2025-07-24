%% This script generates Fig. 4 in the paper

% Load experiment 1 data from Heun method with 0.01 step size 
load("exp heun 0.010/exp1/exp1_data.mat")

% Select joint to be plotted
jidx = 6;

% Figure settings
set(0, 'DefaultAxesFontSize', 8);
set(0, 'DefaultFigureColor', 'w');
set(0, 'defaulttextinterpreter', 'tex');
set(0, 'DefaultAxesFontName', 'times');
figure
set(gcf, 'Units', 'centimeters');
set(gcf, 'Position', [0 0 8.89 5.5]);

subplot(2,1,1)
plot(t, th_real(:,jidx), 'Color', [1 0 0 0.6]);
hold on;
plot(t, th_ekf(:,jidx), 'b','LineWidth', 1);
grid on;
legend("Raw data","EKF output")
ylabel({"Angle"; "[rad]"}, 'VerticalAlignment','bottom', 'HorizontalAlignment', 'center', 'FontWeight', 'bold');
xlim([0 4])
ylim([-0.1 0.2])
set(gca, 'xticklabel', {[]})
box off

subplot(2,1,2);
plot(t, [diff(th_real(:,jidx)/0.01);0], 'Color', [1 0 0 0.6]);
hold on;
plot(t, dth_ekf(:,jidx), 'b', 'LineWidth',1);
grid on;
legend("Raw data","EKF output")
ylabel({"Angular"; "velocity"; "[rad/s]"}, 'VerticalAlignment','bottom', 'HorizontalAlignment', 'center', 'FontWeight', 'bold');
ylim([-4 9])
xlim([0 4])
xlabel("Time [s]", 'FontWeight', 'bold')
box off

% Export figure
filename = 'EKFOutputCompare-' + string(datetime('now', 'Format', 'ddMMyyyy-HHmm')) + '.eps';
export_fig(filename);
function discData = discretizationData()
%%  This script computes the NRMSE errors across different experiments
%   3 experiments per solver and step size configuration were performed.
%   The NRMSE per experiment and joint is computed, after which the mean is
%   taken to yield a single NRMSE value. The same is performed for the
%   execution time.

% Initialize the variable that computes the mean execution time.
timeMean = 0;

RMSE = zeros(10, 3);
NRMSE = zeros(10, 3);

% Iterate through experiments
for i = 1:3
    % Load saved data
    filename = "exp"+i;
    load(filename+"/"+filename+"_data.mat");
    
    timeMean = timeMean + exec;
    for j = 1:10
        RMSE(j,i) = sqrt(mean((th_real(:,j) - th_ekf(:,j)).^2));
        NRMSE(j,i) = RMSE(j,i)/(max(th_real(:,j)) - min(th_real(:,j)));
    end
end

meanNRMSE = cell(1,3);

for i = 1:10
    meanNRMSE{i} = mean(NRMSE(i,:))*100;
end

execMean = timeMean/3;

discData = [{'euler'}, {'0.01'}, {execMean}, meanNRMSE(:)'];
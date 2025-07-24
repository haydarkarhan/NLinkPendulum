%% This script generates Table II in the paper

% Folder names
dirs = dir;
dirs = dirs([dirs.isdir]);
dirs = dirs(~ismember({dirs.name}, {'.', '..'}));
folderNames = {dirs.name}';

% Save current directory
currentDir = pwd;

cols = cell(1, 7);
names = cell(1, 7);

% Iterate through discretization/step size configuration
for i = 1:length(folderNames)
    cd(folderNames{i})
    
    discData = discretizationData;
    cd(currentDir);

    cols{i} = discData;
    names{i} = [discData{1}, discData{2}];
end

% Initialize row names
rowNames = {'Solver', 'StepSize', 'ExecTime', 'th1', 'th2', 'th3', 'th4', 'th5', ...
            'th6', 'th7', 'th8', 'th9', 'th10'};

% Convert to matrix of cells
Tdata = cell(length(rowNames), length(cols));
for c = 1:length(cols)
    col = cols{c};
    Tdata{1, c} = col{1};
    Tdata{2, c} = col{2};
    for r = 3:13
        Tdata{r, c} = col{r};
    end
end

% Create the table
T = cell2table(Tdata, 'VariableNames', names, 'RowNames', rowNames);
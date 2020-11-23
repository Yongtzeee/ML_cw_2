function DecisionTree(taskType)

% load the datasets
data = readtable('winequality-red_white.csv');

% split dataset into features and labels
features = data(:, 1:size(data, 2)-1);
labels = data(:, size(data, 2));
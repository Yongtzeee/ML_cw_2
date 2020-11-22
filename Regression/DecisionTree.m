function DecisionTree(taskType)

% load the datasets
data_redwine = readtable('winequality-red.csv');
data_whitewine = readtable('winequality-white.csv');

% split dataset into features and labels
features_red = data_redwine(:, 1:size(data_redwine, 2)-1);
features_white = data_whitewine(:, 1:size(data_whitewine, 2)-1);
labels_red = data_redwine(:, size(data_redwine, 2));
labels_white = data_whitewine(:, size(data_whitewine, 2));
function DecisionTree(taskType)

% load the datasets
data = readtable('winequality-red_white.csv');

% split dataset into features and labels
features = data(:, 1:size(data, 2)-1);
labels = data(:, size(data, 2));

% split dataset into train and test datasets
featuresTrain = features(1:3250, :);
featuresTest = features(3251:size(features, 1), :);
labelsTrain = labels(1:3250, :);
labelsTest = labels(3251:size(labels, 1), :);
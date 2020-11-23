function DecisionTree(taskType)

% load datasets and combine them
red_data = readtable('winequality-red.csv', 'PreserveVariableNames', 1);
white_data = readtable('winequality-white.csv', 'PreserveVariableNames', 1);
combined_data = [red_data;white_data];

% Just like frac in pandas, shuffle data 
shape = size(combined_data);
shuffled_data = combined_data(randperm(shape(1)),:);

% split dataset into features and labels
features = shuffled_data(:, 1:size(shuffled_data, 2)-1);
labels = shuffled_data(:, size(shuffled_data, 2));

% split dataset into train and test datasets
featuresTrain = features(1:3250, :);
featuresTest = features(3251:size(features, 1), :);
labelsTrain = labels(1:3250, :);
labelsTest = labels(3251:size(labels, 1), :);

end
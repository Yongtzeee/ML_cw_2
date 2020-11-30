% function DecisionTree(taskType)

% load datasets and combine them
red_data = readtable('winequality-red.csv', 'PreserveVariableNames', 1);
white_data = readtable('winequality-white.csv', 'PreserveVariableNames', 1);
combined_data = [red_data;white_data];

% Just like frac in pandas, shuffle data 
shape = size(combined_data);
shuffled_data = combined_data(randperm(shape(1)),:);

% split dataset into train and test
dataTrain = shuffled_data(1:3250, :); 
dataTest = shuffled_data(3251:size(shuffled_data,1), :);

% split training and test dataset into feature and labels
featuresTrain = dataTrain(:, 1:size(dataTrain, 2)-1);
labelsTrain = dataTrain(:, size(dataTrain, 2));

featuresTest = dataTest(:, 1:size(dataTest, 2)-1);
labelsTest = dataTest(:, size(dataTest, 2));

% Building decision tree here


% end
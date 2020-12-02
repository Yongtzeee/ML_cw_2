function DecisionTree()

% load datasets and combine them
red_data = readtable('../winequality-red.csv', 'PreserveVariableNames', 1);
white_data = readtable('../winequality-white.csv', 'PreserveVariableNames', 1);
combined_data = [red_data;white_data];

% Just like frac in pandas, shuffle data 
shape = size(combined_data);
shuffled_data = combined_data(randperm(shape(1)),:);

% split dataset to train and test datasets
dataTrain = shuffled_data(1:floor(size(shuffled_data, 1)/5*4), :);
dataTest = shuffled_data(floor(size(shuffled_data, 1)/5*4)+1:size(shuffled_data, 1), :);
dataShrink = dataTrain(1:500, :);

% split data into feature and labels
% features = shuffled_data(:, 1:size(shuffled_data, 2)-1);
% labels = shuffled_data(:, size(shuffled_data, 2));

% split dataset to train and test datasets
% featuresTrain = features(1:floor(size(features, 1)/5*4), :);
% featuresTest = features(floor(size(features, 1)/5*4)+1:size(features, 1), :);
% labelsTrain = labels(1:floor(size(features, 1)/5*4), :);
% labelsTest = labels(floor(size(features, 1)/5*4)+1:size(labels, 1), :);

% Building decision tree here
decisionTree = regressionLearning(dataShrink, 0);
DrawDecisionTree(decisionTree, "nicez")

% % test decision tree
% mse = evalRegression(decisionTree,data);
% 
% % mse = evalRegression(decisionTree, featuresTest, labelsTest);
% disp(">>> Decision tree results:");
% disp("MSE: " + mse);
% disp("RMSE: " + sqrt(mse));
% disp("------------------------------------------------------");
% disp(">>> Cross-validation results:");
% 
% % conduct 10-fold cross-validation
% folds = 1;
% allMSE = zeros([1 folds]);
% allRMSE = zeros([1 folds]);
% 
% for fold = 1:folds
%     
%     % split dataset into training and testing datasets in each fold
%     
%     dataFoldTest = shuffled_data((fold-1)*(floor(size(shuffled_data,1)/10))+1:fold*(floor(size(shuffled_data,1)/10)), :);
%     dataFoldTrain1 = shuffled_data(1:(fold-1)*(floor(size(shuffled_data,1)/10)), :);
%     dataFoldTrain2 = shuffled_data(fold*(floor(size(shuffled_data,1)/10))+1:size(shuffled_data,1), :);
%     dataFoldTrain = [dataFoldTrain1; dataFoldTrain2];
% 
%     % split dataset into training and testing datasets in each fold
% %     featuresFoldTest = features((fold-1)*(floor(size(features,1)/10))+1:fold*(floor(size(features,1)/10)), :);
% %     featuresFoldTrain1 = features(1:(fold-1)*(floor(size(features,1)/10)), :);
% %     featuresFoldTrain2 = features(fold*(floor(size(features,1)/10))+1:size(features,1), :);
% %     featuresFoldTrain = [featuresFoldTrain1; featuresFoldTrain2];
% %     labelsFoldTest = labels((fold-1)*(floor(size(features,1)/10))+1:fold*(floor(size(features,1)/10)), :);
% %     labelsFoldTrain1 = labels(1:(fold-1)*(floor(size(features,1)/10)), :);
% %     labelsFoldTrain2 = labels(fold*(floor(size(features,1)/10))+1:size(labels,1), :);
% %     labelsFoldTrain = [labelsFoldTrain1; labelsFoldTrain2];
% %     
%     % Learning on fold data
%     decTree = regressionLearning(dataFoldTrain, 0);
%     
%     % Check rmse of tree
%     mse = evalRegression(decTree, featuresFoldTest, labelsFoldTest);
%     allMSE(fold) = mse;
%     allRMSE(fold) =  sqrt(mse);
%     disp("Fold " + fold);
%     disp("  MSE: " + mse);
%     disp("  RMSE: " + sqrt(mse));
%     
%     DrawDecisionTree(decTree, "Regression Tree - Fold " + fold);
% end
% 
% % Average RMSE after cv folds
% averageRMSE = sum(allRMSE)/folds;
% 
% % display results for each fold in cross-validation
% foldIndex = 1:folds;
% tab = [foldIndex ; allMSE ; allRMSE];
% tab = array2table(tab', 'VariableNames', {'Fold', 'MSE', 'RMSE'});
% disp("------------------------------------------------------");
% disp(">>> Results of each fold in cross-validation:");
% disp(tab);
% disp("Average RMSE of cross-validation: " + averageRMSE);
% disp("------------------------------------------------------");

end

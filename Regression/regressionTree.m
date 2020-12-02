function decisionTree = regressionTree(data)

% Just like frac in pandas, shuffle data 
shape = size(data);
shuffled_data = data(randperm(shape(1)),:);

% split dataset to train and test datasets
dataTrain = shuffled_data(1:floor(size(shuffled_data, 1)/5*4), :);
dataTest = shuffled_data(floor(size(shuffled_data, 1)/5*4)+1:size(shuffled_data, 1), :);

% Building decision tree here
% decisionTree = regressionLearning(dataTrain, 0);

% DrawDecisionTree(decisionTree)

% test decision tree
% rmse = evalRegression(decisionTree,dataTest);

% disp(">>> Decision tree results:");
% disp("RMSE: " + rmse);
disp("------------------------------------------------------");
disp(">>> Cross-validation results:");

% conduct 10-fold cross-validation
folds = 1;
allRMSE = zeros([1 folds]);

for fold = 1:folds
    disp("FOLD: "+fold)
    % split dataset into training and testing datasets in each fold
    
    dataFoldTest = shuffled_data((fold-1)*(floor(size(shuffled_data,1)/10))+1:fold*(floor(size(shuffled_data,1)/10)), :);
    dataFoldTrain1 = shuffled_data(1:(fold-1)*(floor(size(shuffled_data,1)/10)), :);
    dataFoldTrain2 = shuffled_data(fold*(floor(size(shuffled_data,1)/10))+1:size(shuffled_data,1), :);
    dataFoldTrain = [dataFoldTrain1; dataFoldTrain2];
    
    % Learning on fold data
    decTree = regressionLearning(dataFoldTrain, 0);
    DrawDecisionTree(decTree, "Regression Tree - Fold " + fold);
    disp(decTree);
    
    % Check rmse of tree
    rmse = evalRegression(decTree,dataFoldTest);
    allRMSE(fold) =  sqrt(rmse);
    disp("Fold " + fold);
    disp("  RMSE from CV: " + rmse);
    
end

% Average RMSE after cv folds
averageRMSE = sum(allRMSE)/folds;
disp("Average RMSE after 10 folds: "+averageRMSE)

% display results for each fold in cross-validation
foldIndex = 1:folds;
tab = [foldIndex ; allRMSE];
tab = array2table(tab', 'VariableNames', {'Fold', 'RMSE'});
disp("------------------------------------------------------");
disp(">>> Results of each fold in cross-validation:");
disp(tab);
disp("Average RMSE of cross-validation: " + averageRMSE);
disp("------------------------------------------------------");

end

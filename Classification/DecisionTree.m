function DecisionTree(taskType)

% load the dataset
data = readtable('../online_shoppers_intention.csv');

% take same number of true and false labels from original dataset
dataTrue = data(strcmp(data.Revenue, 'TRUE'), :);
numberLabelPerClass = size(dataTrue, 1);
dataFalse = data(randperm(size(data, 1), numberLabelPerClass), :);
data = [dataTrue ; dataFalse];

% shuffle dataset for consistency in data distribution
data = data(randperm(size(data, 1)), :);

% split dataset into features and labels
features = data(:, 1:size(data, 2)-1);
labels = data(:, size(data, 2));

% remove irrelevant attributes
features(:, {'Administrative' 'Informational' 'ProductRelated' 'OperatingSystems' 'Browser'}) = [];

% process features
features.Weekend = findgroups(features.Weekend) - 1;
features.VisitorType = findgroups(features.VisitorType) - 1;
%{
Categorization of Month column:
    0 - more than 1000, has special day (value of >= 0.8)
    1 - less than 1000, has special day (value of >= 0.8)
    2 - more than 1000, no special day
    3 - less than 1000, no special day
%}
% features.Month(strcmp(features.Month, "Jan")) = {"3"};
% features.Month(strcmp(features.Month, "Feb")) = {"1"};
% features.Month(strcmp(features.Month, "Mar")) = {"2"};
% features.Month(strcmp(features.Month, "Apr")) = {"3"};
% features.Month(strcmp(features.Month, "May")) = {"0"};
% features.Month(strcmp(features.Month, "June")) = {"3"};
% features.Month(strcmp(features.Month, "Jul")) = {"3"};
% features.Month(strcmp(features.Month, "Aug")) = {"3"};
% features.Month(strcmp(features.Month, "Sep")) = {"3"};
% features.Month(strcmp(features.Month, "Oct")) = {"3"};
% features.Month(strcmp(features.Month, "Nov")) = {"2"};
% features.Month(strcmp(features.Month, "Dec")) = {"2"};
featuresMonths = zeros(height(features), 1);
for i = 1:height(features)
    switch cell2mat(features.Month(i, 1))
        case 'Jan'
            featuresMonths(i) = 3;
        case 'Feb'
            featuresMonths(i) = 1;
        case 'Mar'
            featuresMonths(i) = 2;
        case 'Apr'
            featuresMonths(i) = 3;
        case 'May'
            featuresMonths(i) = 0;
        case 'June'
            featuresMonths(i) = 3;
        case 'Jul'
            featuresMonths(i) = 3;
        case 'Aug'
            featuresMonths(i) = 3;
        case 'Sep'
            featuresMonths(i) = 3;
        case 'Oct'
            featuresMonths(i) = 3;
        case 'Nov'
            featuresMonths(i) = 2;
        case 'Dec'
            featuresMonths(i) = 2;
        otherwise
    end
end
features.Month = findgroups(featuresMonths) - 1;

% process labels
labels.Revenue = findgroups(labels.Revenue) - 1;

% split dataset to train and test datasets
featuresTrain = features(1:floor(size(features, 1)/5*4), :);
featuresTest = features(floor(size(features, 1)/5*4)+1:size(features, 1), :);
labelsTrain = labels(1:floor(size(features, 1)/5*4), :);
labelsTest = labels(floor(size(features, 1)/5*4)+1:size(labels, 1), :);

% switch between classification or regression task (?)
decisionTree = learnTask(taskType, featuresTrain, labelsTrain);

% test decision tree
accuracy = evaluateTree(decisionTree, featuresTest, labelsTest);
disp("Accuracy: " + (accuracy*100));

% display decision tree
DrawDecisionTree(decisionTree, "Decision Tree structure for classification");

% conduct pruning


% conduct 10-fold cross-validation
folds = 10;
for fold = 1:folds
    
    % split dataset into training and testing datasets in each fold
    featuresFoldTest = features((fold-1)*(floor(size(features,1)/10))+1:fold*(floor(size(features,1)/10)), :);
    featuresFoldTrain1 = features(1:(fold-1)*(floor(size(features,1)/10)), :);
    featuresFoldTrain2 = features(fold*(floor(size(features,1)/10))+1:size(features,1), :);
    featuresFoldTrain = [featuresFoldTrain1; featuresFoldTrain2];
    labelsFoldTest = labels((fold-1)*(floor(size(features,1)/10))+1:fold*(floor(size(features,1)/10)), :);
    labelsFoldTrain1 = labels(1:(fold-1)*(floor(size(features,1)/10)), :);
    labelsFoldTrain2 = labels(fold*(floor(size(features,1)/10))+1:size(labels,1), :);
    labelsFoldTrain = [labelsFoldTrain1; labelsFoldTrain2];
    
    decTree = learnTask(taskType, featuresFoldTrain, labelsFoldTrain);
    
    % prune tree
    
    
    % evaluate tree
    accuracy = evaluateTree(decTree, featuresFoldTest, labelsFoldTest);
    disp("Accuracy at Fold " + fold + ": " + (accuracy*100));
    
    % display decision tree structures of each fold
    DrawDecisionTree(decTree, "Decision Tree - Fold " + fold);
end

end


% evaluate and calculate the accuracy of the decision tree
function accuracy = evaluateTree(tree, features, labels)

labs = table2array(labels);
totalCorrect = 0;
for i = 1:height(features)
    pred = goDownTree(tree, features(i, :));
    totalCorrect = totalCorrect + (pred == labs(i));
end

accuracy = totalCorrect / height(features);

end


% recursively traverse the decision tree to retrieve the predicted class
function prediction = goDownTree(tree, feature)

if isempty(tree.kids)
    prediction = tree.prediction;
    return
end

if table2array(feature(1, tree.attribute)) < tree.threshold
    prediction = goDownTree(tree.kids{1}, feature);
else
    prediction = goDownTree(tree.kids{2}, feature);
end

end


% unfinished
function decisionTree = learnTask(taskType, features, labels)

taskType = lower(taskType);
if strcmp(taskType, "classification")
    decisionTree = decisionTreeLearning(features, labels);
elseif strcmp(taskType, "regression")
    decisionTree = decisionTreeLearning(features, labels);
end

end



function DecisionTree()

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

[features, labels] = preProcessData(features, labels);

% split dataset to train and test datasets
featuresTrain = features(1:floor(size(features, 1)/5*4), :);
featuresTest = features(floor(size(features, 1)/5*4)+1:size(features, 1), :);
labelsTrain = labels(1:floor(size(features, 1)/5*4), :);
labelsTest = labels(floor(size(features, 1)/5*4)+1:size(labels, 1), :);

% build the decision tree
decisionTree = decisionTreeLearning(featuresTrain, labelsTrain, 0);

% test decision tree
[accuracy, precision, recall, f1_score] = evaluateDecisionTree(decisionTree, featuresTest, labelsTest);
disp(">>> Decision tree results:");
disp("Accuracy: " + (accuracy*100));
disp("Precision: " + precision);
disp("Recall: " + recall);
disp("F1-score: " + f1_score);
disp("------------------------------------------------------");
disp(">>> Cross-validation results:");

% % display decision tree
% DrawDecisionTree(decisionTree, "Decision Tree structure for classification");

% -- pruning can be conducted here to improve generalization

% conduct 10-fold cross-validation
folds = 10;
allAccuracies = zeros([1 folds]);
allPrecisions = zeros([1 folds]);
allRecalls = zeros([1 folds]);
allF1_scores = zeros([1 folds]);
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
    
    decTree = decisionTreeLearning(featuresFoldTrain, labelsFoldTrain, 0);
    
    % -- pruning can be conducted here to improve generalization
    
    % evaluate tree
    [accuracy, precision, recall, f1_score] = evaluateDecisionTree(decTree, featuresFoldTest, labelsFoldTest);
    allAccuracies(fold) = accuracy*100;
    allPrecisions(fold) = precision;
    allRecalls(fold) = recall;
    allF1_scores(fold) = f1_score;
    disp("Fold " + fold);
    disp("  Accuracy: " + (accuracy*100));
    disp("  Precision: " + precision);
    disp("  Recall: " + recall);
    disp("  F1-score: " + f1_score);
    
    % display decision tree structures of each fold
    DrawDecisionTree(decTree, "Decision Tree - Fold " + fold);
end

% calculate average result of cross-validation
avgAccuracy = sum(allAccuracies) / folds;
avgPrecision = sum(allPrecisions) / folds;
avgRecall = sum(allRecalls) / folds;
avgF1_score = sum(allF1_scores) / folds;

% display results for each fold in cross-validation
foldIndex = 1:folds;
tab = [foldIndex ; allAccuracies ; allPrecisions ; allRecalls ; allF1_scores];
tab = array2table(tab', 'VariableNames', {'Fold', 'Accuracy', 'Precision', 'Recall', 'F1_measure'});

disp("------------------------------------------------------");
disp(">>> Results of each fold in cross-validation:");
disp(tab);
disp("Average accuracy of cross-validation: " + avgAccuracy);
disp("Average precision of cross-validation: " + avgPrecision);
disp("Average recall of cross-validation: " + avgRecall);
disp("Average F1-score of cross-validation: " + avgF1_score);
disp("------------------------------------------------------");

end


% pre-process the dataset
function [features, labels] = preProcessData(features, labels)

% remove irrelevant attributes
features(:, {'Administrative' 'Informational' 'ProductRelated' 'OperatingSystems' 'Browser'}) = [];

% rename table column names for better display of decision tree
features.Properties.VariableNames = {'AdmDu', 'InfoDu', 'ProdDu', 'BounceR', 'ExitR', 'PageV', 'SpecD', 'Month', 'Region', 'TrafficT', 'VisitorT', 'Weekend'};

% process features
features.Weekend = findgroups(features.Weekend) - 1;
features.VisitorT = findgroups(features.VisitorT) - 1;

featuresMonths = zeros(height(features), 1);
for i = 1:height(features)
    %{
    Categorization of Month column:
        0 - more than 1000, has special day (value of >= 0.8)
        1 - less than 1000, has special day (value of >= 0.8)
        2 - more than 1000, no special day
        3 - less than 1000, no special day
    %}
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
    
    % majority of values (>75%) for this attribute is < 1/4th of max value
    if features.AdmDu(i, 1) < max(features.AdmDu) / 4
        features.AdmDu(i, 1) = 0;
    else
        features.AdmDu(i, 1) = 1;
    end
    
    % majority of values (>75%) for this attribute is < 1/4th of max value
    if features.InfoDu(i, 1) < max(features.InfoDu) / 4
        features.InfoDu(i, 1) = 0;
    else
        features.InfoDu(i, 1) = 1;
    end
    
    % majority of values (>75%) for this attribute is < 1/4th of max value
    if features.ProdDu(i, 1) < max(features.ProdDu) / 4
        features.ProdDu(i, 1) = 0;
    else
        features.ProdDu(i, 1) = 1;
    end
end
features.Month = findgroups(featuresMonths) - 1;

% process labels
labels.Revenue = findgroups(labels.Revenue) - 1;

end


% calculate the accuracy of the decision tree
function [accuracy, precision, recall, f1_score] = evaluateDecisionTree(tree, features, labels)

labs = table2array(labels);
truePositive = 0;
FalsePositive = 0;
FalseNegative = 0;
trueNegative = 0;
for i = 1:height(features)
    pred = goDownTree(tree, features(i, :));
    if pred == 0
        if labs(i) == 0
            % prediction = false, label = false
            trueNegative = trueNegative + 1;
        else
            % prediction = false, label = true
            FalseNegative = FalseNegative + 1;
        end
    else
        if labs(i) == 1
            % prediction = true, label = true
            truePositive = truePositive + 1;
        else
            % prediction = true, label = false
            FalsePositive = FalsePositive + 1;
        end
    end
end

% calculate the various evaluation metrics
accuracy = (truePositive + trueNegative) / height(features);
precision = truePositive / (truePositive + FalsePositive);
recall = truePositive / (truePositive + FalseNegative);
f1_score = 2 * (precision * recall) / (precision + recall);

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


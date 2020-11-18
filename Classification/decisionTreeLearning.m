function decisionTree = decisionTreeLearning(features, labels)
% inputs:
%   features - set of N x d training examples
%   labels - set of N x 1 target labels

% initialize the tree struct at current node
tree.op = "";
tree.kids = {};
tree.prediction = -1;
tree.attribute = -1;
tree.threshold = 0;

% if all target labels are the same, then return the subtree as leaf node
labelMat = table2array(labels)';
if all(labelMat == labelMat(1))
    tree.prediction = labelMat(1);
    decisionTree = tree;
    return
end

% is not leaf node
[bestAttribute, bestThreshold] = chooseAttribute(features, labels);
% if bestAttribute = -1 then choose majority value of labels as leaf node
% else do below
tree.op = features.Properties.VariableNames(bestAttribute);
tree.attribute = bestAttribute;
tree.threshold = bestThreshold;

% retrieve datapoints that have bestAttribute < bestThreshold
featureRows = table2array(features(:, bestAttribute)) < bestThreshold;
featuresLeft = features(featureRows, :);
labelsLeft = labels(featureRows, :);

% retrieve datapoints that have bestAttribute >= bestThreshold
featureRows = ~featureRows; % bestAttribute >= bestThreshold is exact opposite of bestAttribute < bestThreshold
featuresRight = features(featureRows, :);
labelsRight = labels(featureRows, :);

% create children
leftChild = decisionTreeLearning(featuresLeft, labelsLeft);
rightChild = decisionTreeLearning(featuresRight, labelsRight);

tree.kids = {leftChild, rightChild};
decisionTree = tree;
end

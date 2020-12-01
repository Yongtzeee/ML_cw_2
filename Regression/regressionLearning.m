function regressionTree = regressionLearning(features, labels, depth)
    
maxDepth = 5;

% Inputs
%   features -> N x d training examples
%   labels -> N x 1 target labels for training examples

% initialize tree struct
tree.op = "";
tree.kids = {};
tree.prediction = -1;
tree.attribute = -1;
tree.threshold = 0;

% if all target labels are the same, then return the subtree as leaf node
labelMat = table2array(labels)';
if all(labelMat == labelMat(1))
    tree.prediction = labelMat(1);
    regressionTree = tree;
    
else
    [bestAttribute, bestThreshold] = regressionChooseAttribute(features, labels);
    
    % if bestAttribute = -1 then choose majority value of labels as leaf node
    % else do below
    if bestAttribute == -1
        tree.prediction = majorityValue(labels);
        regressionTree = tree;
    elseif depth > maxDepth
        tree.prediction = majorityValue(labels);
        regressionTree = tree;
    else
        depth = depth + 1;
        % is not leaf node
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
        leftChild = regressionLearning(featuresLeft, labelsLeft, depth);
        rightChild = regressionLearning(featuresRight, labelsRight, depth);

        tree.kids = {leftChild, rightChild};
        regressionTree = tree;
    end
end

end
function regressionTree = regressionLearning(data, depth)

% function regressionTree = regressionLearning(features, labels, depth)
% features = data(:, 1:size(data, 2)-1);
% labels = data(:, size(data, 2));

maxDepth = 5;

% initialize tree struct
tree.op = "";
tree.kids = {};
tree.prediction = -1;
tree.attribute = -1;
tree.threshold = 0;

% if all target labels are the same, then return the subtree as leaf node
% labelMat = table2array(labels)';
% if all(labelMat == labelMat(1))
%     tree.prediction = labelMat(1);
%     regressionTree = tree;
%     
labelMat = table2array(data(:,size(data, 2)));
disp("Label mat size: "+size(labelMat))
if all(labelMat == labelMat(1)) 
    tree.prediction = labelMat(1);
    regressionTree = tree;
    
else
    [bestThresholdsList, bestIndex] = infoGainCalc(data);
%     for i = i:length(features)
%         [bestThreshold, bestAttribute] = infoGainCalc();

    disp("Best attribute is attribute: " + bestIndex)

    % if max depth is exceeded, choose labels as leaf node
    % else do below
    if depth == 6
        tree.prediction = labelMat(:, size(data,2));
        regressionTree = tree;
%     elseif depth > maxDepth
%         tree.prediction = majorityValue(labels);
%         regressionTree = tree;
    else
        depth = depth + 1;
        disp("Current depth: " + depth)
        % is not leaf node
        tree.op = data.Properties.VariableNames(bestIndex);
        tree.attribute = bestIndex;
        tree.threshold = bestThreshold;

        % retrieve datapoints that have bestAttribute < bestThreshold     
        
        dataRows = table2array(data(:, bestIndex)) < bestThreshold;
        dataLeft = data(dataRows, :);
        
%         featureRows = table2array(data(:, bestAttribute)) < bestThreshold;
%         featuresLeft = data(featureRows, :);
%         labelsLeft = labels(featureRows, :);

        % retrieve datapoints that have bestAttribute >= bestThreshold
        dataRows = ~dataRows;
        dataRight = data(dataRows, :);
        
%         featureRows = ~featureRows; % bestAttribute >= bestThreshold is exact opposite of bestAttribute < bestThreshold
%         featuresRight = data(featureRows, :);
%         labelsRight = labels(featureRows, :);

        % create children
        leftChild = regressionLearning(dataLeft, depth);
        rightChild = regressionLearning(dataRight, depth);

%         leftChild = regressionLearning(featuresLeft, labelsLeft, depth);
%         rightChild = regressionLearning(featuresRight, labelsRight, depth);

        tree.kids = {leftChild, rightChild};
        regressionTree = tree;
    end
end

end
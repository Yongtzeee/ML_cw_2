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

%labelMat = table2array(data(:,size(data, 2))); % extract labels
%disp("Label mat size: "+size(labelMat))

% if all(labelMat == labelMat(1)) % if all labels are the same, return as leaf
%     tree.prediction = labelMat(1);
%     regressionTree = tree;
%     
% else
    [bestThresholdsList, bestIndex] = infoGainCalc(data);
    disp("Best attribute is attribute: " + bestIndex);
    bestThreshold = bestThresholdsList(bestIndex);

    if depth > maxDepth
        % if leaf node
        tree.prediction = data(:, size(data,2));
        regressionTree = tree;
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

        % retrieve datapoints that have bestAttribute >= bestThreshold
        dataRows = table2array(data(:, bestIndex)) >= bestThreshold;
        dataRight = data(dataRows, :);

        % create children
        leftChild = regressionLearning(dataLeft, depth);
        rightChild = regressionLearning(dataRight, depth);

%         leftChild = regressionLearning(featuresLeft, labelsLeft, depth);
%         rightChild = regressionLearning(featuresRight, labelsRight, depth);

        tree.kids = {leftChild, rightChild};
        regressionTree = tree;
    end
end

%end
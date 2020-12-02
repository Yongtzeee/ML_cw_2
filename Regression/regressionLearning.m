function regressionTree = regressionLearningTest(data, depth)
% Seeking the highest SDR
maxDepth = 5;

% initialize tree struct
tree.op = "";
tree.kids = {};
tree.prediction = -1;
tree.attribute = -1;
tree.threshold = 0;

[x, y] = size(data);
current_labels = data(:,y);
labelMat = table2array(current_labels)';
maxDepth = 5;

% If all labels the same, only 1 node coz homogenous 
if all(labelMat == labelMat(1))
    tree.prediction = labelMat(1);
    regressionTree = tree;

else
    %Find the best threshold of the current data
    [bestThresholdList, bestAttribute] = infoGainCalc(data);
    bestThreshold = bestThresholdList(bestAttribute);
    
    % if sdr negative already
    if bestAttribute == -1
       tree.prediction = majorityValue(data);
       regressionTree = tree;

    % if reach max depth
    elseif depth > maxDepth
       tree.prediction = majorityValue(data);
       regressionTree = tree;
       
   % recurse
    else
        disp("Depth is: "+depth)
        depth = depth + 1;
        tree.op = data.Properties.VariableNames(bestAttribute);
        tree.attribute = bestAttribute;
        tree.threshold = bestThreshold;
        
        % find points that are equal to the threshold
        dataRows = table2array(data(:, bestAttribute)) == bestThreshold;
        dataLeft = data(dataRows,:);
        
        % find points that are not equal to threshold
        dataRows = ~dataRows;
        dataRight =data(dataRows,:);
        
        % create children
        leftChild = regressionLearningTest(dataLeft, depth);
        rightChild = regressionLearningTest(dataRight, depth);

        tree.kids = {leftChild, rightChild};
        regressionTree = tree;
 
    end

end

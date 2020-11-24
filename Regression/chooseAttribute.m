function [bestAttribute, bestThreshold] = chooseAttribute(features, labels)
    
% calculate gain for all attributes
lab = table2array(labels);
columns = features.Properties.VariableNames();

rangedCols = ["Fixed acidity" "Volatile acidity" "Citric acid" "Residual sugar" "Chlorides" "Free Sulfure Dioxide" "Total Sulphur Dioxide" "Density" "pH" "Sulphates" "Alcohol"];
maxGains = 0;
for i = 1:length(columns)
    col = table2array(features(:, columns(i)));
    values = unique(col);

    if ismember(columns(i), rangedCols)
        % set threshold to mean of consecutive class values
        thresh = sort(values);
        thresholds = (thresh(1:length(thresh)-1) + thresh(2:length(thresh))) / 2;
    else
        % set threshold to between class values
        thresholds = sort(values) + 0.5;
        thresholds = thresholds(1:length(thresholds)-1);
    end
    
    remainder = 0;
    gainsPerAttr = [];
    for j = 1:length(thresholds)
        
        % calculate information content
        
        % < threshold
        numPositive = sum((col < thresholds(j)) & (lab == 1));
        numNegative = sum((col < thresholds(j)) & (lab == 0));
        PPositive = numPositive / (numPositive + numNegative);
        PNegative = numNegative / (numPositive + numNegative);
        I = max(0, (-(PPositive)*log2(PPositive))) + max(0, (-(PNegative)*log2(PNegative)));
        
        remainder = remainder + (numPositive + numNegative) / height(features) * I;
        
        % >= threshold
        numPositive = sum((col >= thresholds(j)) & (lab == 1));
        numNegative = sum((col >= thresholds(j)) & (lab == 0));
        PPositive = numPositive / (numPositive + numNegative);
        PNegative = numNegative / (numPositive + numNegative);
        I = max(0, (-(PPositive)*log2(PPositive))) + max(0, (-(PNegative)*log2(PNegative)));
        
		% calculate the remainder
        remainder = remainder + ((numPositive + numNegative) / height(features) * I);
        
        % calculate gain
        labPos = sum(lab == 1);
        labNeg = sum(lab == 0);
        PLabPos = labPos / (labPos + labNeg);
        PLabNeg = labNeg / (labPos + labNeg);
        gain = (-(PLabPos)*log2(PLabPos)) + (-(PLabNeg)*log2(PLabNeg)) - remainder;
        gainsPerAttr = [gainsPerAttr, gain];
    end
    
	% get highest information gain
    if max(gainsPerAttr) > maxGains
        [maxGains, bestThresholdInd] = max(gainsPerAttr);
        bestThreshold = thresholds(bestThresholdInd);
        bestAttribute = i;
    end
end

if maxGains <= 0
    bestThreshold = -Inf;
    bestAttribute = -1;
end

end


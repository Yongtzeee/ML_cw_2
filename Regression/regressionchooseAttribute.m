function [bestAttribute, bestThreshold] = regressionchooseAttribute(features, labels)

bestThreshold = [];
bestSDR = [];

% calculate gain for all attributes
lab = table2array(labels);
columns = features.Properties.VariableNames();

% features
rangedCols = ["Fixed acidity" "Volatile acidity" "Citric acid" "Residual sugar" "Chlorides" "Free Sulfure Dioxide" "Total Sulphur Dioxide" "Density" "pH" "Sulphates" "Alcohol"];
maxGains = 0;

for i = 1:length(columns) % features
    col = table2array(features(:, columns(i)));
    
	% get highest information gain
    [bestThreshold, bestSDR] = infoGainCalc(col);
end

end


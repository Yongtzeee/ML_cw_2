function dataEntropy = entropyCalc(features, data, labels)
freq = [];
dataEntropy = 0;
lab = table2array(labels);
columns = features.Properties.VariableNames();
rangedCols = ["Fixed acidity" "Volatile acidity" "Citric acid" "Residual sugar" "Chlorides" "Free Sulfure Dioxide" "Total Sulphur Dioxide" "Density" "pH" "Sulphates" "Alcohol"];

i = 0;
for i = 1:length(columns) % for entry in attributes
    col = table2array(features(:, columns(i)));
    values = unique(col);
    
    if columns(i) == rangedCols
        break
    i = i + 1;
        
    else
        i = i - 1;
    end
    
    % for entry in data
    if ismember(columns(i), rangedCols)
        freq(i) = freq(i) + 1;
    else
        freq(i) = 1;
    end
    
end

for i = 1:length(freq)
    dataEntropy = dataEntropy + (-i/numel(data)) * math.log(freq/numel(data), 2);
end

end

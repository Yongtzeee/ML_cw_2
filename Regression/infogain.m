function info_gain = infogain(features, labels):
    freq = [];
    subsetEntropy = 0;
    
    for i = 1:length(columns)
        if ismember(columns(i), rangedCols)
            freq[i] += 1;
        else
            freq[i] = 1;
        end
    end
    
    for val = 1:length(freq)
        valProb        = freq[val] / sum(freq);
        % dataSubset     = [entry for entry in data if entry[i] == val];
        subsetEntropy += valProb * entropy(features, data, labels);

    info_gain = entropy(features, data, labels) - subsetEntropy;
    end
end
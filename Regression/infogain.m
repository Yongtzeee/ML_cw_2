function info_gain = infogain(attributes, data, attr, targetAttr):
    freq = [];
    subsetEntropy = 0.0;
    i = attributes.index(attr); % get index
    
    for i = 1:length(columns) % for entry in data
        if ismember(columns(i), rangedCols)
            freq[i] += 1;
        else
            freq[i] = 1;
        end
    end
    
    for val = 1:length(freq)
        valProb        = freq[val] / sum(freq.values());
        % dataSubset     = [entry for entry in data if entry[i] == val];
        subsetEntropy += valProb * entropy(attributes, dataSubset, targetAttr);

    info_gain = entropy(attributes, data, targetAttr) - subsetEntropy);
    end
end
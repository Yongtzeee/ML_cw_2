function majority = majorityValue(labels)

% get the majority label in the node




[~, ind] = max([sum(table2array(labels) == 0), sum(table2array(labels) == 1)]);
majority = ind - 1;

end
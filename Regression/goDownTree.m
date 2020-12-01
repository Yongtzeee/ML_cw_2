% recursively traverse the decision tree to retrieve the predicted class
function prediction = goDownTree(tree, feature)

if isempty(tree.kids)
    prediction = tree.prediction;
    return
end

if table2array(feature(1, tree.attribute)) == tree.threshold
    prediction = goDownTree(tree.kids{1}, feature);
else
    prediction = goDownTree(tree.kids{2}, feature);
end

end
 
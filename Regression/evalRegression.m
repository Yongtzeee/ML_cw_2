function mse = evalRegression(tree, features, labels)

% Returns the MSE of the tree

labs = table2array(labels);
[rows, cols] = size(features);
preds = zeros([1 rows]);

for i = 1:rows
    preds(i) = goDownTree(tree, features(i,:));
end

% Should be the MSE of predictions against labels
mse = immse(preds, labels);

end

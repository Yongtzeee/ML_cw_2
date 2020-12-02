function rmse = evalRegression(tree, test_set)
    [x,y] = size(test_set);
    labels = test_set{:, y};
    labels = labels.';
    prediction = []
    
    if isempty(tree.kids)
       prediction = tree.prediction;    
       return     
    end
    
    for i = 1:x
        prediction(i) = predictions(tree, test_set);
    end
    
    mse = immse(labels, prediction);
    rmse = sqrt(mse);
end

function predicted = predictions(tree, test_set)
    if isempty(tree.op)
        predicted = tree.prediction;
    else
        if tree.attribute < 0
            predicted = tree.prediction;
        else
            if table2array(test_set(1, tree.attribute)) == tree.threshold
                predicted = predictions(tree.kids{1}, test_set); 
            else
                predicted = predictions(tree.kids{2}, test_set);
            end    
        end
        
    end
end


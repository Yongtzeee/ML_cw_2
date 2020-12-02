function Main(taskType)

if taskType == 0
    addpath(genpath('Classification/'))
    data = readtable('online_shoppers_intention.csv');
    classificationTree(data)
    
    
elseif taskType == 1
    addpath(genpath('Regression/'))
    red_data = readtable('winequality-red.csv', 'PreserveVariableNames', 1);
    white_data = readtable('winequality-white.csv', 'PreserveVariableNames', 1);
    combined_data = [red_data;white_data];
    regressionTree(combined_data)    
    
else
    return
end
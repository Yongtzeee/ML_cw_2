function [bestThresholdsList, bestIndex] = infoGainCalc(training)
    % Returns an array of bestThresholds of all features, 
    % shape -> [1x11]

    % Using a method like a dictionary in python to get counts for all
    % unique values, then calcualte their stddev
    columns = training.Properties.VariableNames();
    
    % Shape of our data, rows x columns
    [m, n]= size(training);
    
    % freqDict will look like {key:count...} 
    sdrList = [];
    thresholdList = [];
    bestThresholdsList = [];
    labelsStd = std(training{:, n}); %stdev of the labels
   
    bestSDR = 0;
    bestThreshold = 0;
    bestIndex = 0;
    bestFeature = 0;
    
    for feature = 1:length(columns)-1 %Loop through all our features first except the label in last col 
        disp("FEATURE "+feature)
        sdrFinal = 0;
        sdaResult = 0;
        stdev = [];
        
        labelStore = []; 
        freqDict = [];
%         featureCol = table2array(data(:, columns(feature))); %
        
%         uniqueValues = unique(featureCol); %unique values of the particular feature 
        uniqueValues = unique(training{:,feature});
        [uniqueValuesRow, uniqueValuesCol] = size(uniqueValues);

        freqDict = zeros(uniqueValuesRow,2);
        freqDict(:,1) = uniqueValues; 
        
        for i = 1:m %Loop through rows of table data to do counting
            for j = 1:uniqueValuesRow
               if training{i,feature} == freqDict(j,1)
                   freqDict(j, 2) = freqDict(j,2) + 1; % Increment count encountering the same key
                   labelStore(freqDict(j, 2),j) = training{i, n}; 
                   break   	         
               end
           end
        end

        % Calculate stdev of labels pertaining to this feature
        labelStore(labelStore==0)=NaN;
        stdev = std(labelStore,'omitnan');
        [min_stdev, index] = min(stdev);
        threshold = freqDict(index,1); % get the best threshold value
        
        % Calculate SDA and SDR
        sdaResult = sda(freqDict, stdev, training);
        sdrFinal = labelsStd - sdaResult;
        if sdrFinal > bestSDR
            bestSDR = sdrFinal;
            bestThreshold = threshold;
            bestFeature = feature;
            bestIndex = feature;
        end
        bestThresholdsList(feature) = bestThreshold;
        
        disp("Current best SDR: "+bestSDR)
        disp("Current best threshold: "+bestThreshold)
        disp("Current best feature: "+bestFeature)
        disp("Current best index: "+bestIndex)
    end
end


function sdaResult = sda(freqDict,datasetSD,data)
    sdaResult = 0;
    [m,n] = size(data);
    [a,b] = size(freqDict);
    for i = 1:a
        sdaResult = sdaResult + freqDict(i,2)/m * datasetSD(i);
    end
end

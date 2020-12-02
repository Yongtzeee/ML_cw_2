function [bestThreshold, bestSDR] = infoGainCalc(data)

    % Using a method like a dictionary in python to get counts for all
    % unique values, then calcualte their stddev

    columns = data.Properties.VariableNames();
    
    % Shape of our data, rows x columns
    dataShape = size(data);
    
    % freqDict will look like {uniquekey:count} pairing after
    % assignment
    sdrList = [];
    thresholdList = [];
    datasetStdev = std(data{:, dataShape(2)});

    for feature = 1:length(columns) %Loop through all our features first   
        sdrFinal = 0;
        disp("Currently on feature: "+feature)
        featureCol = table2array(data(:, columns(feature)));
        uniqueValues = unique(featureCol); %unique values of the particular col  
        uniqueValuesSize = size(uniqueValues);
        freqDict = zeros(uniqueValuesSize(1),2);
        freqDict(:,1) = uniqueValues; % Assign keys to freqDict
        
        labelStore = []; 
        
        for row = 1:dataShape(1) %Loop through rows of table data to do counting
%             disp("Row: "+row)
            for uniqueVal = 1:length(uniqueValues)
               if data{row,feature} == uniqueValues(uniqueVal,1)
                   freqDict(uniqueVal, 2) = freqDict(uniqueVal,2) + 1; % Increment count if found same one
                   labelStore(freqDict(uniqueVal, 2),uniqueVal) = data{row, dataShape(2)}; 
                   break   	         
               end
           end
        end
        
        stdev = std(labelStore, "omitNan");
        disp(stdev)
        [min_stdev, index] = min(stdev);
        threshold = freqDict(index,1);
        thresholdList(feature) = threshold;
        
        % Calculate SDA and SDR
        sdrFinal = datasetStdev - sda(freqDict, datasetStdev, data);
        sdrList(feature) = sdrFinal;   
    end

    % Selecting the optimal threshold and sdr (max)
    [bestSDR, bestIndex] = max(sdrList);
    bestThreshold = thresholdList(bestIndex);
    
end

function sdaResult = sda(freqDict,datasetSD,data)
    sdaResult = 0;
    [m,n] = size(data);
    [a,b] = size(freqDict);
    disp("SIZE IS "+ size(freqDict))
    
    
    for i = 1:a
        sdaResult = sdaResult + freqDict(i,2)/m * datasetSD(i);
    end
end

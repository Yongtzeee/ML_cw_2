features = readtable('online_shoppers_intention.csv');

for i = 1:height(features)
    switch cell2mat(features.Month(i, 1))
        case 'Jan'
            features.Month{i, 1} = 3;
        case 'Feb'
            features.Month{i, 1} = 1;
        case 'Mar'
            features.Month{i, 1} = 2;
        case 'Apr'
            features.Month{i, 1} = 3;
        case 'May'
            features.Month{i, 1} = 0;
        case 'June'
            features.Month{i, 1} = 3;
        case 'Jul'
            features.Month{i, 1} = 3;
        case 'Aug'
            features.Month{i, 1} = 3;
        case 'Sep'
            features.Month{i, 1} = 3;
        case 'Oct'
            features.Month{i, 1} = 3;
        case 'Nov'
            features.Month{i, 1} = 2;
        case 'Dec'
            features.Month{i, 1} = 2;
        otherwise
    end
end

unique(table2array(features.Month))
%% show result Sheet
% Specify the file path and sheet name
filePath = 'exp_result/BSA_map2-01-23_18_16/BSA_map2.xlsx'
sheetName = 'result';  % Replace with the desired sheet name

% Read the table from the Excel file
dataTable = readtable(filePath, 'Sheet', sheetName);

% Display the table
disp(dataTable);


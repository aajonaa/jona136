%% show result Sheet
% Specify the file path and sheet name
filePath = 'exp_result/BSA_map5-01-24_02_03/BSA_map5.xlsx'
sheetName = 'result';  % Replace with the desired sheet name

% Read the table from the Excel file
dataTable = readtable(filePath, 'Sheet', sheetName);

% Display the table
disp(dataTable);


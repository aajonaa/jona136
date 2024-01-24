%% show result Sheet
% Specify the file path and sheet name
filePath = 'exp_result/BSA_map8-01-24_23_46/BSA_map8.xlsx'
sheetName = 'result';  % Replace with the desired sheet name

% Read the table from the Excel file
dataTable = readtable(filePath, 'Sheet', sheetName);

% Display the table
disp(dataTable);


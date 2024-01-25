%% show result Sheet
% Specify the file path and sheet name
filePath = 'exp_result/modBSA_end-01-26_02_13/modBSA_end.xlsx'
sheetName = 'result';  % Replace with the desired sheet name

% Read the table from the Excel file
dataTable = readtable(filePath, 'Sheet', sheetName);

% Display the table
disp(dataTable);


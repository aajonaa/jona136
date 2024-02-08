%% show result Sheet
% Specify the file path and sheet name
filePath = 'exp_result/modBSA_revise-02-09_02_52/modBSA_revise.xlsx'
sheetName = 'result';  % Replace with the desired sheet name

% Read the table from the Excel file
dataTable = readtable(filePath, 'Sheet', sheetName);

% Display the table
disp(dataTable);


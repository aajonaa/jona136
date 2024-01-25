%% show result Sheet
% Specify the file path and sheet name
filePath = 'exp_result/modBSA_e-01-25_22_52/modBSA_e.xlsx'
sheetName = 'result';  % Replace with the desired sheet name

% Read the table from the Excel file
dataTable = readtable(filePath, 'Sheet', sheetName);

% Display the table
disp(dataTable);


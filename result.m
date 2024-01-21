%% show result Sheet
% Specify the file path and sheet name
filePath = 'exp_result/SMBSA1-01-22_01_13/SMBSA1.xlsx'
sheetName = 'result';  % Replace with the desired sheet name

% Read the table from the Excel file
dataTable = readtable(filePath, 'Sheet', sheetName);

% Display the table
disp(dataTable);


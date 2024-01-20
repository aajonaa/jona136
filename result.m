%% show result Sheet
% Specify the file path and sheet name
filePath = 'exp_result/muSMA-01-20_12_37/muSMA.xlsx';
sheetName = 'result';  % Replace with the desired sheet name

% Read the table from the Excel file
dataTable = readtable(filePath, 'Sheet', sheetName);

% Display the table
disp(dataTable);


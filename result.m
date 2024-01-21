%% show result Sheet
% Specify the file path and sheet name
filePath = 'exp_result/muSMA2-01-21_14_44/muSMA2.xlsx';
sheetName = 'result';  % Replace with the desired sheet name

% Read the table from the Excel file
dataTable = readtable(filePath, 'Sheet', sheetName);

% Display the table
disp(dataTable);


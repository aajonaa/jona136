%% show result Sheet
% Specify the file path and sheet name
filePath = 'exp_result/11.18-muSMA-SMA-01-20_10_31-Dim30/jona-01-20_10_31.xlsx';
sheetName = 'result';  % Replace with the desired sheet name

% Read the table from the Excel file
dataTable = readtable(filePath, 'Sheet', sheetName);

% Display the table
disp(dataTable);


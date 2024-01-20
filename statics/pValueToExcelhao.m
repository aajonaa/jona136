function pValueToExcelhao(xlsfilename, fold2)
    readFilename = xlsfilename;
    writeFilename = xlsfilename;
    rawdata = readcell(xlsfilename, 'Sheet', 'overall');
    num = size(rawdata);
    flag = 0;
    cur = 1;
    for i = 2:num(1)
        if flag == 0    
            cur = cur + 1;
        else
            break;
        end
        if i+1<=num(1) && ~strcmp(rawdata(i,1),rawdata(i+1,1))
            flag = 1;
        end
    end

    function_num = (num(1) - 1)/(cur - 1);
    algorithm_num = cur - 1;
    fold = fold2;

    sheet_name = 'pValue';
    label = rawdata';
    for idx = 1:numel(label)
        if ismissing(label{idx})
            label{idx} = ''; % Replace missing values with empty strings
        end
    end
    writecell(label, writeFilename, 'Sheet', sheet_name, 'Range', 'B1');

    for i = 1:function_num
        Function_name = ['F', num2str(i)];
        writecell({Function_name}, writeFilename, 'Sheet', sheet_name, 'Range', ['A', num2str(i+1)]);
    end

    for i = 1:function_num 
        temp = readmatrix(readFilename, 'Sheet', ['F', num2str(i)], 'FileType', 'spreadsheet');
        data(:, i) = temp(:, end);
    end
    pvalue = zeros(function_num, (algorithm_num - 1));
    for i = 1:function_num
        for j = 1:(algorithm_num - 1)
            x = data(1:fold, i);
            y = data(j * fold + 1:j * fold + fold, i);
            if any(isnan(x)) || any(isnan(y))
                warning('NaN detected in data for function %d and algorithm %d. Skipping this comparison.', i, j);
                continue;
            end
            pvalue(i, j) = signrank(x, y);
        end
    end
    writematrix(pvalue, writeFilename, 'Sheet', sheet_name, 'Range', 'B2');

    % 合并pValue与result
    for i = 1 : algorithm_num - 1

        number = 'C' + (i * 3 - 2) - 'A';
        numberOfA = floor(number / 26);
        numberOfVar = mod(number, 26);

        frontName = [];
        if numberOfA ~= 0
            for j = 1 : numberOfA
                frontName = [frontName, 'A'];
            end
        end
        behindName = char('A' + numberOfVar);

        writematrix(pvalue(:, i), writeFilename, 'Sheet', 'result & pValue', 'Range', [[frontName, behindName], '2']);
        writecell({'pvalue'}, writeFilename, 'Sheet', 'result & pValue', 'Range', [[frontName, behindName], '1']);
    end

    % 统计强弱
    writecell({'CountOfBetter'}, writeFilename, 'Sheet', 'result & pValue', 'Range', ['A', num2str(function_num + 4)]);
    writecell({'CountOfWorse'}, writeFilename, 'Sheet', 'result & pValue', 'Range', ['A', num2str(function_num + 5)]);
    writecell({'CountOfEqual'}, writeFilename, 'Sheet', 'result & pValue', 'Range', ['A', num2str(function_num + 6)]);
    tmpAlpha = ' ';
    tmpResult = repmat(tmpAlpha, function_num, algorithm_num - 1);
    tmpdata = readmatrix(writeFilename, 'Sheet', 'result & pValue');
    for i = 1 : algorithm_num - 1
        cntOfBetter = 0;
        cntOfWorse = 0;
        for j = 1 : function_num
            if tmpdata(j, i*3) < 0.05
                if tmpdata(j, 1) < tmpdata(j, i*3-1)
                    tmpResult(j, i) = '+';
                    cntOfBetter = cntOfBetter + 1;
                else
                    tmpResult(j, i) = '-';
                    cntOfWorse = cntOfWorse + 1;
                end
            end
        end
        cntOfEqual = function_num - cntOfBetter - cntOfWorse;

        frontName = [];
        if numberOfA ~= 0
            for j = 1 : numberOfA
                frontName = [frontName, 'A'];
            end
        end
        behindName = char('A' + numberOfVar);

        writecell(cellstr(tmpResult(:, i)), writeFilename, 'Sheet', 'result & pValue', 'Range', [[frontName, behindName], '2']);
        writematrix(cntOfBetter, writeFilename, 'Sheet', 'result & pValue', 'Range', [[frontName, behindName], num2str(function_num + 4)]);
        writematrix(cntOfWorse, writeFilename, 'Sheet', 'result & pValue', 'Range', [[frontName, behindName], num2str(function_num + 5)]);
        writematrix(cntOfEqual, writeFilename, 'Sheet', 'result & pValue', 'Range', [[frontName, behindName], num2str(function_num + 6)]);
    end
end

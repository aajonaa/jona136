function FridTest4(xlsfilename, fold2)
    readFilename = xlsfilename;
    writeFilename = xlsfilename;
    rawdata = readcell(xlsfilename, 'Sheet', 'overall');
    num = size(rawdata);
    flag = 0;
    cur = 1;
    for i = 2:num(1)
        if flag == 0
            fun(cur).name = rawdata{i, 2};
            cur = cur + 1;
        else
            break;
        end
        if i + 1 <= num(1) && ~strcmp(rawdata(i, 1), rawdata(i + 1, 1))
            flag = 1;
        end
    end

    function_num = (num(1) - 1) / (cur - 1);
    algorithm_num = cur - 1;
    fold = fold2;

    meanranks = [];
    Data = [];
    for i = 1:function_num
        tempData = readmatrix(readFilename, 'Sheet', ['F', num2str(i)], 'FileType', 'spreadsheet');
        tempData = tempData(:, end); % 获取对应函数中的

        for j = 1:algorithm_num
            ttData(:, j) = tempData((j - 1) * fold + 1 : j * fold);
        end
        Data = [Data; ttData];
    end

    if any(isnan(Data(:)))
        warning('NaN detected in data. Check the source file for missing or invalid values.');
        return;
    end

    ans{1, 1} = 'algorithm_name';
    ans{2, 1} = 'mean_level';
    ans{3, 1} = 'rank';

    x = Data;
    [p, ~, stat] = friedman(x);
    mean_level = stat.meanranks;

    [~, index] = sort(mean_level);
    for i = 1:algorithm_num
        ans{1, i + 1} = fun(i).name;
        ans{2, i + 1} = mean_level(i);
        if i ~= 1 && mean_level(index(i)) == mean_level(index(i - 1))
            ans{3, index(i) + 1} = ans{4, index(i - 1) + 1};
        else
            ans{3, index(i) + 1} = i;
        end
    end
    ans{1, algorithm_num + 2} = 'p';
    ans{2, algorithm_num + 2} = p;

    writetable(cell2table(ans), xlsfilename, 'Sheet', 'ans');
end

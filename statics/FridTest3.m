function FridTest3(xlsfilename, fold2)
    readFilename = xlsfilename;
    writeFilename = xlsfilename;
    rawdata = readcell(readFilename, 'Sheet', 'overall');
    num = size(rawdata);
%     disp(['Size of rawdata: ', num2str(num)]); % Debug print
    flag = 0;
    cur = 1;
    for i = 2:num(1)
        if flag == 0
            fun(cur).name = cell2mat(rawdata(i,2));
            cur = cur + 1;
        else
            break;
        end
        if i+1 <= num(1) && ~strcmp(rawdata(i,1), rawdata(i+1,1))
            flag = 1;
        end
    end

    function_num = (num(1) - 1) / (cur - 1);
    algorithm_num = cur - 1;
%     disp(['function_num: ', num2str(function_num), ', algorithm_num: ', num2str(algorithm_num)]); % Debug print

    fold = fold2;

    meanranks = [];
    for i = 1: function_num
        dealData = readmatrix(readFilename, 'Sheet', ['F', num2str(i)], 'FileType', 'spreadsheet');
        dealData = dealData(:, end); %% 获取最后一列数据
        for j = 1:algorithm_num
            data(:, j) = dealData((j - 1) * fold + 1 : j * fold, :);
        end
        x = data;
        if any(isnan(x(:)))
            warning('NaN detected in data for function %d. Skipping Friedman test.', i);
            continue;
        end
        if any(isnan(data(:))) % Check for NaN values
            warning(['NaN detected in data for function ' num2str(i) '. Skipping Friedman test.']);
            continue; % Skip to next iteration if NaN detected
        end
        x = data;
        [p(i), ~, stat(i)] = friedman(x);
        meanranks = [meanranks; stat(i).meanranks];
    end
%     disp(['Size of meanranks: ', num2str(size(meanranks))]); % Debug print

%     if size(meanranks, 1) ~= function_num || size(meanranks, 2) ~= algorithm_num
%         error(['Size mismatch in meanranks array. Expected: ', num2str(function_num), 'x', num2str(algorithm_num), ', Actual: ', num2str(size(meanranks))]);
%     end

    actual_function_num = size(meanranks, 1); % Actual number of functions (after excluding NaNs)
    meanranks = [meanranks; mean(meanranks)]; % 排名
    for i = 1:algorithm_num
        ans{1, i+1} = fun(i).name;
        for j = 1:actual_function_num % Use actual number of functions
            ans{j+1, i+1} = meanranks(j,i);
        end
    end
    ans{1, algorithm_num + 2} = 'p';
    ans{1,1} = 'F';

    % Add function names and p-values
    for i = 1:actual_function_num
        ans{i+1, 1} = cell2mat(rawdata((i - 1) * (cur - 1) + 2,1));
        ans{i+1, algorithm_num + 2} = p(i);
    end

    ans{function_num+2, 1} = 'mean_level';
    ans{function_num+3, 1} = '平均结果';
    for i = 1:algorithm_num
        meanrank(i) = meanranks(actual_function_num + 1, i); % Use actual_function_num
    end
    [~, index] = sort(meanrank);
    for i = 1:algorithm_num
        ans{function_num+3, index(i)+1} = i;
        if i > 1 && meanrank(index(i)) == meanrank(index(i - 1))
            ans{function_num+3, index(i)+1} = ans{function_num+3, index(i-1)+1};
        end
    end
    writetable(cell2table(ans), xlsfilename, 'Sheet', 'ans');
end

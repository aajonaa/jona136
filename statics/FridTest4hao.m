function  FridTest3( xlsfilename ,fold2)
%UNTITLED �˴���ʾ�йش˺�����ժҪ
%   �˴���ʾ��ϸ˵��
readFilename=xlsfilename;     
writeFilename=xlsfilename;
[~,~,rawdata] = xlsread(xlsfilename,'overall');
num = size(rawdata);
flag = 0;
cur = 1;
for i = 2:num(1)
    if flag == 0
        fun(cur).name = cell2mat(rawdata(i,2));
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

meanranks = [];
Data = [];
for i = 1:function_num
    tempData = xlsread(readFilename, ['F', num2str(i)],'','basic');
    tempData = tempData(:,end); %%��ȡ��Ӧ�����е�
    
    for j = 1:algorithm_num
	    ttData(:,j) = tempData((j-1)*fold+1:j*fold,:);
    end
    Data = [Data; ttData];
end
ans{1,1} = 'algorithm_name';
% ans{2,1} = 'p';
ans{2,1} = 'mean_level';
ans{3,1} = 'rank';

x =  Data;
[p,table,stat] = friedman(x);
mean_level = stat.meanranks;
    

[~,index] = sort(mean_level);
for i = 1:algorithm_num
    ans{1,i+1} = fun(i).name; 
%     ans{2,i+1} = p(i);
    ans{2,i+1} = mean_level(i);
    if i~=1 && mean_level(index(i)) == mean_level(index(i-1))
        ans{3 ,index(i)+1} = ans{3 ,index(i-1)+1};
    else
        ans{3, index(i) + 1} = i;
    end
    
end
ans{1,algorithm_num+2} = 'p-value';
ans{2,algorithm_num+2} = p;
ans{1,algorithm_num+3} = 'Statistic';
ans{2,algorithm_num+3} = table{2,5};


% for i = 1: function_num
% 	dealData = xlsread(readFilename,['F',num2str(i)],'','basic');
% 	dealData = dealData(:,end); %%��ȡ���һ������
%     for j = 1:algorithm_num
% 	    data(:,j) = dealData((j-1)*fold+1:j*fold,:);
% 	end
% 	x = data;
% 	[p(i),table,stat(i)] = friedman(x);
% 	meanranks = [meanranks;stat(i).meanranks];
% end


%%meanranks
% meanranks = [meanranks;mean(meanranks)];%%����
% for i = 1:algorithm_num
% 	ans{1,i+1} = fun(i).name; 
%     for j = 1:function_num+1
%         ans{j+1,i+1} = meanranks(j,i);
%     end
% end
% ans{1, algorithm_num + 2} = 'p';
% ans{1,1} = 'F';
% 
% for i = 1:function_num
%     ans{i+1,1} = cell2mat(rawdata((i - 1)*(cur - 1) +2,1));
%     ans{i+1,algorithm_num + 2} = p(i);
% end
% 
% ans{function_num+2, 1} = 'mean_level';
% ans{function_num+3, 1} = 'ƽ�����';
% for i = 1:algorithm_num
%     meanrank(i) = meanranks(function_num + 1,i);
% end
% [~,index] = sort(meanrank);
% for i = 1:algorithm_num
%    ans{function_num+3 ,index(i)+1} = i;
%    if i>1 && meanrank(index(i)) == meanrank(index(i - 1))
%        ans{function_num+3 ,index(i)+1} = ans{function_num+3 ,index(i-1)+1};
%    end
% end
xlswrite(xlsfilename,ans,'ans1');


%**************************************************************************************************
%  CLPSO： Comprehensive Learning Particle Swarm Optimizer for Global Optimization of Multimodal Functions
%  We obtained the MATLAB source code from the authors
%  Date: 2014/11/14
%**************************************************************************************************


function [Leader_pos,Convergence_curve]=CLPSO(SearchAgents_no,MaxFEs,lb,ub,dim,fobj)

if size(ub,2)==1%返回矩阵ub的列数为1列
    ub=ones(1,dim)*ub;
    lb=ones(1,dim)*lb;
end
lu=[lb;ub];

D = dim;
Xmin = lu(1,:);%x的最小范围
Xmax = lu(2,:);%x的最大范围

rand('seed', sum(100 * clock));

% parameters setting for CLPSO
popsize = SearchAgents_no;  %粒子个数
maxGEN = MaxFEs/popsize;%计算权重公式的一部分
iwt = 0.9 - (1 : maxGEN) * (0.7 / maxGEN);%惯性权重
c = 1.49445;
FES = 0;
% Initialize the main population
X = repmat(Xmin, popsize, 1) + rand(popsize,D) .* (repmat(Xmax-Xmin, popsize, 1));%初始随机的粒子位置
val_X=zeros(size(X,1),1);%产生D行一列的0矩阵
for i=1:size(X,1)%计算每一个粒子的适应值
    val_X(i) = fobj(X(i,:));
    FES = FES + 1;
end
pBest = X; val_pBest = val_X;%；各粒子历史最小值的位置和各粒子的适应值
[~,indexG] = min(val_pBest);%粒子群历史最小值的索引位置
gBest = pBest(indexG,:); val_gBest = val_pBest(indexG,:);%粒子群历史最小值的位置和最小适应值
Vmax = (Xmax - Xmin)*0.2;  Vmin = -Vmax;%定义最大速度和最小速度
V = repmat(Vmin,popsize,1) + rand(popsize,D).*repmat(Vmax-Vmin,popsize,1);%随机一个初始速度

% Learning Probability Pc
t = 0 : 1/(popsize-1):1;
t = 5.*t;
Pc = 0.0+(0.5-0.0).*(exp(t)-exp(t(1)))./(exp(t(popsize))-exp(t(1)));%计算每个粒子的pc值

% Refreshing Gap
gapm = 5; stay_num = zeros(1,popsize); %gapm相当于算法中m阈值，stay_num记录每个粒子的计算次数
for i = 1:popsize      
    pBest_ind(i,:) = LearnIndex_CLPSO(val_pBest,popsize,D,i,Pc(i));  %对每个粒子的维度进行比较，学习自身经验或其它粒子的经验
end
l = 1;
GEN = 1;  %最大迭代数的计数器
 Convergence_curve = [];  % record the best results
%l=1;
 while   FES < MaxFEs
    for i = 1:popsize
        
        % update exemplar index
        if stay_num(i)>gapm 
            pBest_ind(i,:) = LearnIndex_CLPSO(val_pBest,popsize,D,i,Pc(i)); %总迭代次数迭代五次，而粒子的历史最优值还没有更新，则该重新学习其它粒子
            stay_num(i) = 0;
        end
        
        %  Compehensive Learning Strategy
        for  j=1:D
            pBest_f(i,j) = pBest(pBest_ind(i,j),j);  %将其它粒子维度上的值移植到当前粒子的维度上
        end
        V(i,:) = iwt(GEN)*V(i,:) + c*rand(1,D).*(pBest_f(i,:)-X(i,:));  % update velocity
        V(i,:) = boundConstraint_absorb(V(i,:),Vmin,Vmax);
        X(i,:) = X(i,:)+V(i,:);    % update position
        
        if all(X(i,:)<=Xmax) && all(X(i,:)>=Xmin)  % X(i,:) is feasible
            val = fobj(X(i,:));
            FES = FES+1;
            if val<val_pBest(i)    % update pBest
                pBest(i,:) = X(i,:);  val_pBest(i) = val;
                stay_num(i) = 0;  %粒子历史最优值更新后，计数重新为0
                if  val<val_gBest  % update gBest全局最优
                    gBest = X(i,:);  val_gBest = val;
                end
            else
                stay_num(i) = stay_num(i)+1;  %粒子历史最优值没有更新时，计数加一
            end
        end
        
    end
    
%     convergence = [convergence val_gBest];
      Convergence_curve(l)=val_gBest;  %记录本次迭代的全局最优值
      l=l+1;  %总迭代次数加一    
    GEN = GEN+1;  
    if (GEN >= maxGEN) && (l < MaxFEs)
        GEN = GEN-1;
    end
 
end

% bestScore=convergence(end);
Leader_pos = gBest;

end






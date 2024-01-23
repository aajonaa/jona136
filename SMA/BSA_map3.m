 % Backtracking Search Optimization Algorithm (BSA) modified by Jona
% 2024-1-23.
function [best_pos,Convergence_curve] = BSA(N, Max_FEs, lb, ub, dim, fobj)

disp('BSA');
disp(N);
disp(Max_FEs);
disp(lb);
disp(ub);
disp(dim);
disp(fobj);

tic

%INITIALIZATION
DIM_RATE = 1;  
Convergence_curve = [];
FEs = 0;
bestFitness = inf;
best_pos = zeros(1,dim);

AllFitness = inf * ones(1, N);
fitnessoffsprings = inf * ones(1, N);
if numel(lb)==1, lb=lb*ones(1,dim); ub=ub*ones(1,dim); end
X=initialization(N,dim,ub,lb); 
historical_X = initialization(N, dim, ub, lb);
iter = 1;
for i = 1 : N
    AllFitness(i) = fobj(X(i, :));
    FEs  = FEs +1;
end

while FEs < Max_FEs

    %SELECTION-I
    if rand<rand, historical_X=X; end  
    historical_X=historical_X(randperm(N),:); 
    F=get_scale_factor; 
    map=zeros(N,dim); 
    for i = 1:N
        if rand < rand
            u = randperm(dim);
            map(i, u(1: ceil(rand * dim))) = 1;
        else
            map(i, randi(dim)) = 1;
        end
    end
    % if rand<rand
    %     for i=1:N,  u=randperm(dim); map(i,u(1:ceil(DIM_RATE*rand*dim)))=1; end
    % else
    %     for i=1:N,  map(i,randi(dim))=1; end
    % end

    % RECOMBINATION (MUTATION+CROSSOVER)   
    offsprings=X + F * map .* (historical_X - X);   
    offsprings=BoundaryControl(offsprings,lb,ub); 

    % SELECTON-II
    for i = 1:N
        fitnessoffsprings(i) = fobj(offsprings(i,:));
        FEs = FEs + 1;
    end
    ind=fitnessoffsprings<AllFitness;
    AllFitness(ind)=fitnessoffsprings(ind);
    X(ind,:)=offsprings(ind,:);
    [minimum_fitness, ind]=min(AllFitness);    
    best_pos=X(ind,:);
    bestFitness = minimum_fitness;

    Convergence_curve(iter)=bestFitness;
    iter =iter + 1;
end
toc
end

function X=BoundaryControl(X,low,up)
[N,dim]=size(X);
for i=1:N
    for j=1:dim                
        k=rand<rand; 
        if X(i,j)<low(j)
            if k, X(i,j)=low(j); 
            else X(i,j)=rand*(up(j)-low(j))+low(j); 
            end 
        end        
        if X(i,j)>up(j)
            if k, X(i,j)=up(j);  
            else
                X(i,j)=rand*(up(j)-low(j))+low(j); 
            end 
        end
    end
end
end



function F=get_scale_factor % you can change generation strategy of scale-factor,F    
     F=3*randn; % STANDARD brownian-walk
    % F=4*randg;  % brownian-walk    
    % F=lognrnd(rand,5*rand);  % brownian-walk              
    % F=1/normrnd(0,5);        % pseudo-stable walk (levy-like)
    % F=1./gamrnd(1,0.5);      % pseudo-stable walk (levy-like, simulates inverse gamma distribution; levy-distiribution)   
end
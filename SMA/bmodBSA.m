% Binary Backtracking Search Optimization Algorithm (BSA) modified by Jona 2024-1-25.
% This version is the same with BSA_map8.m but delete the commented code.

% First change the function header.
% Second change the fitness calculation method and coment the FEs
% Third change all the population be binary version by using TF function or bool operation.
function [best_pos,Convergence_curve] = bmodBSA(N, Max_FEs, lb, ub, dim, fobj)
    tic
    
    %INITIALIZATION
    Convergence_curve = [];
    FEs = 0;
    bestFitness = inf;
    pre_bestFitness = inf;
    best_pos = zeros(1,dim);
    AllFitness = inf * ones(1, N);
    fitnessoffsprings = inf * ones(1, N);
    if numel(lb)==1, lb=lb*ones(1,dim); ub=ub*ones(1,dim); end
    X=initialization(N,dim,ub,lb); 
    historical_X = initialization(N, dim, ub, lb);
    weight = ones(N, dim);
    iter = 1;

    %% parameter
    count = 0;
    c = 0.02;
    d = 50;
    flag = 1;

    for i = 1 : N
        AllFitness(i) = fobj(X(i, :));
        FEs  = FEs +1;
    end
    
    %% Main loop
    while FEs < Max_FEs

        %% Calculate count and sort the fitness
        [~, SmellIndex] = sort(AllFitness);
        bestFitness = SmellIndex(1);
        if bestFitness < pre_bestFitness
            count = sqrt(count);
        else
            count = count + 1;
        end
        pre_bestFitness = bestFitness;
        best_pos = X(SmellIndex(1), :);
        worstFitness = SmellIndex(N);
    
        %% SELECTION-I
        if flag == 0, historical_X = X; end
        historical_X=historical_X(randperm(N),:); 

        %% RECOMBINATION (MUTATION+CROSSOVER)   
        F=get_scale_factor; 
        map=zeros(N,dim); 
        p = 1/(1+exp(-c * (count - d)));
        p = 1.3 * p - 0.3;
        if p > 0.5
            flag = 0;
            b = 1 - FEs/Max_FEs;
            vc = unifrnd(-b, b, 1, N);
            for i = 1:N
                if rand > (FEs/Max_FEs)^3
                    vc(i) = 1;
                end
            end
            for i = 1:N
                if SmellIndex(i) > 1
                    u = randperm(dim);
                    map(i, u(1: ceil(rand * dim))) = 1;
                    Mutant(i, :) = vc(i) * X(i, :) + F * map(i, :) .* (historical_X(i, :) - X(i, :));
                else
                    Mutant(i, :) = best_pos + F * (historical_X(i, :) - X(i, :)); %% F1-F4
                end
            end
        else
            flag = 1;
            for i = 1:N
                map(i, randi(dim)) = 1;
                Mutant(i, :) = X(i, :) + F * map(i, :) .* (historical_X(i, :) - X(i, :));
            end
        end 
        offsprings = Mutant;
        offsprings=BoundaryControl(offsprings,lb,ub); 
    
        %% SELECTON-II
        for i = 1:N
            fitnessoffsprings(i) = fobj(offsprings(i,:));
            FEs = FEs + 1;
        end
        ind=fitnessoffsprings<AllFitness;
        AllFitness(ind)=fitnessoffsprings(ind);
        X(ind,:)=offsprings(ind,:);
        [minimum_fitness, ind]=min(AllFitness);    
        best_pos=X(ind,:);
        Destination_fitness = minimum_fitness;
    
        Convergence_curve(iter) = Destination_fitness;
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
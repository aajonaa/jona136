%% Slime Mold Algorithm modified by Jona 2024-1-19.
function [best_pos,convergence_curve]=SMBSA(N,Max_FEs,lb,ub,dim,fobj)
    tic
    disp('SMBSA is now tackling your problem')
    
    %% Initialize position
    best_pos=zeros(1,dim);
    convergence_curve = [];
    Destination_fitness=inf;
    AllFitness = inf*ones(N,1);
    fitness_Mutant = inf * ones(N, 1);
    weight = zeros(N,dim);
    X=initialization(N,dim,ub,lb);
    history_X = initialization(N, dim, ub, lb);
    it=1;  
    FEs = 0;
    lb=ones(1,dim).*lb; 
    ub=ones(1,dim).*ub; 
    z=1; 
    X = BoundaryControl(X, lb, ub);
    
    %% Main loop
    while  FEs <= Max_FEs

        %% Best_pos && Destination_fitness
        for i = 1:N
            AllFitness(i) = fobj(X(i, :));
            FEs = FEs + 1;
        end
        [bestFitness, idx] = min(AllFitness);
        if bestFitness < Destination_fitness
            best_pos=X(idx,:);
            Destination_fitness = bestFitness;
        end
            
        %% Weight calculate for the Selection-I
        [SmellOrder,SmellIndex] = sort(AllFitness); 
        worstFitness = SmellOrder(N);
        bestFitness = SmellOrder(1);
        S=bestFitness-worstFitness+eps;  % plus eps to avoid denominator zero
        for i=1:N
            for j=1:dim
                if i <= N/2  %Eq.(2.5)
                    weight(SmellIndex(i),j) = 1+rand()*log10((bestFitness-SmellOrder(i))/(S)+1);
                else
                    weight(SmellIndex(i),j) = 1-rand()*log10((bestFitness-SmellOrder(i))/(S)+1);
                end
            end
        end
    
        %% Mutation
        if rand < rand
            history_X = X;
        else
            a = atanh(-(FEs/Max_FEs)+1);  
            b = 1-FEs/Max_FEs;
            for i = 1:N
                if SmellIndex(i) <= N/2
                    history_X(i, :) = X(i, :);
                else
                    if rand<z    
                        flag = 0;
                        disp(flag);
                        history_X(i, :) = (ub-lb)*rand+lb;
                    else
                        flag = 1;
                        disp(flag);
                        p =tanh(abs(AllFitness(i)-Destination_fitness));  
                        vb = unifrnd(-a,a,1,dim); 
                        vc = unifrnd(-b,b,1,dim);
                        for j=1:dim
                            r = rand();
                            A = randi([1,N]); 
                            B = randi([1,N]);
                            if r<p   
                                history_X(i, j) = best_pos(j)+ vb(j)*(weight(i,j)*X(A,j)-X(B,j));
                            else
                                history_X(i, j) = vc(j)*X(i,j);
                            end
                        end
                    end    
                end
            end
        end
        history_X = history_X(randperm(N), :);
        F = get_scale_factor;

        %% Crossover using matrix
        map = ones(N, dim);
        for i = 1:N
            if SmellIndex(i) <= N/2
                u = randperm(dim);
                map(i, u(1:ceil(rand * dim))) = 0;
            end
        end
        Mutant = X + map * F .* (history_X - X);
        Mutant = BoundaryControl(Mutant, lb, ub);
        for i = 1:N
            fitness_Mutant(i) = fobj(Mutant(i, :));
            FEs = FEs + 1;
        end

        %% Selection-II
        ind = fitness_Mutant < AllFitness;
        AllFitness(ind) = fitness_Mutant(ind);
        X(ind, :) = Mutant(ind, :);
        [bestFitness, idx] = min(AllFitness);
        if bestFitness < Destination_fitness
            best_pos=X(idx,:);
            Destination_fitness = bestFitness;
        end

        convergence_curve(it)=Destination_fitness;
        it=it+1;
    end
    toc
end
    
function F=get_scale_factor % you can change generation strategy of scale-factor,F    
    F=3*randn; % STANDARD brownian-walk
    % F=4*randg;  % brownian-walk    
    % F=lognrnd(rand,5*rand);  % brownian-walk              
    % F=1/normrnd(0,5);        % pseudo-stable walk (levy-like)
    % F=1./gamrnd(1,0.5);      % pseudo-stable walk (levy-like, simulates inverse gamma distribution; levy-distiribution)   
end

function X=BoundaryControl(X,low,up)
    [N,dim]=size(X);
    for i=1:N
        for j=1:dim                
            k=rand<rand; % you can change boundary-control strategy
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
    
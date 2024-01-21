%% Slime Mold Algorithm modified by Jona 2024-1-19.
function [best_pos,convergence_curve]=muSMA(N,Max_FEs,lb,ub,dim,fobj)
    tic
    disp('muSMA is now tackling your problem')
    
    %% initialize position
    best_pos=zeros(1,dim);
    Destination_fitness=inf;
    AllFitness = inf*ones(N,1);
    fitness_Mutant = inf * ones(N, 1);
    weight = zeros(N,dim);
    X=initialization(N,dim,ub,lb);
    history_X = initialization(N, dim, ub, lb);
    convergence_curve = [];
    it=1;  
    lb=ones(1,dim).*lb; 
    ub=ones(1,dim).*ub; 
    z=0.03; 
    
    %% Main loop
    FEs = 0;
    while  FEs <= Max_FEs
        map = ones(N, dim);
        
        %sort the fitness
        for i=1:N
            % Check if solutions go outside the search space and bring them back
            Flag4ub=X(i,:)>ub;
            Flag4lb=X(i,:)<lb;
            X(i,:)=(X(i,:).*(~(Flag4ub+Flag4lb)))+ub.*Flag4ub+lb.*Flag4lb;
            AllFitness(i) = fobj(X(i,:));
            FEs = FEs + 1;
        end
        
        [SmellOrder,SmellIndex] = sort(AllFitness);  %Eq.(2.6)
        worstFitness = SmellOrder(N);
        bestFitness = SmellOrder(1);
    
        S=bestFitness-worstFitness+eps;  % plus eps to avoid denominator zero
    
        %calculate the fitness weight of each slime mold
        for i=1:N
            for j=1:dim
                if i <= N/2  %Eq.(2.5)
                    weight(SmellIndex(i),j) = 1+rand()*log10((bestFitness-SmellOrder(i))/(S)+1);
                else
                    weight(SmellIndex(i),j) = 1-rand()*log10((bestFitness-SmellOrder(i))/(S)+1);
                end
            end
        end
    
        %% mutation
    %     a = rand();
    %     b = rand();
    %     if a < b
    %         history_X = X;
    %     end
    %     history_X = history_X(randperm(N), :);
    
        if rand < rand
            history_X = X;
        else
            for i = 1:N
                if SmellIndex(i) <= N/2
                    history_X(i, :) = X(i, :);
                else
                    history_X(i, :) = (ub-lb)*rand+lb;
                end
            end
        end
        history_X = history_X(randperm(N), :);
        % F = C_max - rand * (-(sin(pi/(2*FEs)) + C_min));
        F = get_scale_factor;
        for i = 1:N
            if SmellIndex(i) <= N/2
                u = randperm(dim);
                map(i, u(1:ceil(rand * dim))) = 0;
            end
        end
        % disp(map);
        Mutant = X + map * F .* (history_X - X);
        Mutant = BoundaryControl(Mutant, lb, ub);
        for i = 1:N
            fitness_Mutant(i) = fobj(Mutant(i, :));
            FEs = FEs + 1;
        end
        ind = fitness_Mutant < AllFitness;
        AllFitness(ind) = fitness_Mutant(ind);
        X(ind, :) = Mutant(ind, :);
    
        [bestFitness, idx] = min(AllFitness);
        
        %update the best fitness value and best position
        if bestFitness < Destination_fitness
            best_pos=X(idx,:);
            Destination_fitness = bestFitness;
        end
        
        % a = atanh(-(FEs/Max_FEs)+1);   %Eq.(2.4)
        % b = 1-FEs/Max_FEs;
        % % Update the Position of search agents
        % for i=1:N
        %     if rand<z     %Eq.(2.7)
        %         X(i,:) = (ub-lb)*rand+lb;
        %     else
        %         p =tanh(abs(AllFitness(i)-Destination_fitness));  %Eq.(2.2)
        %         vb = unifrnd(-a,a,1,dim);  %Eq.(2.3)
        %         vc = unifrnd(-b,b,1,dim);
        %         for j=1:dim
        %             r = rand();
        %             A = randi([1,N]);  % two positions randomly selected from population
        %             B = randi([1,N]);
        %             if r<p    %Eq.(2.1)
        %                 X(i,j) = best_pos(j)+ vb(j)*(weight(i,j)*X(A,j)-X(B,j));
        %             else
        %                 X(i,j) = vc(j)*X(i,j);
        %             end
        %         end
        %     end
        % end
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
    
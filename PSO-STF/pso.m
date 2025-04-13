clc;
clear;
close all;

tic
%% Problem Definition

PSO.str = fprintf('PSO-STF algorithm\n\n');
init;
global NFE;
NFE=0;

PSO.CostFunction = @(x, y) Bargain(x, y);        % Bargaining Game Cost Function

PSO.nVar = FCM.concepts.columns;                 % Number of Decision Variables

PSO.VarSize = [PSO.nVar, PSO.nVar];              % Size of Decision Variables Matrix

%% PSO Parameters

PSO.MaxIt = 400;                                 % Maximum Number of Iterations
PSO.nPop = 50;                                   % Population Size (Swarm Size)

% Constriction Coefficients
PSO.phi1 = 2.05;
PSO.phi2 = 2.05;
PSO.phi = PSO.phi1 + PSO.phi2;
PSO.chi = 2/(PSO.phi-2 + sqrt(PSO.phi^2-4*PSO.phi));
PSO.w_chi = PSO.chi;                             % Inertia Weight
PSO.wdamp = 1;                                   % Inertia Weight Damping Ratio
PSO.c1 = PSO.chi*PSO.phi1;                       % Personal Learning Coefficient
PSO.c2 = PSO.chi*PSO.phi2;                       % Global Learning Coefficient

% Velocity Limits
PSO.Vel.Max = 0.1*(PSO.constraints.upper - PSO.constraints.lower);
PSO.Vel.Min = -PSO.Vel.Max;

% S-shaped transfer function domain
PSO.fuzzy_scope = [0.5, 0.95];

%% Initialization

PSO.empty_particle.Position = [];
PSO.empty_particle.Velocity = [];
PSO.empty_particle.VecPso = [];
PSO.empty_particle.Cost = [];
PSO.empty_particle.Best.Position = [];
PSO.empty_particle.Best.Cost = [];

PSO.particle = repmat(PSO.empty_particle, PSO.nPop, 1);

PSO.GlobalBest.Cost = inf;

for i=1:PSO.nPop
    
    PSO.particle(i).Position = FCM.weights.matrix;
    
   % Initialize Position
   for j = 1:PSO.nVar
       for z = 1:PSO.nVar
           if PSO.particle(i).Position(j,z) == 0
               PSO.particle(i).Position(j,z) = 0;           
           else
              PSO.particle(i).Position(j,z) = (PSO.constraints.upper(j,z) - PSO.constraints.lower(j,z)) * rand() + PSO.constraints.lower(j,z);
          end        
       end
   end
    
    % Initialize Velocity
    PSO.particle(i).Velocity = zeros(PSO.VarSize);
    
    % Vec PSO
%     PSO.particle(i).VecPso = fcm_interaction(FCM.concepts.matrix, PSO.particle(i).Position);
    PSO.particle(i).VecPso = smf(fcm_interaction(FCM.concepts.matrix, PSO.particle(i).Position), PSO.fuzzy_scope);

    
    % Evaluation
    PSO.particle(i).Cost = PSO.CostFunction(PSO.particle(i).Position, PSO.particle(i).VecPso);
        
    % Update Personal Best
    PSO.particle(i).Best.Position = PSO.particle(i).Position;
    PSO.particle(i).Best.Cost = PSO.particle(i).Cost;
    
    % Update Global Best
    if PSO.particle(i).Best.Cost < PSO.GlobalBest.Cost       
        PSO.GlobalBest = PSO.particle(i).Best;   
    end
    
end

PSO.BestCost = zeros(PSO.MaxIt, 1);

PSO.nfe = zeros(PSO.MaxIt, 1);

%% PSO Main Loop

for it = 1:PSO.MaxIt
    for i = 1:PSO.nPop
                
        % Update Velocity
        PSO.particle(i).Velocity = PSO.w_chi*PSO.particle(i).Velocity ...
            + PSO.c1*rand(PSO.VarSize).*(PSO.particle(i).Best.Position - PSO.particle(i).Position) ...
            + PSO.c2*rand(PSO.VarSize).*(PSO.GlobalBest.Position - PSO.particle(i).Position);
        
        % Apply Velocity Limits
        PSO.particle(i).Velocity = max(PSO.particle(i).Velocity, PSO.Vel.Min);
        PSO.particle(i).Velocity = min(PSO.particle(i).Velocity, PSO.Vel.Max);
        
        % Update Position
        PSO.particle(i).Position = PSO.particle(i).Position + PSO.particle(i).Velocity; 
        
        % Update Vec Pso
%         PSO.particle(i).VecPso = fcm_interaction(FCM.concepts.matrix, PSO.particle(i).Position);
        PSO.particle(i).VecPso = smf(fcm_interaction(FCM.concepts.matrix, PSO.particle(i).Position), PSO.fuzzy_scope);

        
        % Velocity Mirror Effect
        PSO.IsOutside = (PSO.particle(i).Position < PSO.constraints.lower | PSO.particle(i).Position > PSO.constraints.upper);
        PSO.particle(i).Velocity(PSO.IsOutside) = -PSO.particle(i).Velocity(PSO.IsOutside);
        
        % Apply Position Limits
        PSO.particle(i).Position = max(PSO.particle(i).Position, PSO.constraints.lower);
        PSO.particle(i).Position = min(PSO.particle(i).Position, PSO.constraints.upper);
        
        % Apply Sign of Position
        for j = 1:PSO.nVar
            for z = 1:PSO.nVar
                
                if FCM.weights.matrix(j,z) < 0
                    if PSO.particle(i).Position(j,z) > 0
                        PSO.particle(i).Position(j,z) = -PSO.particle(i).Position(j,z);
                    end
                    
                elseif FCM.weights.matrix(j,z) == 0
                    PSO.particle(i).Position(j,z) = 0;
                    
                elseif FCM.weights.matrix(j,z) > 0
                    if PSO.particle(i).Position(j,z) < 0
                        PSO.particle(i).Position(j,z) = -PSO.particle(i).Position(j,z);
                    end
                end
                        
            end
        end
         
        % Evaluation
        PSO.particle(i).Cost = PSO.CostFunction(PSO.particle(i).Position, PSO.particle(i).VecPso);
        
        % Update Personal Best
        if PSO.particle(i).Cost < PSO.particle(i).Best.Cost
            
            PSO.particle(i).Best.Position = PSO.particle(i).Position;
            PSO.particle(i).Best.Cost = PSO.particle(i).Cost;
            PSO.particle(i).Best.VecPso = PSO.particle(i).VecPso;
            
            % Update Global Best
            if PSO.particle(i).Best.Cost < PSO.GlobalBest.Cost                
                PSO.GlobalBest = PSO.particle(i).Best;
            end
        end
        
    end
   
    
    PSO.BestCost(it) = PSO.GlobalBest.Cost;
    
    PSO.nfe(it) = NFE;
    
    disp(['Iteration ' num2str(it) ': NFE = ' num2str(PSO.nfe(it)) ', Best Cost = ' num2str(PSO.BestCost(it))]);
    
    PSO.w_chi = PSO.w_chi * PSO.wdamp;
    
end

%% Results

Final_weight = PSO.GlobalBest.Position         %#ok
Final_vector = PSO.GlobalBest.VecPso           %#ok

toc
%% Plot

% figure;
% plot(PSO.nfe, PSO.BestCost, 'LineWidth', 2);
% % semilogy(PSO.nfe, PSO.BestCost, 'LineWidth', 2);
% 
% xlabel('NFE');
% ylabel('Best Cost');
% 
% hold on
% 
% figure;
% 
% fcm_interaction_plot(PSO.GlobalBest.VecPso, PSO.GlobalBest.Position);
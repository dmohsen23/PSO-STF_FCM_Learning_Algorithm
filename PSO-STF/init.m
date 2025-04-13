%% Information

%% Data

% NHL input data
file = xlsread('Data1.xlsx');

% Initial Concept Values
FCM.concepts.matrix = file(1:18, 14)';
[FCM.concepts.rows, FCM.concepts.columns] = size(FCM.concepts.matrix);

% Weight Matrix
FCM.weights.matrix = file(22:39, 1:18);
[FCM.weights.rows, FCM.weights.columns] = size(FCM.weights.matrix);

% Constraints Matrix for optimization (For PSO-STF)
% Lower Bound
PSO.constraints.lower = file(43:60, 1:18);
% Upper Bound
PSO.constraints.upper = file(64:81, 1:18);

% Output Concept Range
% Based on the objectives of the problem, the number of the Desired Output Concept(s) (DOC) can be varied. 
% Its initial setting is important.
FCM.NHL.DOC1.min = 0.5;
FCM.NHL.DOC1.max = 0.7;
FCM.NHL.DOC2.min = 0.75;
FCM.NHL.DOC2.max = 0.8;

% Variables for Termination Conditions (mean target value of the interesting concept DOC)
FCM.NHL.DOC1.t1 = mean([FCM.NHL.DOC1.min, FCM.NHL.DOC1.max]);
FCM.NHL.DOC2.t2 = mean([FCM.NHL.DOC2.min, FCM.NHL.DOC2.max]);

% NHL learning parameters
FCM.NHL.n = 0.04;       % Learning Parameter (0 < n < 0.1)
FCM.NHL.g = 0.98;       % Weight decay parameter (0.9 < g < 1)
FCM.NHL.e = 0.002;      % Tolerance level keeping the variation of values DOCs
% This code is for calculating the automatic weight of causal relationships in Fuzzy cognitive map
% based on "Schneider, M., Shnaider, E., Kandel, A., & Chew, G. (1998).
% Automatic construction of FCMs. Fuzzy sets and systems, 93(2), 161-172."
% Code by Mohsen Abbaspour Onari

clear;
close all;
clc;

file = xlsread('Book3.xlsx');
data = file(1:12, 1:5);
[c.row, c.col] = size(data);
Relation = ceil(c.row/2);               % The index for determining the directly or indirectly relation

subtraction = {zeros(c.col, c.col)};    % The two vectors' subtraction amount
similarity = {zeros(c.col, c.col)};     % The two vectors' similar elements
number_sim = {zeros(c.col, c.col)};     % The amount of similar elements
di = {zeros(c.col, c.col)};             % The distance between the corresponding elements of vectors          
AD = zeros(c.col, c.col);               % The average distance between the vectors
S = zeros(c.col, c.col);                % Similarity between two vectors

for i = 1:c.col
    for j = 1:c.col
        
        if i == j
            subtraction{i,j} = 0;
            di{i,j} = 0;
        else
            subtraction{i,j} = data(:,i) - data(:,j);
            similarity{i,j} = find(abs(subtraction{i,j}) <= 0.2);
            number_sim{i,j} = numel([similarity{i,j}]);
            
            if number_sim{i,j} > Relation
                di{i,j} = data(:,i) - data(:,j);
            else
                di{i,j} = data(:,i) - (1-data(:,j));
            end          
            
        end
        
        AD(i,j) = sum(abs(subtraction{i,j}))/c.row;
        
        if i == j
            S(i,j) = 0;
        else
            S(i,j) = 1 - AD(i,j);
        end
        
        Final_Weights = round(S, 2);
%         Final_Weights = floor(S*100)/100;       % For Matlab 2013 and earlier
      
    end
end
disp(Final_Weights)
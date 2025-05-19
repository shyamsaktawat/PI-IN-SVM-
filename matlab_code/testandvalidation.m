clear all; 
close all;
y = xlsread("beer.csv");
% plot(y,'b-');
%%
% Fixed parameter definitions
win = 2;           % Fixed sliding-window size, for example.
s1 = 2^(-5);       % Fixed kernel parameter for the RBF kernel.
s2 = s1;           
C1 = 2^(0);        % Fixed regularization constant.
C2 = C1;
q_lower = 0.025;
q_upper = 0.975;
target_cov = 0.95;
c3 = 0.25;
%%
% Use fixed parameters (without grid search):
% Build sliding-window dataset using the fixed window size.
for i = 1:(length(y) - win)
    idx_window = i:(i+win-1);
    X_train(i,:) = y(idx_window, :);
    y_train(i,:) = y(idx_window(end)+1, :);
end

% Split data into training and testing sets (70% training, 30% testing).
splitIdx = floor(size(y_train,1)*0.7);
Xtest = X_train(splitIdx+1:end, :);
ytest = y_train(splitIdx+1:end, :);
X_train = X_train(1:splitIdx, :);
y_train = y_train(1:splitIdx, :);

% Create kernel parameter structures using fixed values.
kerfPara1 = struct('type', 'rbf', 'pars', s1);
kerfPara2 = struct('type', 'rbf', 'pars', s2);

% Compute predictions for the lower quantile.
[Pred_test_lower, f_lower, ~, ~] = epsilon_quantilesvr2(X_train, y_train, Xtest, kerfPara1, C1, q_lower, 0);
% Compute predictions for the upper quantile.
[Pred_test_upper, f_upper, ~, ~] = epsilon_quantilesvr2(X_train, y_train, Xtest, kerfPara2, C2, q_upper, 0);

% Evaluate performance metrics on the test set.
[PICP, MPIW] = evaluate_PICP(ytest, Pred_test_lower, Pred_test_upper);
fprintf('PICP = %.4f, MPIW = %.4f\n', PICP, MPIW);

% Plot the test set and the predicted quantile estimates.
hold on;
plot(ytest, 'b-');
plot(Pred_test_lower, 'r-');
plot(Pred_test_upper, 'k-');

%% Helper function for evaluation
function [PICP, MPIW] = evaluate_PICP(y, Low_Q, Up_Q)
    PICP = mean(y >= Low_Q & y <= Up_Q);
    MPIW = mean(Up_Q - Low_Q);
end

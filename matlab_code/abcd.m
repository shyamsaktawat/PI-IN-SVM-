clear;
close all;
clc;

% Load the Boston Housing dataset
data = readtable('boston_housing.csv'); % Ensure the CSV file is in your MATLAB path or provide the full path
X = data{:, 1:end-1};  % Features (all columns except the last one)
Y = data{:, end};      % Target variable (the last column)

% Parameters
s = 2^2;               % Kernel parameter
c1 = 2^3;              % Regularization parameter
c3 = 2^0;
eps1 = 0.2;            % Epsilon value
N = size(X, 1);        % Total number of samples
n = round(0.2 * N);    % Number of test samples (20% of the data)

% Initialize results cell array with 7 columns
results = cell(6, 7);  % 6 rows for header and lower quantiles
results(1,:) = {'Tau', 'RMSE (Lower, Upper)', 'Time', 'Sparsity (Lower, Upper)', 'Coverage Probability (Lower, Upper)', 'PICP', 'MPIW'};

% List of lower quantiles to be evaluated
lower_quantiles = [0.010, 0.015, 0.020, 0.025, 0.030];

% Split the data into training and testing sets
trainX = X(1:N-n, :);
ytrain = Y(1:N-n, :);
testX = X(N-n+1:N, :);
ytest = Y(N-n+1:N, :);

% Iterate over each quantile
for i = 1:length(lower_quantiles)
    tau_lower = lower_quantiles(i);
    tau_upper = 1 - lower_quantiles(i);  % Upper quantile as the complement of lower quantile
   
    % Predict the lower and upper quantiles using quantileLPONENORMTSVR
    tic; % Start timer
    [~, Low_Q, sparsity_lower] = quantileLPONENORMTSVR(trainX, ytrain, testX, s, c3, c1, tau_lower);
    [~, Up_Q, sparsity_upper] = quantileLPONENORMTSVR(trainX, ytrain, testX, s, c3, c1, tau_upper);
    elapsed_time = toc; % End timer
   
    % Calculate coverage probabilities for lower and upper quantiles
    CP_lower = length(find(ytest <= Low_Q)) / n;
    CP_upper = length(find(ytest <= Up_Q)) / n;
   
    % Evaluate PICP and MPIW using the EVal_PI function
    [PICP, MPIW] = EVal_PI(ytest, Low_Q, Up_Q);
   
    % Calculate RMSE for lower and upper quantiles
    rmse_low = sqrt(mean((ytest - Low_Q).^2));
    rmse_up = sqrt(mean((ytest - Up_Q).^2));
   
    % Store results in the results cell array
    results{i+1, 1} = ['(', num2str(tau_lower), ', ', num2str(tau_upper), ')'];
    results{i+1, 2} = sprintf('%.4f, %.4f', rmse_low, rmse_up); % RMSE
    results{i+1, 3} = sprintf('%.4f', elapsed_time); % Time
    results{i+1, 4} = sprintf('%.4f, %.4f', sparsity_lower, sparsity_upper); % Sparsity
    results{i+1, 5} = sprintf('%.4f, %.4f', CP_lower, CP_upper); % Coverage Probability
    results{i+1, 6} = sprintf('%.4f', PICP); % PICP
    results{i+1, 7} = sprintf('%.4f', MPIW); % MPIW
end

% Display results
disp('Results for Boston Housing Dataset');
disp(results);

% Save to CSV file
filename = 'results_PI_Boston_Housing_Dataset.csv';
writecell(results, filename);

% Function to evaluate PICP and MPIW
function [PICP, MPIW] = EVal_PI(y, Low_Q, Up_Q)
    % Ensure y, Low_Q, and Up_Q are column vectors
    y = y(:);
    Low_Q = Low_Q(:);
    Up_Q = Up_Q(:);
    % Calculate Prediction Interval Coverage Probability (PICP)
    PICP = mean(y >= Low_Q & y <= Up_Q);
    % Calculate Mean Prediction Interval Width (MPIW)
    MPIW = mean(Up_Q - Low_Q);
end
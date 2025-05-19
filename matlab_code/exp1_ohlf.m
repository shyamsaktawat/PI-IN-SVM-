% Step 1: Load your data from an Excel file
filename = 'bostonhousingdata.xlsx';  % Replace with your actual file name
data = readtable(filename);  % Load the data

% Step 2: Extract features (X) and response (Y)
X = table2array(data(:, [1,1:end-1]));  % All columns except the last one (features)
Y = table2array(data(:,end));      % Last column as the response variable

% Step 3: Normalize X using Z-score normalization
X_normalized= (X- mean(X))./ std(X)

% Step 4: Split the data into training and test sets

X_train = X_normalized(1:floor(size(X_normalized,1)*0.8),:);
Y_train =Y(1:floor(size(X_normalized,1)*0.8),:);
indx= randperm(floor(length(Y_train)*0.1));
Y_train(indx) = Y_train(indx)*5;
X_test =  X_normalized(floor(size(X_normalized,1)*0.9)+1:end,:);
Y_test = Y(floor(size(X_normalized,1)*0.9)+1:end,:);

% Step 6: Set kernel parameters, regularization, and epsilon values for SVR
kerfPara.type = 'rbf';  % Radial Basis Function (RBF) kernel
kerfPara.pars = 2^5;      % Kernel parameter (gamma for RBF)
C = 2^8;               % SVR with tau = 0.5 for standard regression
eps1 = 0;              % Epsilon-insensitive margin

% Step 7: Train the SVR model and make predictions using your custom function
%[PredictY, f1, nsv, sparsity] = epsilon_quantilesvr2(X_train_normalized, Y_train, X_test_normalized, kerfPara, C, tau, eps1);
[PredictY, f1,sparsity] = leastsquaresvr(X_train, Y_train, X_test, kerfPara, C);
                
% Step 8: Evaluate the results (Compare predictions with actual test values)
mseValue = sqrt(mean((PredictY - Y_test).^2))
R2= 1- sum((PredictY - Y_test).^2)/sum((mean(Y_test) - Y_test).^2)
fprintf('Mean Squared Error: %.4f\n', mseValue);
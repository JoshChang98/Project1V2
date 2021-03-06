function  [mu, Q] = CAPM(returns, factRet)

% Number of observations;
N = size(returns, 1);
%Number of columns in returns
n = size(returns,2);
%Number of columns in factor table
nFactCols = size(factRet,2);
% Calculate the factor expected excess return from historical data using
% the geometric mean
expExFactRet = geomean(factRet + 1) - 1;
% Calculate the factor variance
sigmaF = var(factRet);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% PART 2: Beta estimate 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% The function regress(y,X) requires a response vector y and a predictor
% matrix X. The matrix X must include a column of ones to account for the
% intercept alpha.
 X = [ones(N,1),factRet(:,1)];
%Use the closed-form (CF) solution to find the collection of alphas 
% and betas for all assets
temp = inv(transpose(X)* X)*transpose(X)*returns;
 alpha  = temp(1,:);
 temp_betaCF = temp(2,:);
 betaCF = transpose(temp_betaCF);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% PART 3: Portfolio optimization
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% For portfolio optimization we need the asset expected returns, mu, and
% the covariance matrix, Q. Therefore, we need the following parameters
% from our regression model
% - alpha (intercept)
% - beta (factor loading)
% - factor expected return
% - factor variance
% - residual variance (i.e., idiosyncratic risk)

%Calculating temp2: matrix of intercepts(alpha) and factor loading (beta)
%multiplied by factor
temp2 = X*temp;

%Calculating matrix of residuals:
resid = returns - temp2;

%Calculating D matrix:
denom = N-2;
D = zeros(n);
    for i = 1:n
       D(i,i) = sumsqr(resid(:,i)) / denom; 
    end

% Calculate the asset expected excess returns, mu
 mu = transpose(alpha) + betaCF*(expExFactRet(1));

% Calculate asset covariance matrix

temp =factRet(:,1);
 Q = betaCF*cov(temp)*transpose(betaCF) + D;

   
end
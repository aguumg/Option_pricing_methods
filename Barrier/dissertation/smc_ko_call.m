function c = smc_ko_call(model, option, M, N)
% SMC_KO_CALL prices a knock-out call option using sequential Monte Carlo.
% 
%   Required are:
%       model : struct with fields
%           sigma : Volatility
%           r     : Risk-free interest
%           S0    : Initial value
%       option : struct with fields
%           T : Time to maturity
%           K : Strike price
%           L : Lower barrier
%           U : Upper barrier
%       M : Number of paths
%       N : Number of time-steps
option.h = @(x) max(x-option.K, 0);
c = smc(model, option, M, N);
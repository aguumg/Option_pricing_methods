function c = smc_uo_call(model, option, M, N)
% SMC_UO_CALL prices an up-and-out call option using sequential Monte Carlo.
% 
%   Required are:
%       model : struct with fields
%           sigma : Volatility
%           r     : Risk-free interest
%           S0    : Initial value
%       option : struct with fields
%           T : Time to maturity
%           K : Strike price
%           B : Barrier
%       M : Number of paths
%       N : Number of time-steps
option.h = @(x) max(x-option.K,0);
option.U = option.B;
c = smc(model, option, M, N);
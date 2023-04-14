function c = log_pde_uo_call(model, option, M, N, R)
% LOG_PDE_UO_CALL prices an up-and-out call option using finite differences on
% the log transformed Black-Scholes PDE.
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
%       M : Number of pieces the domain will be divided into.
%       N : Number of pieces [0,T] will be divided into.
%       R : Truncation limit
opt.T = option.T;
opt.h = @(x) max(exp(x)-option.K,0);
opt.L = -R;
opt.U = log(option.B);

model.x0 = log(model.S0);
[c, ~] = log_pde_solve(model, opt, M, N);
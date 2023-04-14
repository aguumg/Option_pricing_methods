function c = bs_pde_ko_call(model, option, M, N)
% BS_PDE_KO_CALL prices a knock-out call option using finite differences on
% the Black-Scholes PDE.
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
%       M : Number of pieces the domain will be divided into.
%       N : Number of pieces [0,T] will be divided into.
option.h = @(x) max(x-option.K,0);
[c, ~] = pde_solve(model, option, M, N);
function c = bn_uo_call(model, option)
% BN_UO_CALL prices an up-and-out call option using the Borovkov-Novikov method.
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
phi = @(u) terminal_mgf(model, option, u);
psi = @(u, v) terminal_max_mgf(model, option, u, v);
B = log(option.U/model.S0);
c = exp(-model.r*option.T)*model.S0*bn_p2(option.K, B, phi, psi);
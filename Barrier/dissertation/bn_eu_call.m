function c = bn_eu_call(model, option)
% BN_EU_CALL prices a European call option using the Borovkov-Novikov method.
% 
%   Required are:
%       model : struct with fields
%           sigma : Volatility
%           r     : Risk-free interest
%           S0    : Initial value
%       option : struct with fields
%           T : Time to maturity
%           K : Strike price
phi = @(u) terminal_mgf(model, option, u);
c = exp(-model.r*option.T)*model.S0*bn_p1(option.K/model.S0, phi);
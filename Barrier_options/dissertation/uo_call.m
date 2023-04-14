function c = uo_call(model, option)
% UO_CALL prices an up-and-out call option using the analytical formula.
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

if option.K >= option.B
    c = 0;
    return;
end

% Up-and-in price
lambda = model.r/model.sigma^2 + 1/2;
y1 = log(model.S0/option.B)/(model.sigma*sqrt(option.T)) ...
    + lambda*model.sigma*sqrt(option.T);
y2 = log(option.B/model.S0)/(model.sigma*sqrt(option.T)) ...
    + lambda*model.sigma*sqrt(option.T);
x = log(option.B^2/(model.S0*option.K))/(model.sigma*sqrt(option.T)) ...
    + lambda*model.sigma*sqrt(option.T);
ci = model.S0*normcdf(y1) - option.K ...
        *exp(-model.r*option.T)*normcdf(y1 - model.sigma*sqrt(option.T)) ...
    - model.S0*(option.B/model.S0)^(2*lambda)*(normcdf(-x) - normcdf(-y2)) ...
    + option.K*exp(-model.r*option.T)*(option.B/model.S0)^(2*lambda-2) ...
        *(normcdf(-x+model.sigma*sqrt(option.T)) ...
            - normcdf(-y2+model.sigma*sqrt(option.T)));

% European call price
d1 = log(model.S0/option.K)/(model.sigma*sqrt(option.T)) ...
    + lambda*model.sigma*sqrt(option.T);
d2 = d1 - model.sigma*sqrt(option.T);
ce = model.S0*normcdf(d1) - option.K*exp(-model.r*option.T)*normcdf(d2);

% Up-and-out price from in-out parity
c = ce - ci;
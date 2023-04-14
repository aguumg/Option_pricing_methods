function psi = terminal_max_mgf(mod, opt, u, v)
% TERMINAL_MAX_MGF evaluates the joint mgf of the terminal and max value of
% a Wiener process with drift.
%
%   psi = TERMINAL_MAX_MGF(mod, opt, u, v) gives the joint mgf of the
%   terminal and maximum value of a Wiener process with drift evaluated at (u,v).
%
%   The struct mod must contain the fields
%       r      : Risk-free interest
%       sigma  : Volatility
%
%   The struct opt must contain the fields
%       T      : Time to maturity
normcdf_ = @(x) 0.5*(Faddeeva_erfc(-x/sqrt(2)));
psibar = @(u, v) 2*normcdf_(sqrt(opt.T)*(u+v)).*exp(1/2*opt.T*(u+v).^2).*(u+v)./(2*u+v) ...
    + normcdf_(1/2*sqrt(opt.T)*v).*exp(1/8*opt.T*v.^2).*(2*u.*exp(1/4*opt.T*u.*(2*u+v))./(2*u+v) - 1);
theta = mod.r/mod.sigma - mod.sigma/2;
psi = exp(-1/2*theta^2*opt.T)*psibar(u*mod.sigma + theta, v*mod.sigma);
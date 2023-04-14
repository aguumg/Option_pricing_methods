function phi = terminal_mgf(mod, opt, u)
% TERMINAL_MGF evaluates the mgf of the terminal of a Wiener process with drift.
%
%   phi = TERMINAL_MGF(mod, opt, u) gives the mgf of the terminal value of
%   a Wiener process with drift evaluated at u.
%
%   The struct mod must contain the fields
%       r      : Risk-free interest
%       sigma  : Volatility
%
%   The struct opt must contain the fields
%       T      : Time to maturity
phi = exp((mod.r - 1/2*mod.sigma^2)*u + 1/2*opt.T*mod.sigma^2*u.^2);
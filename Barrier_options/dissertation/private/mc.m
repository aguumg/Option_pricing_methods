function P = mc(mod, opt, M, N)
% MC runs the crude Monte Carlo algorithm.
%
%   P = MC(mod, opt, M, N) returns the time 0-price P of a barrier option with
%   payoff function h, estimated using the crude Monte Carlo estimator under the
%   Black-Scholes model with parameters specified by the struct mod.
%   The specifics of the option is  described by the struct opt. M trajectories
%   are simulated at N intermediate time-steps to estimate P.
%
%   The struct mod must contain the fields
%       S0     : Spot price
%       r      : Risk-free interest
%       sigma  : Volatility
%
%   The struct opt must contain the fields
%       T      : Time to maturity
%       h      : Function of terminal value, describing payoff at maturity.
%   and at least one of
%       L      : Lower boundary
%       U      : Upper boundary

dt = opt.T/N;

% Check boundaries and define indicator function and probabilities of not
% hitting the boundary.
if isfield(opt, 'L') && isfield(opt, 'U')
    ind = @(s) opt.L < s & s < opt.U;
    
    cutoff = 3;
    f = @(x,y) 1 - double_barrier_exit_prob(x, y, opt.L, opt.U, mod.sigma, dt, cutoff);
elseif isfield(opt, 'L')
    ind = @(s) opt.L < s;
    f = @(x,y) 1 - single_barrier_exit_prob(x, y, opt.L, mod.sigma, dt);
elseif isfield(opt, 'U')
    ind = @(s) s < opt.U;
    f = @(x,y) 1 - single_barrier_exit_prob(x, y, opt.U, mod.sigma, dt);
else
    error('No boundary specified in model.');
end

% Initialize variables
dW = randn(M,N);
G = zeros(M,N);
Snm1 = repmat(mod.S0, M, 1);
for n = 1:N
    % Sample next S values
    Sn = Snm1.*exp((mod.r - mod.sigma^2/2)*dt + mod.sigma*sqrt(dt)*dW(:,n));
    G(:,n) = ind(Sn).*f(Snm1,Sn);
    Snm1 = Sn;
end
P = exp(-mod.r*opt.T)*sum(prod([opt.h(Sn) G],2))/M;
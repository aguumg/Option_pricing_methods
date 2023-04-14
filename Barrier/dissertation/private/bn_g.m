function g = bn_g(a, b, s)
% BN_P2 evaluates function g in the Borovkov-Novikov theorem.
%
%   g = BN_G(a, b, s) returns the value of the function g in the
%   Borovkov-Novokov theorem evaluated at s.
%       a : real number
%       b : real number
%       s : real number
g = exp(1i*s*b-a*b)./((a-1i*s).*(1+a-1i*s));
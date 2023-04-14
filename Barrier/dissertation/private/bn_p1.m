function P1 = bn_p1(K, phi)
% BN_P1 evaluates the expectation P1 in the Borovkov-Novikov theorem.
%
%   P1 = BN_P2(K, phi) returns the value of the expectation
%       P1 = E[max(exp(X)-K,0)]
%   with
%       K   : real number
%       phi : mgf of X
a=9;
g = @(s) bn_g(a, log(K), s);
% `real` just to satisfy Matlab
P1 = real(1/(2*pi)*integral(@(s) phi(1+a-1i*s).*g(s), -Inf, Inf)); 
function y = sample_weighted(n, x, w)
% SAMPLE_WEIGHTED samples from a discrete distribution, taking values x.
%
%   y = SAMPLE_WEIGHTED(n, x, w) samples n random variables from the
%   distribution taking the value x(j) with probability w(j), for j =
%   1..length(x). Both x and w are assumed to be vectors and have the same
%   length.
if length(x) ~= length(w)
    error('Length mismatch between parameters ''x'' and ''w''.');
end
E = exprnd(1,n+1,1);
T = cumsum(E);
V = T./T(end);
k = 1; r = 1;
y = zeros(n,1);
W = cumsum(w);
while r <= n
    while V(r) < W(k) && r <= n
        y(r) = x(k);
        r = r + 1;
    end
    k = k + 1;
end
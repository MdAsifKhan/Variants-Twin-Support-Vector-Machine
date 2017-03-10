function [res]  = scale(A)
mn = min(A);
mx = max(A);
e = ones(size(A,1),1);
res = (A-e*mn)./(e*(mx-mn));
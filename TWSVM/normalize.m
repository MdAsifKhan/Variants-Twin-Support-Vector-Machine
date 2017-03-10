%   -----------------------------------------------------------------------
%   Time series problem whose input series is given as A matrix, with N 
%   attributes i.e. A(M:N). Here we normalize the data column-wise so that
%   the mean of the series is zero with standard deviation equals to one.
%   Input is the two-demensional matrix A(.) and the output is the
%   two-dimensional matrix c(.)
%   -----------------------------------------------------------------------    
function c = normalize(A)
    [m,n] = size(A);
    e = ones(m,1);
    sd = std(A);
    c = A - e*mean(A);
    c =imdivide(c,e*sd); 
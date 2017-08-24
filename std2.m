function s = std2(a)
%std2 standard deviation of matrix elements.
%
% Author: Peter Burns, 1 Oct. 2008
% Copyright (c) 2007 Peter D. Burns

a = double(a);
s = std(a(:));

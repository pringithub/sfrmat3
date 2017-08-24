function [loc] = centroid(x)
% function [loc] = centroid(x)
%  Returns centroid location of a vector
%   x = vector
%   loc = centroid in units of array index
%       = 0 error condition avoids division by zero, often due to clipping
%  Author: Peter Burns, 1 Oct. 2008
%  Copyright (c) 2007 Peter D. Burns

n   = 1:length(x);
sumx = sum(x);
if sumx < 1e-4;
 loc = 0;
 else loc = sum(n*x)/sumx;
end

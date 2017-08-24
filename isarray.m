function out = isarray(a)
% out = isarray(a)
% isarray: true if the variable is an array (>1-dimension), false if not
%
% usage: ret = isarray(v)
%
% arguments:
%     a    = variable.
%     out = 1 if a is a 2-dimensional or higher
%         = 0 if not
%
% 22 Aug. 2008
% Copyright (c) Peter D. Burns 2008

dim = size(a);

if min(dim) > 1;
 out=1;
else
 out=0;
end

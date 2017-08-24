function [b] = cent(a, center);
% Usage: [b] = cent(a, center)
% Matlab function cent, shift of one-dimensional
% array, so that a(center) is located at b(round((n+1)/2).
% Written to shift a line-spread function array prior to 
% applying a smoothing window.
%  a      = input array
%  center = location of signal center to be shifted
%  b      = output shifted array
%
%  Author: Peter Burns, 1 Oct. 2008
%  Copyright (c) 2007 Peter D. Burns

n = length(a);
b = zeros(n, 1);
mid = round((n+1)/2);

del = round(center - mid);

if del > 0;
     for i = 1:n-del;
       b(i) = a(i + del);
     end;

elseif del < 1;
     for i = -del+1:n;
       b(i) = a(i + del);
     end;

   else b = a;
end;

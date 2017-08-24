function out = rotate90(in, n)
%[out] = rotate90(in, n) 90 degree counterclockwise rotations of matrix
% in  = input matrix (n,m) or (n,m,k)
% n   = number of 90 degree rotation
% out = rotated matrix
%       default = 1
% Usage:
%  out = rotate90(in)
%  out = rotate90(in, n)
% Needs:
%  r90 (in this file)
%
% Author: Peter Burns, 1 Oct. 2008
% Copyright (c) 2007 Peter D. Burns

if nargin < 2;
 n = 1;
end

nd = ndims(in);

if nd < 1
 error('input to rotate90 must be a matrix');
 return
end

for i = 1:n
 out = r90(in);
 in = out;
end
return


function [out] = r90(in)

[nlin, npix, nc] = size(in);
temp = zeros (npix, nlin);
out = zeros (npix, nlin, nc);

for c = 1: nc;

    temp =  in(:,:,c);
    temp = temp.';
    out(:,:,c) = temp(npix:-1:1, :);
                     
end

out = squeeze(out);

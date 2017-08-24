function [a, nlin, npix, rflag] = rotatev(a)
% [a, nlin, npix, rflag] = rotatev(a)
% Rotate array so that long dimensions is vertical (line) drection
% a = input array(npix, nlin, ncol)
% nlin, npix are after rotation if any
% flag = 0 no roation, = 1 rotation was performed
%
% Author: Peter Burns, 1 Oct. 2008
% Copyright (c) 2007 Peter D. Burns

dim = size(a);
nlin = dim(1);
npix = dim(2);
if size(dim)==[1 2];
  ncol =1;
 else;
  ncol = dim(3);
 end;

 rflag =0;
if npix>nlin;
 rflag =1;

 a = rotate90(a);

 temp=nlin;
 nlin = npix;
 npix = temp;

end

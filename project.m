function [point, status] = project(bb, loc, slope, fac)
% [point, status] = project(bb, loc, slope, fac)
% Projects the data in array bb along the direction defined by
%  npix = (1/slope)*nlin.  Used by sfrmat11 and sfrmat2 functions.
% Data is accumulated in 'bins' that have a width (1/fac) pixel.
% The smooth, supersampled one-dimensional vector is returned.
%  bb = input data array
%  slope and loc are from the least-square fit to edge
%    x = loc + slope*cent(x)
%  fac = oversampling (binning) factor, default = 4
%  Note that this is the inverse of the usual cent(x) = int + slope*xstatus =1;
%  point = output vector
%  status = 1, OK
%  status = 1, zero counts encountered in binning operation, warning is
%           printed, but execution continues
%
%Peter Burns 24 Oct. 2008
%              fac input arguement added 8 May 2000
% Copyright (c) Peter D. Burns 1998-2008
%
status =0;
[nlin, npix]=size(bb);

if nargin<4
 fac = 4 ;
end;

big = 0;
nn = npix *fac ;

% smoothing window
  win = ahamming(nn, fac*loc(1, 1));

 slope =  1/slope;
  offset =  round(  fac*  (0  - (nlin - 1)/slope )   );

 del = abs(offset);
 if offset>0 offset=0;
 end

 barray = zeros(2, nn + del+100);

% Projection and binning
  for n=1:npix;
  for m=1:nlin;
   x = n-1;
   y = m-1;
   ling =  ceil((x  - y/slope)*fac) + 1 - offset;
   barray(1,ling) = barray(1,ling) + 1;
   barray(2,ling) = barray(2,ling) + bb(m,n);
  end;
 end;

 point = zeros(nn,1);
 start = 1+round(0.5*del); %*********************************

% Check for zero counts
  nz =0;
 for i = start:start+nn-1; % ********************************

  if barray(1, i) ==0;
   nz = nz +1;
   status = 0;  
   if i==1;
    barray(1, i) = barray(1, i+1);
   else;
    barray(1, i) = (barray(1, i-1) + barray(1, i+1))/2;
   end;
  end;
 end;
 
 if status ~=0;
  disp('                            WARNING');
  disp('      Zero count(s) found during projection binning. The edge ')
  disp('      angle may be large, or you may need more lines of data.');
  disp('      Execution will continue, but see Users Guide for info.'); 
  disp(nz);
 end;

 for i = 0:nn-1; 
  point(i+1) = barray(2, i+start)/ barray(1, i+start);
 end;
return;

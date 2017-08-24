function [array, status] = getoecf(array,  oename)
% [array, status] = getoecf(array,  oename)  applies oecf LUT
% Reads look-up table and applies it to a data array
%
%  Usage: [array, status] = getoecf(array, oename)       
%   array = data array (nlin, pnix, ncolor)
%   oename = name of tab-delimited text file for table (256x1, 256,3), or
%          = oecf LUT array (256x1, 256,3)
%   array = returns transformed array
%   status = 0  OK, 
%          = 1 bad table file
%
%1 Oct. 2008
% Copyright (c) Peter D. Burns 2002-2008

status = 0;
stuff = size(array);
nlin = stuff(1);
npix = stuff(2);
if size(stuff)==[1 2];
   ncol = 1;
else
   ncol = stuff(3);
end;

if nargin ~= 2

 disp('getoecf needs 2 input arguments');
 array = 0;
 status = 1;
 return
else
  if ischar(oename) == 0; 
     oedat = oename;
  else temp = oename;
     oedat =load(temp);     
  end
  dimo = size(oedat);
 if dimo(2) ~=ncol;
   status = 1;
   return;
 end;

end

array = round(double(array));      % Added 30 Sept 2002

if ncol==1;
   for i=1: nlin;
      for j = 1: npix;
        array(i,j) = oedat( array(i,j)+1, ncol);
      end;
   end;
else
   for i=1: nlin;
      for j = 1: npix;
         for k=1:ncol;
            array(i,j,k) = oedat( array(i,j,k)+1, k);
         end;
      end;
   end;
end;

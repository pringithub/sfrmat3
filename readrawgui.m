function [nbyte, nlin, npix, ncol] = readrawgui(fn, nbyte, nlin, npix, ncol);
%[nbyte, nlin, npix, ncol] = readrawgui(filename, nbyte, nlin, npix, ncol)
% User input needed for reading .raw files by imageread.
%  nbyte (bytes/pixel/color), nlin, npix, ncol(number of colors) are default
%  values for gui. If not specified the defaults are (see source)
%   nbyte=2;
%   ncol = 1;
%
% 22 Aug. 2008
% Copyright (c) Peter D. Burns 2008
%
if nargin < 1 | isempty(fn) == 1;
   fn = '       ';
end

if nargin < 2;
    nbyte = '2';
    nlin = ' ';
    npix = ' ';
    ncol = '1';
else
   nbyte = num2str(nbyte);
   nlin = num2str(nlin);
   npix = num2str(npix);
   ncol = num2str(ncol); 
end    
   prompt={'Bytes / pixel / color:','Pixels / line','Lines / image',...
            'Color records / pixel'};
   def={nbyte, nlin, npix, ncol};
   dlgTitle=['Parameters: ',fn];
   lineNo=1;

   nans=inputdlg(prompt,dlgTitle, lineNo, def);
   
   if isempty(nans) == 1;
       disp('Cancelled');
       nbyte = 0;
       nlin = 0;
       npix = 0;
       ncol = 0;
       return
   end
   nbyte = str2num(nans{1});
   nlin  = str2num(nans{2});
   npix  = str2num(nans{3});
   ncol  = str2num(nans{4});
end


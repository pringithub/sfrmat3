function [dat1] = readraw1(fn, nbyte, nlin, npix, ncol)
%[dat1] = readraw1(fn, nbyte, nlin, npix, ncol) read images stored as raw
% data files. User input for file selection and number of lines,
% pixels is asked for.
% nbyte can equal to 1 or 2
% Usage: > [dat] = readraw
%          [dat] = readraw(fn)
%          [dat] = readraw(fn, nbyte)
%
% 22 Aug. 2008
% Copyright (c) Peter D. Burns 2008
%
szflag = 1;
if nargin < 5
    szflag = 1;
end

if nargin <1 | isempty(fn) == 1;
    [filename, pathname] = uigetfile('*.raw','Select input data file (raw)');

     if (filename==0)
      disp('No file selected');
      dat1 = 0;;
      return;
     end;
     fn=[pathname,filename];
     btyte = 1;
    end
disp(fn)
if nargin <2
    nbyte =2;
    nt = input('How many bytes/pixel/color [2]? ');
    if isempty(nt) ~= 1;
       nbyte = round(nt);
    end
end

if nbyte == 1;
     ff = 'uint8=>uint8';
else ff = 'uint16=>uint16';
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

fid = fopen(fn, 'rb');

[dat,count] = fread(fid,inf, ff);
% x = reshape(x,1,count);
status = fclose(fid);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
[ndat, ncol] = size(dat);

if nargin < 4;
    disp(['    ', num2str(ndat), ' pixels,  ', num2str(ncol),' records']);

    nlin = input(['How many lines [',num2str(ndat),']? ']);
    if isempty(nlin) ==1;
        nlin = ndat;
    end
    npix = input('How many pixels [1]?');
    if isempty(npix) ==1;
        npix = 1;
    end
    ncol = input('How mant color records (1 or 3) [1]? ');
    if isempty(ncol) ==1;
        ncol = 1;
    end
    ntot = nlin*npix*ncol;

    if ntot~=ndat
     disp('Error: nlin*npix not equal to ndat')
    return
    end
end % if nargin <4

dat1 = reshape(dat, npix, nlin, ncol);
dat1 = squeeze(dat1);

 
% Rotation due to Matlab column-first convention;

if ncol==1;
    dat1 = rot90(dat1,+1);
else
    temp = zeros(nlin, npix, ncol, ff);
    for ii = 1:ncol;
        temp(:,:,ncol) = rot90(dat1(:,:,ncol),+1);
    end
    dat1 = temp;
end
    








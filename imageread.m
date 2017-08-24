function [status, dat1, ftype, fpath, fname] = imageread(filename, nlin, npix)
%[status,dat,ftype,fpath,fname] = imageread(fname, nlin, npix) reads image files;
% tif, jpeg, DICOM, rvg and raw (byte data without header) data with file browser
% if needed. The file extension is used to idntify file format.
% filename = optional file name
% status   = 0 OK
%          = 1 not OK
% dat      = image data array
% ftype    = file extension (if file chosen ins a DIC0M file, ftype is
%            returned as the DICOM header stucture). 
%
% Needs: imread, dicomread (image proc. toolbox)
%        readraw1, readrawgui
%        Matlab 7.1 or higher for RVG files
% Examples
%>> [status, dat] = imageread;
%>> [status, dat, ftype] = imageread('test.tif');
%
%Peter Burns , 30 August 2007
% Copyright (c) Peter D. Burns 2007-2008
%
status = 0;
if nargin< 3;
  npix = 0;
end
if nargin< 2;
  nlin = 0;
end

if  nargin < 1 | isempty(filename) == 1;
  sup =['*.dcm;*.DCM;*tif;*TIF;*.tiff;*.TIFF*.jpg;*.jpeg;*.JPG;*.JPEG;', ...
       '*.tif;*.TIF;*.tiff;*.TIFF*.gif;*.GIF;*.bmp;*.BMP;*.rvg;*.RVG;*raw;*.RAW'];  
  ftype =  {sup,  'Supported: jpg, tif, bmp, dcm, rvg, raw ...'; ...     
           '*.dcm;*.DCM;*tif;*TIF;*.tiff;*.TIFF', 'Dicom, TIF';
           '*.jpg;*.jpeg;*.JPG;*.JPEG',  'JPEG'; ...
           '*.tif;*.TIF;*.tiff;*.TIFF',  'TIF'; ... 
           '*.gif;*.GIF;',  'GIF'; ...
           '*.bmp;*.BMP;',  'BMP'; ...
           '*.rvg;*.RVG;',  'RVG'; ...
           '*.raw;*.RAW;',  'RAW'; ...
           '*.*',  'All Files (*.*)'};

    [fname, fpath] = uigetfile(ftype,'Select input image file (tif, jpg, bmp, gif... )');
    if fname == 0;
        status = 1;
        dat1 = 0;
        ftype = 0;
        disp('No file chosen');
        return
    end
     filename = [fpath, fname];
end %  nargin < 1;

ftype = filename(end-2: end);

if ftype == 'dcm' | ftype == 'DCM' 
   dtest = exist('dicomread');
   if dtest ~= 0;
         info = dicominfo(filename);
         dat1 = dicomread(filename);
         ftype = info;
   else
         disp(' ** You do not appear to have the image processing toolbox.');
         disp(' ** DICOMREAD from this library is needed to read DICOM files.');
         beep
     status = 1;
     dat1   = 0;
     ftype  = 0;
     return    
   end

elseif ftype == 'rvg' | ftype == 'RVG'
   ver = version;
   vernum = str2num(ver(1:3));
   if vernum < 7.1;
     disp(' **  Unfortunately, you will need Matlab 7.1  **')
     disp(' **  or higher to read RVG files.             **');
     beep
     status = 1;
     dat1   = 0;
     ftype  = 0;
     return    
   else dtest = exist('dicomread');
     if dtest ~= 0;
        dat1 = dicomread(filename);
     else
         disp(' ** You do not appear to have the image processing toolbox.');
         disp(' ** DICOMREAD from this library is needed to read DICOM files.');
         beep
         status = 1;
         dat1   = 0;
         ftype  = 0;
         return
     end
   end
elseif ftype == 'raw' | ftype == 'RAW'
   % Note I am specifying default settings for nbyte, and ncol)
    [nbyte, npix, nlin, ncol] = readrawgui(filename, 2, npix, nlin, 1);
    
    if nbyte == 0;
      status = 1;
      dat1   = 0;
      ftype  = 0;
      return
    end
   dat1 = readraw1(filename, nbyte, nlin, npix, ncol);       
else 
   dat1 = imread(filename);  
end

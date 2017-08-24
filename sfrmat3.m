function [status, dat, e, fitme, esf, nbin, del2] = sfrmat3(io, del, weight, a, oename)
% MatLab function: sfrmat3   Slanted-edge Analysis for digital camera and scanner
%                            evaluation. Updated version of sfrmat2.
%  [status, dat, fitme, esf, nbin, del2] = sfrmat3(io, del, weight, a, oecfname);
%       From a selected edge area of an image, the program computes
%       the ISO slanted edge SFR. Input file can be single or
%       three-record file. Many image formats are supported. The image
%       is displayed and a region of interest (ROI) can be chosen, or
%       the entire field will be selected by not moving the mouse
%       when defining an ROI (simple click). Either a vertical or horizontal
%       edge features can be analized.
%  Input arguments:
%      io  (optional)
%        0 = (default) R,G,B,Lum SFRs + edge location(s)
%          = 'sfrmat2'  R,G,B,Lum SFRs + edge location(s)but
%            with the same calculations as the previous version, sfrmat2
%        1 = Non GUI usage with supplied data array
%      del (optional) sampling interval in mm or pixels/inch
%          If dx < 1 it is assumed to be sampling pitch in mm
%          If io = 1 (see below, no GUI) and del is not specified,
%          it is set equal to 1, so frequency is given in cy/pixel.
%      weight (optiona) default 1 x 3 r,g,b weighs for luminance weighting
%      a   (required if io =1) an nxm or nxmx3 array of data
%      oename  optional name of oecf LUT file containing 3xn or 1xn array
%
% Returns: 
%       status = 0 if normal execution
%       dat = computed sfr data
%       fitme = coefficients for the linear equations for the fit to
%               edge locations for each color-record. For a 3-record
%               data file, fitme is a (4 x 3) array, with the last column
%               being the color misregistration value (with green as 
%               reference).
%       esf = supersampled edge-spread functin array
%       nbin = binning factor used
%       del2 = sampling interval for esf, from which the SFR spatial
%              frequency sampling is was computed. This will be 
%              approximately  4  times the original image sampling.
%
%EXAMPLE USAGE:
% sfrmat3     file and ROI selection and 
% sfrmat3(1) = GUI usage
% sfrmat3(0, del) = GUI usage with del as default sampling in mm 
%                   or dpi 
% sfrmat3(2, del, weight) = GUI usage with del as default sampling
%                   in mm or dpi and weight as default luminance
%                   weights
% sfrmat3(4, dat) = non-GUI usage for data array, dat, with default
%                   sampling and weights aplied (del =1, 
%                   weights = [.3 .6 .1])
% [status, dat, fitme] = sfrmat3(4, del, weight, a, oecfdat);
%                   sfr and edge locations, are returned for data
%                   array dat using oecf array, oecfdat, with
%                   specified sampling interval and luminance weights
% 
%Provided in support of digital imaging performance standards being development
%by the International Imaging Industry Association (i3a.org).
%
%Author: Peter Burns, 24 July 2009
%                     12 May 2015  updated legend title to be compatible
%                     with current Matlab version (legendTitle.m)
% Copyright (c) 2009-2015 Peter D. Burns, pdburns@ieee.org
%******************************************************************
status = 0;
defpath = path;            % save original path
home = pwd;                % add current directory to path                   
addpath(home);
name =    'sfrmat3';
version = '2.0';
when =    '12 May 2015';

%ITU-R Recommendation  BT.709 weighting
guidefweight =  ['0.213'
                 '0.715'
                 '0.072'];
%Previously used weighting
defweight = [0.213   0.715   0.072];

oecfdatflag = 0;
oldflag = 0;
nbin = 4;

sflag = 0;
pflag=0;
switch nargin

    case 0
     io =0;
     del =1;
     weight = guidefweight;
     oename = 'none';

    case 1
      if isempty(io) ==1;
          io =0;
      else
        if ischar(io) == 1;
            test = 'sfrmat2';
         if strcmpi(io, test) == 1;
            oldflag = 1;
            defweight = [0.3   0.6   0.1];
         end
         io = 0;
        end
      end
      del = 1;
      weight = guidefweight;
      oename = 'none';

    case 2
     if isempty(io) == 1;
         io = 0;
     end
     if isempty(del) == 1;
         del = 1;
     end
     oename = 'none';
    case 3
      if isempty(io) == 1;
         io = 0;
      end
      if isempty(del) == 1;
         del = 1;
      if isempty(weigh) == 1
         weight = guidefweight;
      else wsize = size(weight);
         if wsize ~= [1, 3];
           weight = guidefweight;
           oename = 'none';
         end
      end
      end

    case 4
      if isempty(io) == 1;
         io = 0;
      elseif ischar(io) == 1;
            test = 'sfrmat2';
            if strcmpi(io, test) == 1;
              oldflag = 1;
              defweight = [0.3   0.6   0.1];
            end
            io = 1;
      end

       a = double(a);
      
      if isempty(del) == 1;
         del = 1;
      end
      if isempty(weight) == 1
           weight = guidefweight;
        else wsize = size(weight);
           if wsize ~= [1, 3];
             weight = guidefweight;
             oename = 'none';
           end
       end
        
    case 5
     
    disp(oename);
    oecfdatflag = 1;
    otherwise
     disp('Incorrect number or arguments. There should be 1 -5');
     status = 1;
     return

end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if io ~= 0 & io ~= 1
    beep
    disp(['Input argument io shoud be 0 or 1, setting equal to 0'])
    io =0;
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Suppresses interpreting of e.g. filenames
 set(0, 'DefaultTextInterpreter', 'none'); 

if io ~= 1;
    
    swin = splash(name, version, when);
    
    % Select file name for reading
    % edit the next line to change the default path for input file selection
    
    drawnow;
    
    pause(.2)
    [status, atemp, ftype, pathname, f] = imageread;
    
    close(swin); drawnow;
    
    if status~=0
        disp('No file selected. To try again type: > sfrmat3');
        status = 1;
        return;
    end;
    filename = [pathname,f];
    [nlin npix ncol] = size(atemp);

    % input sampling and luminance weights
    if ncol==1;
         del = inbox1;
    else 
        [del, weight] = inbox3(del, guidefweight); 
    end;
    % used for plotting and listing
    if del==1;
        funit =  'cy/pixel';
    else funit = 'cy/mm';
    end;
    
    cname = class(atemp);
    if strcmp(cname(1:5), 'uint1') == 1;   % uint16
        smax = 2^16-1;
    elseif strcmp(cname(1:5), 'uint8') == 1;
        smax = 255;
    else
        smax = 1e10;
    end

    [a, roi] = getroi(atemp);
     a = double(a);
    % extract Region of interest
    clear atemp                             % *******************************
    [nlow, nhigh, cstatus] = clipping(a, 0, smax, 0.005);
    if cstatus ~=1; 
     disp('Fraction low data');
     disp(nlow);
     disp('Fraction high data');
     disp(nhigh);
    end;

    if oecfdatflag == 1;
     disp('Applying OECF look-up table');
     [a, oestatus] = getoecf(a, oename);   % Transforms a using OECF LUT from file chosen
    end;

    %%%%
else                     % when io = 1

    a= double(a);
    if oecfdatflag ~= 0;
      oecfdat=load(oename);
      size(oecfdat);
      [a, oestatus] = getoecf(a, oecfdat);
     disp('oecfdat applied')
    end

    if del > 1
       del = 25.4/del;  % Assume input was in DPI convert to pitch in mm
    end;

end; 

[nlin npix ncol] = size(a);

% Form luminance record using the weight vector for red, green and blue
if ncol ==3;
   
    disp "size of a:"
    size(a)
    disp " "
    nlin
    npix
    lum = zeros(nlin, npix);
    
    disp "size of lum"
    size(lum)
    
    disp "size of a(:,:,1)"
    size(a(:,:,1))
    
    disp "size of a(:,:,2)"
    size(a(:,:,2))
    
    disp "size of a(:,:,3)"
    size(a(:,:,3))
    
    disp "size of weight"
    size(weight)
    
    lum = weight(1)*a(:,:,1) + weight(2)*a(:,:,2) + weight(3)*a(:,:,3); 
    cc = zeros(nlin, npix*4);
    cc = [ a(:, :, 1), a(:, :, 2), a(:,:, 3), lum];
    cc = reshape(cc,nlin,npix,4);

    a = cc;
    clear cc;
    clear lum;
    ncol = 4; 
end;

% Rotate horizontal edge so it is vertical
% [a, nlin, npix, rflag] = rotatev(a);  %sfrmat2 version based on dimensions
 [a, nlin, npix, rflag] = rotatev2(a);  %based on data values

loc = zeros(ncol, nlin);

fil1 = [0.5 -0.5];
fil2 = [0.5 0 -0.5];
% We Need 'positive' edge
tleft  = sum(sum(a(:,      1:5,  1),2));
tright = sum(sum(a(:, npix-5:npix,1),2));
if tleft>tright;
    fil1 = [-0.5 0.5];
    fil2 = [-0.5 0 0.5];
end
% Test for low contrast edge;
 test = abs( (tleft-tright)/(tleft+tright) );
 if test < 0.2;
    disp(' ** WARNING: Edge contrast is less that 20%, this can');
    disp('             lead to high error in the SFR measurement.');
 end; 

fitme = zeros(ncol, 3);
slout = zeros(ncol, 1);

% Smoothing window for first part of edge location estimation - 
%  to be used on each line of ROI
 win1 = ahamming(npix, (npix+1)/2);    % Symmetric window

for color=1:ncol;                      % Loop for each color
    %%%% 
    c = deriv1(a(:,:,color), nlin, npix, fil1);

    % compute centroid for derivative array for each line in ROI. NOTE WINDOW array 'win'
    for n=1:nlin
        loc(color, n) = centroid( c(n, 1:npix )'.*win1) - 0.5;   % -0.5 shift for FIR phase
    end;
    % clear c

    fitme(color,1:2) = findedge(loc(color,:), nlin);
    place = zeros(nlin,1);
    for n=1:nlin;
        place(n) = fitme(color,2) + fitme(color,1)*n;
        win2 = ahamming(npix, place(n));
        loc(color, n) = centroid( c(n, 1:npix )'.*win2) -0.5;
    end;

    fitme(color,1:2) = findedge(loc(color,:), nlin);

end;                                          % End of loop for each color

summary{1} = ' '; % initialize

if io > 0;
    midloc = zeros(ncol,1);
    summary{1} = 'Edge location, slope'; % initialize

    for i=1:ncol;
        slout(i) = - 1./fitme(i,1);      % slope is as normally defined in image coods.
    if rflag==1,                         % positive flag it ROI was rotated
        slout(i) =  - fitme(i,1);
    end;

    % evaluate equation(s) at the middle line as edge location
    midloc(i) = fitme(i,2) + fitme(i,1)*((nlin-1)/2);
    summary{i+1} = [midloc(i), slout(i)];
    end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if ncol>2;
    summary{1} = 'Edge location, slope, misregistration (second record, G, is reference)';
    misreg = zeros(ncol,1);
    for i=1:ncol;
        misreg(i) = midloc(i) - midloc(2);
        summary{i+1}=[midloc(i), slout(i), misreg(i)];
        fitme(i,3) = misreg(i);
    end;
    if io == 5; 
        disp('Misregistration, with green as reference (R, G, B, Lum) = ');
        for i = 1:ncol
            fprintf('%10.4f\n', misreg(i))
        end;
    end  % io ==5
end  % ncol>2

end                             %************ end of check if io > 0


% Full linear fit is available as variable fitme. Note that the fit is for
% the projection onto the X-axis,
%       x = fitme(color, 1) y + fitme(color, 2)
% so the slope is the inverse of the one that you may expect

% Limit number of lines to integer(npix*line slope as per ISO algorithm
% except if processing as 'sfrmat2'
if oldflag ~= 1;
%   disp(['Input lines: ',num2str(nlin)]) 
    nlin1 = round(floor(nlin*abs(fitme(1,1)))/abs(fitme(1,1)));
%   disp(['Integer cycle lines: ',num2str(nlin1)])
    a = a(1:nlin1, :, 1:ncol);           
end
%%%%
vslope = fitme(1,1);
slope_deg= 180*atan(abs(vslope))/pi;
disp(['Edge angle: ',num2str(slope_deg, 3),' degrees'])
if slope_deg < 3.5
    beep, warndlg(['High slope warning ',num2str(slope_deg,3),' degrees'], 'Watch it!')
end
%%%%
del2=0;
if oldflag ~= 1;
%Correct sampling inverval for sampling parallel to edge
    delfac = cos(atan(vslope));
    del = del*delfac;
    del2 = del/nbin;
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
ns = length(summary);
summary{ns+1} = [del, del2];

nn =   floor(npix *nbin);
mtf =  zeros(nn, ncol);
nn2 =  floor(nn/2) + 1;

if oldflag ~=1;
    disp('Derivative correction')
    dcorr = fir2fix(nn2, 3);    % dcorr corrects SFR for response of FIR filter
end

freq = zeros(nn, 1);
for n=1:nn;
    freq(n) = nbin*(n-1)/(del*nn);
end;

freqlim = 1;
if nbin == 1;
    freqlim = 2;
end
nn2out = round(nn2*freqlim/2);

nfreq = n/(2*del*nn);    % half-sampling frequency
win = ahamming(nbin*npix,(nbin*npix+1)/2);      % centered Hamming window


% **************                      Large SFR loop for each color record
esf = zeros(nn,ncol);  

for color=1:ncol
    % project and bin data in 4x sampled array
    [point, status] = project(a(:,:,color), loc(color, 1), fitme(color,1), nbin);

    esf(:,color) = point;  

    % compute first derivative via FIR (1x3) filter fil
    c = deriv1(point', 1, nn, fil2);
    c = c';

    psf(:,color) = c;   

    mid = centroid(c);
    temp = cent(c, round(mid));              % shift array so it is centered
    c = temp;
    clear temp;

    % apply window (symmetric Hamming)
    c = win.*c;
    
    %%%%  
    % Transform, scale and correct for FIR filter response

    temp = abs(fft(c, nn));
    mtf(1:nn2, color) = temp(1:nn2)/temp(1);
    if oldflag ~=1;
        mtf(1:nn2, color) = mtf(1:nn2, color).*dcorr;
    end
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
end;     % color=1:ncol

dat = zeros(nn2out, ncol+1);
sfrValAt83 = 0;
for i=1:nn2out;
    dat(i,:) = [freq(i), mtf(i,:)];
    
    % added by Phillip Ring (Occipital)
    if (i>2 && dat(i-1)<83 && dat(i)>83);
       sfrValAt83 = dat(i,2)
    end;
end;



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Sampling efficiency
%Values used to report: note lowest (10%) is used for sampling efficiency
val = [0.1, 0.5];
[e, freqval, sfrval] = sampeff(dat, val, del, 0, 0);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
ns = length(summary);
summary{ns+1} = e;

if io ==1;         
    return
end
% Plot SFRs on same axes
if ncol >1;
  sym{1} = []; 
  sym{1} = '--r';
  sym{2} = '-g';
  sym{3} = '-.b';
  sym{4} = '*k';
  ttext = filename;
  legg = [{'r'},{'g'},{'b'},{'lum'}];
else
  ttext = filename;
  sym{1} = 'k';
end

 screen = get(0, 'ScreenSize');
 pos = round(centerfig(1, 0.6,0.6));
  
%%%%%%%%%%%%%%%%%%%
 nn4 =  floor(nn/8) + 1;
 cc = [.5 .5 .8];
 
figure('Position',pos)
 plot( freq( 1:nn2out), mtf(1:nn2out, 1), sym{1});
 hold on;
  title(ttext);
  xlabel(['     Frequency, ', funit]);
  ylabel('SFR');
	if ncol>1;
		for n = 2:ncol-1;
			plot( freq( 1:nn2out), mtf(1:nn2out, n), sym{n});
		end;
		ndel = round(nn2out/30);
		plot(  freq( 1:ndel:nn2out), mtf(1:ndel:nn2out, ncol), 'ok',...
            freq( 1:nn2out), mtf(1:nn2out, ncol), 'k')
		

            h=legend(['r   ',num2str(e(1)),'%'],['g   ',num2str(e(2)),'%'],...
                        ['b   ',num2str(e(3)),'%'],...
                        ['L   ',num2str(e(4)),'%']);
            pos1 =  get(h,'Position');
            set(h,'Position', [0.97*pos1(1) 0.93*pos1(2) pos1(3) pos1(4)])
            hTitle = legendTitle (h, 'Sampling Efficiency');
			
			line([nfreq ,nfreq],[.05,0]);
 		
		else % (ncol ==1)
				
                h = legend([num2str(e),'%']);
                get(h,'Position');
                pos1 =  get(h,'Position');
                set(h,'Position', [0.97*pos1(1) 0.93*pos1(2) pos1(3) pos1(4)])
                hTitle = legendTitle (h, 'Sampling Efficiency');               
				line([nfreq ,nfreq],[.05,0]);
        line([83 ,83],[.05,0]);

 			
	end % ncol>1

   line = ['Value at 83: ' num2str(sfrValAt83, "%1.3f")];
   text(.80*83,+.08,line),
   text(.95*nfreq,+.08,'Half-sampling'),
 
 hold off;
 axis([0 350,0,max(max(mtf))]);
 %axis([0 freq(round(0.75*nn2out)),0,max(max(mtf))]);

 drawnow
 grid on 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%
defname = [pathname,'*.*'];
   [outfile,outpath]=uiputfile(defname,'File name to save results (.xls will be added)');
   foutfile=[outpath,outfile];

   if size(foutfile)==[1,2],
      if foutfile==[0,0],
         disp('Saving results: Cancelled')
      end;
   else
       
    nn = find(foutfile=='.');
    if isempty(nn) ==1;
       foutfile=[foutfile,'.xls'];
    end
       
    results2(dat, filename, roi, oename, summary, foutfile);
   end;

% Clean up

% Reset text interpretation
  set(0, 'DefaultTextInterpreter', 'tex')
  path(defpath);           % Restore path to previous list
  cd(home);                % Return to working directory
 
disp(' * sfrmat3 finished  *');

return;

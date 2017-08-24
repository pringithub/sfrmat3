function [del] = inbox1(defdel);
% Dialog box for input of data sampling for SFR calculation
%  Usage: [del] = inbox1(defdel)
%  del = sampling interval in mm
% Calls inputdlg function, supplied with the toolbox
% matlab/uitools. If you have problems, check which version of
% inputdlg.m (or corresponding inputdlg.p) is being called. You need
% version 1.48 or later.
%             
% 22 Aug. 2008
% Copyright (c) Peter D. Burns 2008

if nargin == 0;
    del2 = '1';
    dpi2 = '-';
elseif defdel < 1;
     del2 = num2str(defdel);
     dpi = round(25.4/defdel);
     dpi2 = num2str(dpi);
else del2 = num2str(25.4/defdel);
     dpi2 = num2str(defdel);
end

title=  '  Data sampling: edit one value ';
prompt={'Data sampling in pixels/inch (ppi)',' or mm' };
   def={dpi2, del2};
lineNo=[1];
AddOpts.Resize='on';
AddOpts.WindowStyle='normal';
AddOpts.Interpreter='tex';
answer=inputdlg(prompt, title, lineNo, def);

if isempty(answer) == 1;
 del = 0;
 return
end

sflag = 0;
%test if first answer has changed
if length(answer{1}) ~= length(dpi2);
 sflag = 1;
 else
   if answer{1} ~= dpi2;
     sflag = 1;
   end
end;

if sflag==0
  del =  str2num(char(answer{2}));  
 else;    
  del =  str2num(char(answer{1}));
  del = 25.4/del;
end; 
del = abs(del);

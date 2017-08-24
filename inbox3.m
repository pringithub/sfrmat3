function [del, weights] = inbox3(del, weights)   %GUI for sampling and lum weights
% Dialog box for input of data sampling and weights for red, green 
% and blue signals for luminance calculation for SFR calculation
%  Usage: [del, weights] = inbox3(def_del, def_weights)
%   def_del     = (optional) default sampling interval in mm or dpi
%                 if not used, def_del = 1
%   def_weights = (optional) default 3x1 array of luminance weights  for R, G, B
%                 if not used, def_weights = [0.3  0.6  0.1]
%
%   del         = output sampling interval in mm
%   weights     = output 3x1 array of luminance weights  for R, G, B
%            
% Calls inputdlg function, supplied with the toolbox
% matlab/uitools. If you have problems, check which version of
% inputdlg.m (or corresponding inputdlg.p) is being called. You need
% version 1.48 or later.
% 24 Sept. 2008
%
% Copyright (c) 2008 Peter D. Burns

fmt = '%5.3f';    %  2 decimal digits  

if nargin < 1
 del = 1;
end
if nargin < 2
%  weights =  [0.3
%             0.6
%             0.1];
 weights =[0.213
             0.715
             0.072];
end

if del > 1;
 def={num2str(del), '-', [num2str(weights(1,:), fmt)
                          num2str(weights(2,:), fmt)
                          num2str(weights(3,:), fmt)]};
else
 def={'-', num2str(del), [num2str(weights(1,:), fmt)
                          num2str(weights(2,:), fmt)
                          num2str(weights(3,:), fmt)]};

end

title='  Data sampling & weights ';
prompt={'Data sampling in dpi',' or mm', 'Luminance weights  for R, G, B' };
%   def={'-', '1', ['0.3'
%                     '0.6'
%                     '0.1']};
lineNo=[1, 1, 3]';
AddOpts.Resize='on';
AddOpts.WindowStyle='normal';
AddOpts.Interpreter='tex';
answer=inputdlg(prompt, title, lineNo, def);

% Catch for CANCEL button
if isempty(answer) == 1;
 del = 1;
 weights =  [0.213 0.715 0.072];  %%%
 return
end


sflag = 0;
if length(char(answer(1)))~=1;
 sflag = 1;
 elseif char(answer(1))~='-';
 sflag = 1;
end;
if sflag==0
  del =  str2num(char(answer(2)));  
 else;
  del =  str2num(char(answer(1)));
  del = 25.4/del;
end; 

weights = str2num(char(answer(3)))';   %%

if sum(weights) > 1.0;
 beep
 disp(' ***  WARNING: Sum of Luminance weights is greater than 1  ***');
end;
del = abs(del);

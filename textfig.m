function [] = textfig(dat,h,posi);
%  [] = textfig(dat,h) puts text in figure
%dat = cell array
%
%  Author: Peter Burns, 1 Oct. 2008
%  Copyright (c) 2007 Peter D. Burns

if nargin < 3
    posi = 0;
end
dely = 0;
% h = figure('Visible', 'on', 'Color', [1 1 1]);

 set(h, 'DefaultTextInterpreter', 'none');
if posi == 0;
 title(dat{1}), axis off
else
g1 =text(0,1,dat{1});
axis off
dely = dely+0.08;
end
for ii = 2:length(dat)
    if isempty(dat{ii})~=1
      g1 =text(0,1-dely,dat{ii});
      dely = dely+0.08;
    end
end


function [h0] = splash(name, version, when, posi);
% info:  displays simple splash window announcing program name, version
%        and copyright information
%
% Usage:  
% [h0] = splash(name, version, when, posi);
%  arguments:
% 	name = string for name used in window title
% 	version = string for version, e.g, '1.0' appended to name
% 	when = string for date, e.g, '09-Apr-1999'
% 	posi = vector for x, y location of lower left corner of window
%              in screen pixel units (optional)
% 
% Author: Peter Burns, 1 Oct. 2008
% Copyright (c) 2007 Peter D. Burns

if nargin<4;
screen = get(0, 'ScreenSize');
 posi(1) = (screen(3)/2)-175;
% posi(2) = 0.075*screen(4);
posi(2) = 0.5*screen(4)+150;
 posi(3) = 395;
 posi(4) = 65;
end;

if nargin<3;
 when= datestr(now,1);
end;

if nargin<2;
 version = '1.0 ';
end;

if nargin<1;
 name = 'sfrmat';
end;

com = char(computer);
 if com(1:3) == 'PCW';
     com = 'MS-Windows';
 elseif com(1:3) == 'MAC';
     com = 'Macintosh';
 elseif com(1:3) == 'SUN';
     com = 'Sun SPARC';
 elseif com(1:3) == 'SOL';
     com = 'Solaris 2';
 elseif com(1:3) == 'SGI';
     com = 'Silicon Graphics';
 end;

message = [' '];

disp(['            ** ',name,': version ', version,' (',when,') **']); 
disp(['       ',message]);
disp(['                         on ', com]);
name =[name];


%info = ['version ',version,' ',when];

bkcolor = [.25 .25 .5];
txtcolor = [1 1 1];
myname = 'sfrmat';

	h0 = figure('Units','pixels',...
	'Position', posi,...
	'Menubar','none',...
	'Name',[name,' ',version],...
	'NumberTitle','off',...
	'WindowStyle','normal',...
	'Resize','off',...
	'Color', bkcolor,...
	'Tag','new_figure'...
	);

	h1 = uicontrol('Style','text',...
	'Tag','sfrmat: slanted edge analysis',...
	'Units','normalized',...
	'Position',[ 0.2  0.6  0.6  0.3],...
	'FontSize',12,...
	'FontWeight','bold',...
	'String','Slanted Edge Analysis',...
	'BackgroundColor',bkcolor,...
	'ForegroundColor', txtcolor,...
	'Parent',h0...
	);

	h1 = uicontrol('Style','text',...
	'Tag', message,...
	'Units','normalized',...
	'Position',[ 0.06  0.20  0.85  0.25],...
	'FontSize',12,...
	'FontWeight','normal',...
	'String',message,...
	'BackgroundColor', bkcolor,...
	'ForegroundColor', txtcolor,...
	'Parent',h0...
	);


function [eff, freqval, sfrval] = sampeff(dat, val, del, fflag, pflag)
%[eff, freqval, sfrval] = sampeff(dat, val, del, fflag, pflag) Sampling efficiency from SFR
% First clossing method with local interpolation
%dat   = SFR data n x 2, n x 4 or n x 5 array. First col. is frequency
%val = (1 x n) vector of SFR threshold values, e.g. [0.1, 0.5]
%del = sampling interval in mm (default = 1 pixel)
%fflag = 1 filter [1 1 1 ] filtr applied to sfr
%      = 0 (default) no filtering
%pflag = 0 (default) plot results
%      = 1 no plots
%eff = efficiency based on first value  - val(1)
%freqval = frequency values corresponding to val
%sfrval = sfr values for freqval
%Needs: findfreq
%
% Author: Peter Burns, 1 Oct. 2008
% Copyright (c) 2007 Peter D. Burns
%
if nargin < 4;
    pflag = 0;
    fflag =0;
end
if nargin < 3;
    del = 1;
end
if nargin < 2;
    val = 0.1;
end

%Find value of val to be used for sampling efficiency
mmin = min(val);
mindex = find(val == min(val));
if mmin > 0.1
    disp( ['Warning: sampling efficiency is based on SFR = ',num2str(mmin)] )
end 

delf = dat(2,1)+1e-6;
hs   = 0.5/del;
x    = find(dat(:,1) > 1.1*hs);

if isempty(x) == 1;
   imax = length(dat(:,1));
   imaxx = imax;
else
   xx = find(dat(:,1) > hs-delf);
% if isempty(xx) == 1;
%     disp(' Missing SFR data, frequency up to half-sampling needed')
%     efficiency = 0;
%     freqval = 0;
%     sfrval = 0;
%     return
% end
    imax = x(1);
    imaxx = xx(1);
    dat = dat(1: imax, :);
end

[n, m, nc] = size(dat);
nc = m - 1;
%imax = n;
nval = length(val);
eff = zeros(1, nc);
freqval = zeros(nval, nc);
sfrval = zeros(nval, nc);

for v = 1: nval;
 [freqval(v, :), sfrval(v, :)] = findfreq(dat, val(v), imax, fflag);
end

%Efficiency computed only for lowest value of SFR requested
 for c = 1:nc
  eff(1,c) = min(round(100*freqval(mindex, c)/dat(imaxx,1)), 100);
 end

if pflag ~= 0;
    
for c =1:nc
 se = ['Sampling efficiency ',num2str(eff(1,c)),'%'];
  
 disp(['  ',se])
 figure,
	plot(dat(:,1),dat(:,c+1)),
	hold on
    for v = 1:nval
     plot(freqval(v, c),sfrval(v, c),'r*','Markersize', 12),
    end
     plot(dat(:,1),mmin*ones(length(dat(:,1))),'b--'),

     xlabel('Frequency'),
     ylabel('SFR'),
     text(0.8*dat(end,1),0.95, ['SE = ',num2str(eff(1,c)),'%'])
     axis([0, dat(imax, 1), 0, 1]),
     hold off
end

end     
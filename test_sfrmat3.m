% Test sfrmat3 and compare with sfrmat2
% Author: Peter Burns, 24 July 2009

[status,in] = imageread;
in2 = getroi(in);
in2 = double(in2);

% case 1: Posted sfrmat2 code
[status, dat1, fitme1, esf1] = sfrmat2(4, in2, 1);
% case 2: sfrmat3 with same lum weighting
[status, dat2, e2, fitme, esf2, nbin, del2] = sfrmat3(1, 1, [.3, .6, .1], in2);
% case 3: sfrmat3 executed in sfrmat2 mode. Should give same results as sfrmat2
[status, dat3, e3, fitme3, esf3, nbin, del3] = sfrmat3('sfrmat2', 1, [.3, .6, .1], in2);
%case 4: Used selection of ROI. Should give same results as case 2 above
[status, dat4, e4, fitme4, esf4, nbin, del4] = sfrmat3(0);
%case 5: Used used OECF transformation. If the identiy LUT is used, hould give same
%results as case 2 above
[f,p] = uigetfile('*.*','Select oecf file');
[status, dat5, e5, fitme, esf5, nbin, del5] = sfrmat3(1, 1, [.3, .6, .1], in2,[p,f]);

dat1 = dat1(1:length(dat3),:);
sfrcomp=isequal(dat3,dat1);
if sfrcomp == 1;
    disp('*  sfrmat3 passed ''sfrmat2'' mode test  *');
else beep
    disp('*  sfrmat3 FAILED ''sfrmat2'' mode test  *');
end
sfrcomp2=isequal(dat2,dat4);

if sfrcomp2 == 1;
    disp('*  sfrmat3 passed ROI selection mode test  *');
else beep
    disp('*  sfrmat3 FAILED ROI selection mode test  *');
end

sfrcomp2=isequal(dat2,dat5);
if sfrcomp2 == 1;
    disp('*  sfrmat3 passed OECF test  *');
else beep
    disp('*  sfrmat3 FAILED OECF test  *');
end


plot(dat1(:,1), dat1(:,2)), hold on
plot(dat3(:,1), dat3(:,2),'--r'), 
plot(dat2(:,1), dat2(:,2),'k'), 
plot(dat4(:,1), dat4(:,2),'--g'), hold off
legend( 'sfrmat2','sfrmat2 mode','io=1','io=0');
axis tight
[e2, e3, e4, e5]


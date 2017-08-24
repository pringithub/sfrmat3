% sfr_lab
% Peter Burns, 14 April 2015

% 1. Select four image files, captured at several resolution settings
% (pixels/inch)
[f1,p1] = uigetfile('*.*','Select 4 image file','MultiSelect', 'on');
nd = length(f1);
if ischar(f1)
    nd =1;
    temp = f1;
    clear f1;
    f1{1}=temp;
end

% Allocate for pixels/inch setting for each file
dx = zeros(1,nd);

sym = [{'r'} {'g'} {'b'} {'k'} {'--r'} {'--g'} {'--b'} {':k'}];

% 2. Loop for region selection, SFR computing and plotting
for ii = 1:nd
    % pull image resolution from header
    info = imfinfo([p1,f1{ii}]);
    dx(ii) = info.XResolution;
    % read image array
    [~, dat] = imageread([p1,f1{ii}]);
    d1 = getroi(dat,'Select an edge');

    % Compute SFR
    [status, dat1] = sfrmat3(1, dx(ii), [.3 .6 .1], d1);

     figure(1)
     plot(dat1(:,1), dat1(:,5),sym{ii}), hold on
     %pause
end
hold off

xlabel('Frequency, cy/mm')
ylabel('SFR')
legend(num2str(dx'))
title('Scanner SFR for several sampling settings')
% edit to change plotted x,y axis limits
axis([0 15 0 1])
%
 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 3. Compare SFR results for each color record for a single file
[f2,p2] = uigetfile('*.*','Select 4 image file','MultiSelect', 'off');

[~, dat2] = imageread([p2,f2]);
[d2,c1] = getroi(dat2,'Select an edge');

% We will plot results versus cycles/pixel, so dx = 1 pixel
dx = 1;

% Compute SFR
[status, dat2] = sfrmat3(1, 1, [.3 .6 .1], d2);

figure(2)
plot(dat2(:,1), dat2(:,2),'r'), hold on
plot(dat2(:,1), dat2(:,3),'g')
plot(dat2(:,1), dat2(:,4),'b')
hold off
axis([0 0.5 0 1])
xlabel('Frequency, cy/pixel')
ylabel('SFR')
legend('r', 'g', 'b')



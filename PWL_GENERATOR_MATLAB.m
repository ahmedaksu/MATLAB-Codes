clear all; clc; close all;
%This code converts a sinusoidal signal to N-bit digital data. The digital
%data saved in PWL format as text files.


f= 10e3;  % Signal Frequency
ts = 1/f; % Signal Period
A = 3;    % Digital Voltage Level
N = 12;    % Number of Bits
periodLength = 128; % Number of points per period
numberOfPeriods = 4;  

step = ts/periodLength;
t = 0 : step : numberOfPeriods*ts - step;
signal = round((2^(N-1)- (1/2))*(sin(2*pi*f*t)+1));
binaryData = dec2bin(signal, N);
bits = zeros(size(binaryData));

for i=1:N

    bits(:,i) = A*str2num(binaryData(:,i));

end


time = 0 : step/2 : (periodLength*numberOfPeriods)*step;
time(4:2:end) = time(3:2:end-1) + ts/1e5;
time(2) = [];
data = zeros(2*length(bits), width(bits));
data(1:2:end,:) = bits;
data(2:2:end,:) = bits;

data(:,2:(N+1)) = data;
data(:,1) = time;

figure(1);
plot(t,signal); grid on;
title("Signal");


figure(2);
for i = 2:(N+1)
subplot(N,1,i-1);
plot(data(:,1),data(:,i)); grid on;
tt = sprintf("B%i",(N+1)-i);
title(tt);

end

tt = sprintf("MSB: B%i LSB: B0",(N-1));

sgtitle(tt);
for i=0:(N-1)
    fileName = sprintf("b%dpwl.txt",i);
    writematrix(data(:,[1 (N+1)-i]),fileName,'Delimiter',' ');
end

function [ ap, bq ] = sbARMAModel( data, p, q )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

L = p+q;
if (L > (length(data) - 1))
    error('Not enough data for that order ARMA model.');
end

rx = autocorr(data, length(data)-1); % calculating the autocorrelation values for different 'k's
rxmat = zeros(p); % the loop below builds the autocorrelation matrix on the LHS of MYWE.
for k = 1:p
    for l = 1:p;
        if (q+k-l) >= 0
            rxmat(k, l) = rx(q+k-l+1);
        else
            rxmat(k, l) = rx(-(q+k-l)+1);
        end
    end
end

rxvect = rx(q+2:q+p+1)';% the vector at the RHS of Modified Yule Walker equation

ap = (-rxvect)/rxmat; % the a(p) coefficients from index 1 to p.
ap1 = 1;
ap = cat(2, ap1, ap); % we concatenate a(0)=1 to the a(p) vector so that we can use the vector for fft
dataLength = length(data);
xz = fft(data, dataLength)';% the fft of x(n) i.e. data
apz = fft(ap, dataLength); % the fft of the a(p) coefficients

% size(xz)
% size(apz)
yz = xz.*apz; % the fft of y(n) = x(n) passed through AR filter of order 'p'.
yn = ifft(yz); % the y(n)

% y is the new data
ry = autocorr(yn, q+1);
z = tf('z');
BzBzinv = ry(1);
for k=1:q+1
    BzBzinv = BzBzinv + (2*ry(k+1)*(1/(z^k)));
end

[roots] = zpkdata(BzBzinv);
rootArray = roots{1};
indices = find(abs(rootArray) < 1);
newRootArray = zeros(1, length(indices));
for k = 1:length(indices)
    newRootArray = rootArray(indices(k));
end

s=tf('s');   % since the tf object can't be a string we have to take 's' as 'z^-1'

Bz = 1;
for k = 1:length(newRootArray)
    Bz = Bz * (1-(newRootArray(k)*s));
end
[bznum] = tfdata(Bz);
bznum = bznum{1};
bznum = flipdim(bznum, 2);
bqdash = zeros(1, q+1);
for k=1:length(bznum)
    bqdash = bznum(k);
end
g = ry(1);
bqdashSq = bqdash.^2;
g = g/sum(bqdashSq);
bq = g.*bqdash;

res = 100000; % some kind of frequency resolution
w = 0:res;
w = w*(2*pi/res);
Py = 0;
for k=1:length(bq)
    Py = Py + (bq(k) * exp(-1i .* w .* (k-1)));
end
Py = abs(Py).^2;

Px = 0;
for k = 1:length(ap)
    Px = Px + (ap(k) * exp(-1i .* w .* (k-1)));
end
Px = abs(Px).^2;

Pw = Py./Px;
figure, plot(w, Pw);
title(['Power spectrum using ARMA model of order (', num2str(p), ', ', num2str(q), ')']);
xlabel('Frequency (rad/s)');
ylabel('Magnitude (unitless)');



end


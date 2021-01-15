fpass = 100;
fstop = 1000;
rStop = 10;
[n, Wp] = cheb2ord(2*pi*fpass,2*pi*fstop,0.3,rStop,'s')
[B1, A1] = cheby2(n,rStop,fstop*2*pi,'low','s')

freqs(B1,A1);
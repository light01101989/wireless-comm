%% ECE 5680 - Wireless Communication
%% HW4: Ques 3_2
%% Author: Arjun Jauhari
%% Email/Netid: aj526
%% Date: 10/24/2015

function HW4_Q3_3()
% Plot:
% Generate a plot with MAP/ML/Perfect channel estimates

SNR_db = 0:30;  % Sweeping over SNR of 0dB to 30dB

%% MAP channel estimate
[SER_map, legendmap] = HW4_Q3_1(1:2,0);

%% ML channel estimate
[SER_ml, legendml] = HW4_Q3_2(1:2,0);

%% Perfect channel estimate
[SER_perf, legendperf] = HW3_Q5(1:2,0);

%% Plot
figure(1)
semilogy(SNR_db,SER_map,'o-',SNR_db,SER_ml,'.-',SNR_db,SER_perf,'*-');
grid on
axis([min(SNR_db) max(SNR_db) 1e-6 1])
xlabel('signal-to-noise ratio (SNR) [dB]')
ylabel('symbol error rate (SER)')
title('BPSK - SIMO: SER with various chEst method')
legendtext =[legendmap; legendml; legendperf];
legend(legendtext)

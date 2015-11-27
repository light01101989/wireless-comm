%% ECE 5680 - Wireless Communication
%% HW3: Ques 6_3
%% Author: Arjun Jauhari
%% Email/Netid: aj526
%% Date: 09/24/2015
%% Monte-Carlo simulation for estimating SER(Symbol Error rate) of QPSK in Fading channel

function HW3_Q6_3()

SNR_db = 0:30;  % Sweeping over SNR of -10dB to 20dB

%% Call Q6
[SER_simple legendsim] = HW3_Q6([1:4]);

% Call Q6_2
[SER_bf legendbf] = HW3_Q6_2([1:4]);

%% Plotting
close all;
figure(1)
semilogy(SNR_db,SER_simple,'o-',SNR_db,SER_bf,'.-')
grid on
axis([min(SNR_db) max(SNR_db) 1e-6 1])
xlabel('signal-to-noise ratio (SNR) [dB]')
ylabel('symbol error rate (SER)')
title('BPSK - MISO: SER Simulation')
legendtext =[legendsim; legendbf];
legend(legendtext)

%% ECE 5680 - Wireless Communication
%% HW3: Ques 5_3
%% Author: Arjun Jauhari
%% Email/Netid: aj526
%% Date: 09/24/2015
%% Monte-Carlo simulation for estimating SER(Symbol Error rate) of QPSK in Fading channel

%clear all;close all;
function HW3_Q5_3()

SNR_db = 0:30;  % Sweeping over SNR of -10dB to 20dB

%% Call Q5
[SER_MRC legendmrc] = HW3_Q5([1:4]);

% Call Q5_2
[SER_selection legendsel] = HW3_Q5_2([1:4]);

%% Plotting
close all;
figure(1)
semilogy(SNR_db,SER_MRC,'o-',SNR_db,SER_selection,'.-')
grid on
axis([min(SNR_db) max(SNR_db) 1e-6 1])
xlabel('signal-to-noise ratio (SNR) [dB]')
ylabel('symbol error rate (SER)')
title('BPSK - SIMO: SER Simulation')
legendtext =[legendmrc; legendsel];
legend(legendtext)

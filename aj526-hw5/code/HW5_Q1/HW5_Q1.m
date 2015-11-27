%% ECE 5680 - Wireless Communication
%% HW5: Ques 1_1
%% Author: Arjun Jauhari
%% Email/Netid: aj526
%% Date: 11/5/2015
%% OFDM simulation full

function [] = HW5_Q1()

SNR_db = 0:30;  % Sweeping over SNR of -10dB to 20dB

[BER1,legend1]=HW5_Q1_1;
[BER2,legend2]=HW5_Q1_2;
[BER3,legend3]=HW5_Q1_3;

%% Plot
figure(1)
semilogy(SNR_db,BER1,'o-',SNR_db,BER2,'.-',SNR_db,BER3,'*-');
grid on
axis([min(SNR_db) max(SNR_db) 1e-6 1])
xlabel('signal-to-noise ratio (SNR) [dB]')
ylabel('symbol error rate (SER)')
title('QPSK - OFDM:')
legend(legend1,legend2,legend3)
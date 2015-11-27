%% ECE 5680 - Wireless Communication
%% HW2: Ques 4_3
%% Author: Arjun Jauhari
%% Email/Netid: aj526
%% Date: 09/24/2015
%% Monte-Carlo simulation for estimating SER(Symbol Error rate) of QPSK in Fading channel

%clear all;close all;
function HW2_Q4_3()

SNR_db = -10:20;  % Sweeping over SNR of -10dB to 20dB

%% Call Q4_2
SER_fading_qpsk = HW2_Q4_2();

% Call Q3_2
SER= HW2_Q3();

SER_awgn_qpsk = SER(1,:);
SER_awgn_bpsk = SER(2,:);

%% Plotting
close all;
figure(1)
semilogy(SNR_db,SER_fading_qpsk,'bo-',SNR_db,SER_awgn_qpsk,'ko-')
grid on
axis([-10 20 1e-6 1])
xlabel('signal-to-noise ratio (SNR) [dB]')
ylabel('symbol error rate (SER)')
legend('QPSK FADING SER', 'QPSK AWGN SER')


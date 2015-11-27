%% ECE 5680 - Wireless Communication
%% HW6: Ques 1_1
%% Author: Arjun Jauhari
%% Email/Netid: aj526
%% Date: 11/24/2015
%% Capacity of SISO AWGN channel

function [C_awgn,legendtext] = HW6_Q1_1(SNR_db,splot)
%description:
%
% Input:
%
% Output:
%
% Plot:
%

if ~exist('splot','var')
    splot = 0;
end

if ~exist('SNR_db','var')
    SNR_db = -10:20;  % Sweeping over SNR of -10dB to 20dB
end
SNR = 10.^(SNR_db/10);

C_awgn = log2(1+SNR);

legendtext = strcat('AWGN Capacity');
if (splot)
    plot(SNR_db,C_awgn,'bo-');
    grid on
    title('AWGN channel capacity')
    xlabel('signal-to-noise ratio (SNR) [dB]')
    ylabel('Channel Capacity [bits/s/Hz]')
    legend(legendtext)
end

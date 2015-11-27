%% ECE 5680 - Wireless Communication
%% HW6: Ques 1
%% Author: Arjun Jauhari
%% Email/Netid: aj526
%% Date: 11/24/2015

function HW6_Q1()
%description:
%
% Input:
%
% Output:
%
% Plot:
%
SNR_db = -10:30;

[C_awgn,legendtext1] = HW6_Q1_1(SNR_db,0);

[I_xy,legendtext2] = HW6_Q1_4('all',SNR_db,0);

plot(SNR_db,C_awgn,'o-');
hold all
[r,c] = size(I_xy);
for p=1:r
    plot(SNR_db,I_xy(p,:),'*-')
end
grid on
xlabel('signal-to-noise ratio (SNR) [dB]')
ylabel('Rate [bits/s/Hz]')
title('SISO AWGN channel capacity')
legend([legendtext1,legendtext2]);

%% ECE 5680 - Wireless Communication
%% HW1: Ques 3
%% Author: Arjun Jauhari
%% Email/Netid: aj526
%% Date: 09/08/2015
%% Plot of time-frequency correlation function

%%R_h IS A FUNCTION OF d_f defined as R_H = sigma0^2(1 + e^(-j2pi*d_f*tau0))
%assuming sigma0 and tau0 to be 1
clear;close all;
sigma0 = 1; %% Taking sigma0 = 1
tau0 = [1 5]; %% Sweeping tau0
d_f = [0:1000]*0.01; %% Sweeping d_f(delta f) from 0 to 10
R_H(length(tau0),length(d_f)) = 0;
for k = 1:length(tau0)
  R_H(k,:) = sigma0*(1 + exp(-1i*2*pi*d_f*tau0(1,k)));
end

%% Plotting |R_H|
figure(1)
plot(d_f, abs(R_H(1,:)), 'b-')
axis([0 10 -1 3])
xlabel('delta_f')
ylabel('|R_H|')
hold on
plot(d_f, abs(R_H(2,:)), 'k-')
legend('For tau0 = 1', 'For tau0 = 5')


%%experiments
%hold on
%plot(d_f, R_H(2,:), 'r-')
%plot(d_f, R_H(3,:), 'k-')
%mesh(d_f, tau0, abs(R_H))

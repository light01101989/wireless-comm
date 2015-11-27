%% ECE 5680 - Wireless Communication
%% HW1: Ques 4
%% Author: Arjun Jauhari
%% Email/Netid: aj526
%% Date: 09/08/2015
%% Monte-Carlo simulation for estimating SER(Symbol Error rate)

clear all;close all;
SNR_db = -10:20;  % Sweeping over SNR of -10dB to 20dB
SNR = 10.^(SNR_db/10);
sd = sqrt(1./SNR);  % Standard Deviation
var = sd.^2;        % Variance

%% STEP 1 OF MONTE CARLO SIMULATION
%% Generating transmit data
in_bits = randi([0 1], 1, 10000);
x(1,length(in_bits)) = 0;
for k = 1:length(in_bits)
  if in_bits(1,k) == 0
    x(1,k) = -1;
  else
    x(1,k) = 1;
  end
end

%%STEP 2 OF M-C SIMULATION
% Generating RANDOM NOISE WITH MEAN 0 AND VARIANCE VAR == sd^2
noise(length(sd),length(in_bits)) = 0;
x_hat(length(sd),length(in_bits)) = 0;
I_mc(length(sd),length(in_bits)) = 0;
SER(1,length(sd)) = 0;
for k = 1:length(sd)
  %%STEP 2 OF M-C SIMULATION
  % Generating RANDOM NOISE WITH MEAN 0 AND VARIANCE VAR == sd^2
  noise(k,:) = sd(1,k)*randn(1,10000);

  %%STEP 3 OF M-C SIMULATION
  %% RECEIVED SIGNAL ACCORDING TO RELATION y = x + n
  y(k,:) = x + noise(k,:);

  %% STEP 4 OF M-C SIMULATION
  %% Using the detector threshold to do detection and get x_hat
  decision_bound = 0;
    for r = 1:length(y)
      if y(k,r) < decision_bound
        x_hat(k,r) = -1;
      else
        x_hat(k,r) = 1;
      end
    end

  %% STEP 5 OF M-C SIMULATION
  %% Evaluate I
  for r = 1:length(x_hat)
    if x_hat(k,r) == x(1,r)
      I_mc(k,r) = 0; %no error
    else
      I_mc(k,r) = 1; %error occured
    end
  end

  %%CALCULATE SER
  SER(1,k) = mean(I_mc(k,:));
end

%%PLOTTING
figure(1)
semilogy(SNR_db,SER,'bo-')
grid on
axis([-10 20 1e-6 1])
xlabel('signal-to-noise ratio (SNR) [dB]')
ylabel('symbol error rate (SER)')
legend('simulated SER')

hold on

%%calculation SER from analytical equation
SER_calc = 0.5*erfc(sqrt(SNR./2));
semilogy(SNR_db,SER_calc,'ro-')
legend('simulated SER', 'calculated SER')
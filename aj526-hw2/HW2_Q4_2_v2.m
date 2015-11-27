%% ECE 5680 - Wireless Communication
%% HW2: Ques 4_2
%% Author: Arjun Jauhari
%% Email/Netid: aj526
%% Date: 09/24/2015
%% Monte-Carlo simulation for estimating SER(Symbol Error rate) of QPSK in Fading channel, easier unrealistic way(y=|h|x+n)

%clear all;close all;
function HW2_Q4_2_v2()
SNR_db = -10:20;  % Sweeping over SNR of -10dB to 20dB
SNR = 10.^(SNR_db/10);
sd = sqrt(2./SNR);  % AJ:check % Standard Deviation
var = sd.^2;        % Variance

%% STEP 1 OF MONTE CARLO SIMULATION
%% Generating transmit data
S_qpsk = [1+1i 1-1i -1+1i -1-1i];    %%QPSK
in_bits = randi([1 4], 1, 10000);
x_qpsk(1,length(in_bits)) = 0;
for k = 1:length(in_bits)
    x_qpsk(1,k) = S_qpsk(in_bits(k));
end


noise(length(sd),length(in_bits)) = 0;
x_hat(length(sd),length(in_bits)) = 0;
I_mc(length(sd),length(in_bits)) = 0;
SER(1,length(sd)) = 0;
y(length(sd),length(in_bits)) = 0;
h_channel(length(sd),length(in_bits)) = 0;

for k = 1:length(sd)
  %%STEP 2 OF M-C SIMULATION
  % Generating RANDOM NOISE WITH MEAN 0 AND VARIANCE VAR == sd^2
  %noise(k,:) = sqrt(2)*sd(1,k)*randn(1,10000) + i*sqrt(2)*sd(1,k)*randn(1,10000);
  noise(k,:) = (1/sqrt(2))*sd(1,k)*randn(1,10000) + 1i*(1/sqrt(2))*sd(1,k)*randn(1,10000);
  %noise(k,:) = sd(1,k)*randn(1,10000) + i*sd(1,k)*randn(1,10000);
  h_channel(k,:) = (1/sqrt(2))*randn(1,10000) + 1i*(1/sqrt(2))*randn(1,10000);

  %%STEP 3 OF M-C SIMULATION
  %% RECEIVED SIGNAL ACCORDING TO RELATION y = x + n
  y(k,:) = abs(h_channel(k,:)).*x_qpsk + noise(k,:);

  %% STEP 4 OF M-C SIMULATION
  %% Using the detector threshold to do detection and get x_hat
  decision_bound = 0;

    for r = 1:length(y)
      if real(y(k,r)) < decision_bound
          if imag(y(k,r)) < decision_bound
              x_hat(k,r) = -1-1i;
          else
              x_hat(k,r) = -1+1i;
          end
      else
          if imag(y(k,r)) < decision_bound
              x_hat(k,r) = 1-1i;
          else
              x_hat(k,r) = 1+1i;
          end
      end
    end

  %% STEP 5 OF M-C SIMULATION
  %% Evaluate I
  for r = 1:length(x_hat)
    if x_hat(k,r) == x_qpsk(1,r)
      I_mc(k,r) = 0; %no error
    else
      I_mc(k,r) = 1; %error occured
    end
  end

  %%CALCULATE SER
  SER(1,k) = mean(I_mc(k,:));
  
end


%figure(1)
%plot(abs(y(1,:)))
%plot(real(y(30,:)),imag(y(30,:)),'o')
%%PLOTTING
figure(1)
semilogy(SNR_db,SER,'ko-')
grid on
axis([-10 20 1e-6 1])
xlabel('signal-to-noise ratio (SNR) [dB]')
ylabel('symbol error rate (SER)')
%legend('QPSK SER', 'BPSK SER')

hold on

%%calculation SER from analytical equation
%SER_calc = 0.5*erfc(sqrt(SNR./2));
%SER_calc = erfc(sqrt(SNR./2));
SER_calc = 2*qfunc(sqrt(SNR)) - qfunc(sqrt(SNR)).^2;
semilogy(SNR_db,SER_calc,'ro-')
legend('QPSK Fading SER', 'calculated AWGN QPSK SER')

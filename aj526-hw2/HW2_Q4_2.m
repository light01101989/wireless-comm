%% ECE 5680 - Wireless Communication
%% HW2: Ques 4_2
%% Author: Arjun Jauhari
%% Email/Netid: aj526
%% Date: 09/24/2015
%% SISO: Monte-Carlo simulation for estimating SER(Symbol Error rate) of QPSK in Fading channel(y=hx+n) decision on(dot(h/|h|,y))

%clear all;close all;
function SER = HW2_Q4_2()
SNR_db = -10:20;  % Sweeping over SNR of -10dB to 20dB
SNR = 10.^(SNR_db/10);
sd = sqrt(2./SNR);  % Standard Deviation
var = sd.^2;        % Variance

% Number of Monte carlo iteration
T = 10000;

%% STEP 1 OF MONTE CARLO SIMULATION
%% Generating transmit data
S_qpsk = [1+1i 1-1i -1+1i -1-1i];    %%QPSK
x_qpsk = S_qpsk(randi([1 4], 1, T));

noise = zeros(1,T);
h_channel = zeros(1,T);
y = zeros(1,T);
y_new = zeros(1,T);
x_hat = zeros(1,T);
SER(1,length(sd)) = 0;

for k = 1:length(sd)
  %%STEP 2 OF M-C SIMULATION
  % Generating COMPLEX RANDOM NOISE WITH MEAN 0 AND VARIANCE VAR = N0
  noise = (1/sqrt(2))*sd(1,k)*randn(1,T) + 1i*(1/sqrt(2))*sd(1,k)*randn(1,T);

  % Generating COMPLEX RANDOM CHANNEL MODEL WITH MEAN 0 AND VARIANCE VAR = 1
  h_channel = (1/sqrt(2))*randn(1,T) + 1i*(1/sqrt(2))*randn(1,T);

  %%STEP 3 OF M-C SIMULATION
  %% RECEIVED SIGNAL ACCORDING TO RELATION y = hx + n
  y = h_channel.*x_qpsk + noise;

  %% STEP 4 OF M-C SIMULATION
  %% Using the detector threshold to do detection and get x_hat
  %% On receiver we do (h/|h|) dot with y, projection, Matched Filter, MRC
  %%y_new = conj(h_channel./abs(h_channel)).*y;
  y_new = dot(h_channel./norm(h_channel,2,'columns'),y,1);    %% dot product considering cols as vectors

  x_hat = sign(real(y_new)) + 1i*sign(imag(y_new));
        
  %% STEP 5 OF M-C SIMULATION
  %% Evaluate I
  SER(1,k) = mean(x_hat~=x_qpsk);
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
legend('QPSK FADING SER')

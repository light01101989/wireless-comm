%% ECE 5680 - Wireless Communication
%% HW2: Ques 4_2
%% Author: Arjun Jauhari
%% Email/Netid: aj526
%% Date: 09/24/2015
%% MC simulation for estimating SER of BPSK in single tap Fading channel(y=hx+n) with SIMO config(Selection Combining)

function [SER legendtext] = HW3_Q5_2(L)
% Find the SER for SIMO case with L channel outputs,
% SELECTION COMBINING(decoding done by processing the best channel(antenna) out of L antenna)
%
% Input:
% L = Row vector with each value tells number of receive antennaes
% eg. L = [1 3] or [1:4]
%
% Output:
% SER = A LxNumOfSnrPoints matrix with each row corresponds to particular L outputs
%
% Plot:
% A plot corresponding to each value in vector L

SNR_db = 0:30;  % Sweeping over SNR of -10dB to 20dB
SNR = 10.^(SNR_db/10);
sd = sqrt(1./SNR);  % Standard Deviation
var = sd.^2;        % Variance

% Number of Receive antenae to simulate
%L = 1:4;
% Number of Monte carlo iteration
T = 10000;

%% STEP 1 OF MONTE CARLO SIMULATION
%% Generating transmit data
x_bpsk = sign(randn(1, T));

SER = zeros(length(L),length(sd));

for p = 1:length(L)
    noise = zeros(L(p),T);
    h_channel = zeros(L(p),T);
    y = zeros(L(p),T);
    y_new = zeros(1,T);
    x_hat = zeros(1,T);
    
    for k = 1:length(sd)
      %%STEP 2 OF M-C SIMULATION
      % Generating COMPLEX RANDOM NOISE(LxT) MEAN 0 & VAR = N0 = 1/SNR
      noise = (1/sqrt(2))*sd(1,k)*randn(L(p),T) + 1i*(1/sqrt(2))*sd(1,k)*randn(L(p),T);
    
      % Generating COMPLEX RANDOM CHANNEL(LxT) WITH MEAN 0 & VAR = 1
      h_channel = (1/sqrt(2))*randn(L(p),T) + 1i*(1/sqrt(2))*randn(L(p),T);
    
      %%STEP 3 OF M-C SIMULATION
      %% RECEIVED SIGNAL ACCORDING TO RELATION y(LxT) = hx + n
      y = h_channel.*x_bpsk + noise;
    
      %% Finding the best channel in each time slot T
      [h_max, h_max_i] = max(h_channel,[],1);

      %% Picking the output of best channel for further processing
      idx = sub2ind(size(y), h_max_i, 1:length(h_max_i));    % Converting into linear indexing
      y_max = y(idx);

      %% STEP 4 OF M-C SIMULATION
      %% Using the detector threshold to do detection and get x_hat
      %% Matched Filter: On receiver we do (h/|h|) dot with y, projection
      y_new = dot(h_max./norm(h_max,2,'columns'),y_max,1);    %% Already a scalar, dot product considering cols as vectors
    
      x_hat = sign(real(y_new));    %% since BPSK, so taking real sufficient statistic
            
      %% STEP 5 OF M-C SIMULATION
      %% Evaluate I
      SER(p,k) = mean(x_hat~=x_bpsk);
    end
end

%figure(1)
%plot(abs(y(1,:)))
%plot(real(y(30,:)),imag(y(30,:)),'o')
%%PLOTTING
figure(1)
semilogy(SNR_db,SER,'.-')
grid on
axis([min(SNR_db) max(SNR_db) 1e-6 1])
title('BPSK - SIMO(Selection Combining): SER Simulation')
xlabel('signal-to-noise ratio (SNR) [dB]')
ylabel('symbol error rate (SER)')
legendtext ='';
for p = 1:length(L)
    legendtext = [legendtext; sprintf('SEL L = %d ',L(p))];
end
legend(legendtext)

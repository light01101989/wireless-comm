%% ECE 5680 - Wireless Communication
%% HW2: Ques 4_2
%% Author: Arjun Jauhari
%% Email/Netid: aj526
%% Date: 09/24/2015
%% Monte-Carlo simulation for estimating SER of BPSK under MISO config with BF

function [SER legendtext] = HW3_Q6_2(L)
% Find the SER for MISO case with L channel inputs(antennaes),
% Symbol sent from particular TX antenna is weighted version of transmit symbol(Beamforming)
%
% Input:
% L = Row vector with each value tells number of tranmit antennaes
% eg. L = [1 3] or [1:4]
%
% Output:
% SER = A LxNumOfSnrPoints matrix with each row corresponds to particular L value
%
% Plot:
% A plot corresponding to each value in vector L

SNR_db = 0:30;  % Sweeping over SNR of 0dB to 20dB
SNR = 10.^(SNR_db/10);
Es = 1;
sd = sqrt(Es./SNR);  % Standard Deviation
var = sd.^2;        % Variance

% Number of Monte carlo iteration
T = 10000;

%% STEP 1 OF MONTE CARLO SIMULATION
%% Generating transmit data
x_bpsk = sign(randn(1, T));

SER = zeros(length(L),length(sd));

for p = 1:length(L)
    %noise = zeros(L(p),T);
    %h_channel = zeros(L(p),T);
    %y = zeros(L(p),T);
    %y_new = zeros(1,T);
    %x_hat = zeros(1,T);
    
    for k = 1:length(sd)
      %%STEP 2 OF M-C SIMULATION
      % Generating COMPLEX RANDOM NOISE(1xT) as only on rx ant, MEAN 0 & VAR = N0 = Es/SNR
      noise = (1/sqrt(2))*sd(1,k)*randn(1,T) + 1i*(1/sqrt(2))*sd(1,k)*randn(1,T);
    
      % Generating COMPLEX RANDOM CHANNEL MODEL(LxT) WITH MEAN 0 AND VARIANCE VAR = 1
      h_channel = (1/sqrt(2))*randn(L(p),T) + 1i*(1/sqrt(2))*randn(L(p),T);
    
      %% TX
      % Perfect Beamforming Vector(LxT)
      BF = (1/sqrt(L(p)))*(conj(h_channel)./abs(h_channel));

      %% Tx vector(LxT)
      S = sqrt(Es)*(repmat(x_bpsk,L(p),1).*BF);

      %% RX
      %%STEP 3 OF M-C SIMULATION
      %% RECEIVED SIGNAL ACCORDING TO RELATION y(1xT) = h's + n
      y = sum(h_channel.*S,1) + noise;
    
      %% STEP 4 OF M-C SIMULATION
      %% Using the detector threshold to do detection and get x_hat
      %% On receiver we do (h/|h|) dot with y, projection, Matched Filter, MRC
      %% Matched Filter/MRC step(Scalar sufficient statistic, dot product considering cols as vectors)
      y_new = dot(sum(h_channel.*BF,1)./abs(sum(h_channel.*BF,1)),y,1);    
      %y_new = conj(h_channel./abs(h_channel)).*y;
    
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
semilogy(SNR_db,SER,'o-');
grid on
axis([min(SNR_db) max(SNR_db) 1e-6 1])
title('BPSK - MISO(BF): SER Simulation with varying TX antennae')
xlabel('signal-to-noise ratio (SNR) [dB]')
ylabel('symbol error rate (SER)')
legendtext ='';
for p = 1:length(L)
    legendtext = [legendtext; sprintf('BF L = %d     ',L(p))];
end
legend(legendtext)

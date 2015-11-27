%% ECE 5680 - Wireless Communication
%% HW2: Ques 4_7
%% Author: Arjun Jauhari
%% Email/Netid: aj526
%% Date: 09/24/2015
%% Monte-Carlo simulation for estimating SER of BPSK in single tap Fading channel(y=hx+n)
%% Performing Alamouti space-time coding scheme to get transmit diversity in 2x1 MISO case

function [SER] = HW4_Q7()
% Find the SER for SIMO case with L channel outputs(antennaes),
% decoding done by Maximal-Ratio Combining(MRC),combining signals from all the receive antennae 
%
% Output:
% SER = A LxNumOfSnrPoints matrix with each row corresponds to particular L outputs
%
% Plot:
% Generate a plot

% Number of Receive antenae to simulate
L = 2;

SNR_db = 0:30;  % Sweeping over SNR of -10dB to 20dB
SNR = 10.^(SNR_db/10);
%sd = sqrt(repmat(L',1,length(SNR))./repmat(SNR,length(L),1));  % Standard Deviation
sd = sqrt(L./SNR);  % Standard Deviation: as SNR=L.Es/N0, Es = 1 because BPSK
var = sd.^2;        % Variance

% Number of Monte carlo iteration
T = 100000;

%% STEP 1 OF MONTE CARLO SIMULATION
%% Generating transmit data
x_bpsk = sign(randn(1, T));

SER = zeros(length(L),length(sd));

for p = 1:length(L)
    for k = 1:length(sd)
      %%STEP 2 OF M-C SIMULATION
      % Generating COMPLEX RANDOM NOISE(1xT) as only on rx ant, MEAN 0 & VAR = N0 = L/SNR
      noise = (1/sqrt(2))*sd(p,k)*randn(1,T) + 1i*(1/sqrt(2))*sd(p,k)*randn(1,T);
    
      % Generating COMPLEX RANDOM CHANNEL MODEL(LxT/2) WITH MEAN 0 AND VARIANCE VAR = 1
      % LxT/2 since the assumption is channel remains same over 2 time slots
      % therefore need only T/2 channel vector for T simulations
      h_channel = (1/sqrt(2))*randn(L(p),T/2) + 1i*(1/sqrt(2))*randn(L(p),T/2);
    
      %% Data pre-processing
      xt = reshape(x_bpsk,2,length(x_bpsk)/2);
      xtp1 = conj(xt([2 1],:));
      xtp1(1,:) = -xtp1(1,:);
      %%STEP 3 OF M-C SIMULATION
      %% RECEIVED SIGNAL ACCORDING TO RELATION y1 = h1x1 + h2x2 + n1
      %% RECEIVED SIGNAL ACCORDING TO RELATION y2 = h1(-x2*) + h2x1* + n2

      %% xt and xtp1 are 2xT/2
      y1 = sum(h_channel.*xt,1) + noise(1,1:T/2);
      y2 = sum(h_channel.*xtp1) + noise(1,T/2+1:end);
    
      %% STEP 4 OF M-C SIMULATION
      %% Receiver following combining is done; assuming perfect knowledge of h1 & h2
      %% y1_tilde = h1*xY1 + h2xY2*
      %% y2_tilde = h2*xY1 - h1xY2*
      y1_tilde = conj(h_channel(1,:)).*y1 + h_channel(2,:).*conj(y2);
      y2_tilde = conj(h_channel(2,:)).*y1 - h_channel(1,:).*conj(y2);
    
      x1_hat = sign(real(y1_tilde));    %% since BPSK, so taking real sufficient statistic
      x2_hat = sign(real(y2_tilde));    %% since BPSK, so taking real sufficient statistic
            
      x_hat = reshape([x1_hat;x2_hat],1,length(x1_hat)*2);
      %% STEP 5 OF M-C SIMULATION
      %% Evaluate I
      SER(p,k) = mean(x_hat~=x_bpsk);
    end
end

%%PLOTTING
legendtext = strcat('Alamouti Scheme L= ',cellstr(num2str(L')));
figure(1)
semilogy(SNR_db,SER,'o-');
grid on
axis([min(SNR_db) max(SNR_db) 1e-6 1])
title('BPSK - MISO(STBC): SER with 2x1 transmit diversity')
xlabel('signal-to-noise ratio (SNR) [dB]')
ylabel('symbol error rate (SER)')
legend(legendtext)

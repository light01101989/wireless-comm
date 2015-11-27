%% ECE 5680 - Wireless Communication
%% HW5: Ques 1_1
%% Author: Arjun Jauhari
%% Email/Netid: aj526
%% Date: 11/5/2015
%% OFDM simulation full

function [BER,legendtext] = HW5_Q1_3(splot)
% Find the SER for SIMO case with L channel outputs(antennaes),
% decoding done by Maximal-Ratio Combining(MRC),combining signals from all the receive antennae 
%
% Input:
% splot = 1-> generate plot 0->no plot(optional)
%
% Output:
% SER = A LxNumOfSnrPoints matrix with each row corresponds to particular L outputs
%
% Plot:
% Generate a plot

% Number of subcarriers
nSub = 64;

% Number of channel taps
nTaps = 4;

if ~exist('splot','var')
    splot = 0;
end

SNR_db = 0:30;  % Sweeping over SNR of -10dB to 20dB
SNR = 10.^(SNR_db/10);
M = 4;   % QPSK
% Energy per constellation point
E = signal_energy(M);
%SNR = SNR/64;
sd = sqrt(((nTaps/nSub)*E)./SNR);  % Standard Deviation: as SNR=(L/W).Es/N0
%sd = sqrt(E./SNR);  % Standard Deviation: as SNR=(L/W).Es/N0
%var = sd.^2;        % Variance

% Number of Monte carlo iteration
T = 10000;
bitspsub = log2(M);
bitspsym = log2(M)*nSub;
n = (T*bitspsym)/2;

%% STEP 1 OF MONTE CARLO SIMULATION
%% Generating transmit data
bitsIn = randi([0 1],n,1);
consIn = reshape(bitsIn,length(bitsIn)/bitspsub,bitspsub);
consIn = bi2de(consIn);

symIn = qammod(consIn,M);

ofdmsymIn = reshape(symIn,length(symIn)/(nSub/2),nSub/2);
% ofdmsymIn = repmat(ofdmsymIn,2,1);
% ofdmsymIn = reshape(ofdmsymIn,numel(ofdmsymIn),1);
% ofdmsymIn = reshape(ofdmsymIn,T,nSub);

%SER = zeros(length(L),length(sd));

for k = 1:length(sd)
  %%STEP 2 OF M-C SIMULATION
  % Generating COMPLEX RANDOM NOISE(1xT) as only on rx ant, MEAN 0 & VAR = N0 = L/SNR
  noise = (1/sqrt(2))*sd(k)*randn(T,nSub) + 1i*(1/sqrt(2))*sd(k)*randn(T,nSub);

  % Generating COMPLEX RANDOM CHANNEL MODEL(LxT/2) WITH MEAN 0 AND VARIANCE VAR = 1
  % LxT/2 since the assumption is channel remains same over 2 time slots
  % therefore need only T/2 channel vector for T simulations
  h_channel = (1/sqrt(2))*randn(T,nTaps) + 1i*(1/sqrt(2))*randn(T,nTaps);

  %% fft of each row
  lamda = (1/sqrt(nSub)).*fft(h_channel,nSub,2);
  
%   o = (1:nSub/2)*2-1;
%   e = (1:nSub/2)*2;
  lamda_o = lamda(:,1:nSub/2);
  lamda_e = lamda(:,nSub/2+1:end);

  y_w_o = lamda_o.*ofdmsymIn + noise(:,1:nSub/2);
  y_w_e = lamda_e.*ofdmsymIn + noise(:,nSub/2+1:end);


  %% Receiver
  %% sufficient statistic
  y_tilda = conj(lamda_o).*y_w_o + conj(lamda_e).*y_w_e;
  y_tilda = y_tilda./sqrt(abs(lamda_o).^2 + abs(lamda_e).^2);

  y_temp = reshape(y_tilda,1,T*(nSub/2));
  x_temp = nn_detector(M,y_temp);

  x_hat = reshape(x_temp,T,(nSub/2));

  %% STEP 5 OF M-C SIMULATION
  %% Calculating BER
  %[~, decoded_sym] = ismember(x_hat,baseline_symbols(M));
  decoded_sym = qamdemod(x_hat,M);
  decoded_sym = reshape(decoded_sym,T*(nSub/2),1);
  %matbits = de2bi((decoded_sym - 1),bitspsub);
  matbits = de2bi((decoded_sym),bitspsub);
  decoded_bits = reshape(matbits,numel(matbits),1);
  BER(k) = mean(decoded_bits~=bitsIn);
end

%%PLOTTING
legendtext = strcat('OFDM QPSK: interleaved rep coding');
if splot ~= 0
    figure(1)
    semilogy(SNR_db,BER,'o-');
    grid on
    axis([min(SNR_db) max(SNR_db) 1e-6 1])
    title('OFDM - QPSK')
    xlabel('signal-to-noise ratio (SNR) [dB]')
    ylabel('bit error rate (BER)')
    legend(legendtext)
end
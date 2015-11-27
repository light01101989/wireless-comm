%% ECE 5680 - Wireless Communication
%% HW5: Ques 2_2
%% Author: Arjun Jauhari
%% Email/Netid: aj526
%% Date: 11/5/2015
%% OFDM simulation BICM-OFDM with interleaving

function [BER,legendtext] = HW5_Q2_2(SNR_db,splot)
% Simulate the BICM-OFDM case with 1/2 coding rate and interleaving
%
% Input:
% splot = 1-> generate plot 0->no plot(optional)
%
% Output:
% BER = simulated BER
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

if ~exist('SNR_db','var')
    SNR_db = 0:30;  % Default sweep from 0 to 30dB
end

SNR = 10.^(SNR_db/10);
M = 4;   % QPSK
% Energy per constellation point
E = signal_energy(M);
% noise sd sqrt(N0)
sd = sqrt(((nTaps/nSub)*E)./SNR);  % Standard Deviation: as SNR=(L/W).Es/N0

% Number of Monte carlo iteration
T = 10000;
bitspsub = log2(M);
bitspsym = log2(M)*nSub;

% number of bits to be BICM txed
Nbits = 64;

%% STEP 1 OF MONTE CARLO SIMULATION
%% Generating transmit data
bitsIn = randi([0 1],T,Nbits);
%% FEC
CbitsIn = bitsIn(:,ceil((1:2*Nbits)./2));
%% interleaving
temp = 1:Nbits*2;
intlv = [temp(1:2:end) temp(2:2:end)];
ICbitsIn = CbitsIn(:,intlv);
%% QPSK symbol generation
[r c] = size(ICbitsIn);
consIn = reshape(ICbitsIn,r,bitspsub,c/bitspsub);
for i=1:nSub
    symIn(:,i) = bi2de(consIn(:,:,i),'left-msb');
end

ofdmsymIn = qammod(symIn,M);

for k = 1:length(sd)
  %%STEP 2 OF M-C SIMULATION
  % Generating COMPLEX RANDOM NOISE(1xT) as only on rx ant, MEAN 0 & VAR = N0 = L/SNR
  noise = (1/sqrt(2))*sd(k)*randn(T,nSub) + 1i*(1/sqrt(2))*sd(k)*randn(T,nSub);

  % Generating nTaps COMPLEX RANDOM CHANNEL MODEL(TxnTaps) WITH MEAN 0 AND VAR = 1
  h_channel = (1/sqrt(2))*randn(T,nTaps) + 1i*(1/sqrt(2))*randn(T,nTaps);

  %% fft of each row
  lamda = (1/sqrt(nSub)).*fft(h_channel,nSub,2);
  
  y_w = lamda.*ofdmsymIn + noise;

  %% Receiver
  %% compute llr
  [l1,l2] = compute_llr(y_w,lamda,sd(k).^2,M);
  %% deinterleaved llr(Tx128)
  llr = reshape([l1;l2],size(l1,1),[]);

  %% Decoder
  %% D_mat(Tx64)
  D_mat = llr(:,1:nSub) + llr(:,nSub+1:end);

  x_hat = D_mat>=0;

  %% STEP 5 OF M-C SIMULATION
  %% Calculating BER
  BER(k) = mean(mean(x_hat~=bitsIn));
end

%%PLOTTING
legendtext = strcat('OFDM QPSK: BICM w interleaving');
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

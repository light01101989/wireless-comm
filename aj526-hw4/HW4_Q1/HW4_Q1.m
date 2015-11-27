%% ECE 5680 - Wireless Communication
%% HW2: Ques 3
%% Author: Arjun Jauhari
%% Email/Netid: aj526
%% Date: 09/24/2015
%% Monte-Carlo simulation for estimating SER(Symbol Error rate) of QPSK and BPSK in AWGN complex(I/Q) noise

function SER = HW4_Q1(mod,splot)
% Find the SER for various modulation in AWGN case,
%
% Input:
% mod = string input with modulation name
% eg. mod = 'all' -> plots all modulation(bpsk,qpsk,16qam,64qam,8psk)
% eg. mod = 'bpsk' -> just plots bpsk case
% splot = 1-> generate scatter plots also 0->no scatter plot(optional input)
%
% Output:
% SER = A LxNumOfSnrPoints matrix with each row corresponds to one
% modulation scheme
%
% Plot:
% Generate two plots
% A plot corresponding to each value of modulation
% A BER plot against Eb/No value in dB

SNR_db = -10:20;  % Sweeping over SNR of -10dB to 20dB
SNR = 10.^(SNR_db/10);

% Number of Monte carlo iteration
T = 10000;

if ~exist('splot','var')
    splot = 0;
end

switch mod
    case 'bpsk'
        M = 2;
    case 'qpsk'
        M = 4;
    case '16qam'
        M = 16;
    case '64qam'
        M = 64;
    case '8psk'
        M = 8;
    otherwise
        cons = {'bpsk','qpsk','16qam','64qam','8psk'};
        M = [2,4,16,64,8];
end

%% STEP 1 OF MONTE CARLO SIMULATION
%% Generating transmit data
for k=1:length(M)
    sd_noise = sqrt(signal_energy(M(k))./SNR);   % Standard Deviation of noise
    %disp(sd_noise);
    bitspsym = log2(M(k));      %bits per symbol
    n = T*bitspsym;             %number of bits to generate
    bitsIn = randi([0 1],n,1);  %input bits nx1
    bsymIn = reshape(bitsIn,length(bitsIn)/bitspsym,bitspsym);  %matrix form one row per sym
    symIn = bi2de(bsymIn);      %sym in decimal
    if M(k) == 8
        sym(k,:) = pskmod(symIn,M(k),0,'gray'); %gray mod
    else
        sym(k,:) = qammod(symIn,M(k),0,'gray'); %gray mod
    end
    
    if splot ~= 0
        hPlotSym = scatterplot(sym(k,:),1,0,'k*');
        if ~exist('cons','var')
            title(mod);
        else
            title(cons{k});
        end
        %hold on
        text(real(sym(k,:))+0.1,imag(sym(k,:)),dec2bin(symIn));
    end
    
    for i = 1:length(sd_noise)
        %%STEP 2 OF M-C SIMULATION
        % Generating RANDOM NOISE WITH MEAN 0 AND VARIANCE VAR == sd^2
        noise = (1/sqrt(2))*sd_noise(1,i)*randn(1,T) + 1i*(1/sqrt(2))*sd_noise(1,i)*randn(1,T);

        %%STEP 3 OF M-C SIMULATION
        %% RECEIVED SIGNAL ACCORDING TO RELATION y = x + n
        y = sym(k,:) + noise;
        
        %% STEP 4 OF M-C SIMULATION
        %% Using the detector threshold to do detection and get x_hat
        x_hat = nn_detector(M(k),y);

        %% STEP 5 OF M-C SIMULATION
        %% Evaluate I and calculate SER
        SER(k,i) = mean(x_hat~=sym(k,:));
        
        %% Calculating BER
        [~, decoded_sym] = ismember(x_hat,baseline_symbols(M(k)));
        matbits = de2bi((decoded_sym - 1),bitspsym);
        decoded_bits = reshape(matbits,numel(matbits),1);
        BER(k,i) = mean(decoded_bits~=bitsIn);
    end
    
    %% Calculating Eb/No
    EbN0_db(k,:) = SNR_db - 10*log10(bitspsym);
end

%%PLOTTING
%scatterplot(y,1,0,'g.',hPlotSym);
figure()
%semilogy(SNR_db,SER(1,:),'bo-',SNR_db,SER(2,:),'ko-')
semilogy(SNR_db,SER,'o-',SNR_db,BER,'*-')
grid on
axis([-10 20 1e-6 1])
xlabel('signal-to-noise ratio (SNR) [dB]')
ylabel('symbol error rate (SER)')
title('SER/BER curves for various modulations')
if ~exist('cons','var')
    legend(['SER-' mod; 'BER-' mod]);
else
    legend([strcat('SER-', cons), strcat('BER-', cons)]);
end
%hold off

figure()
[r,c] = size(EbN0_db);
for p=1:r
    semilogy(EbN0_db(p,:),BER(p,:),'*-')
    hold all
end
grid on
axis([min(EbN0_db(:,1)) max(EbN0_db(:,c)) 1e-6 1])
xlabel('bitEnergy-to-noise ratio (Eb/N0) [dB]')
ylabel('Bit error rate (SER)')
title('BER curves for various modulations')
if ~exist('cons','var')
    legend(['BER-' mod]);
else
    legend([strcat('BER-', cons)]);
end



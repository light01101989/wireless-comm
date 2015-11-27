%% ECE 5680 - Wireless Communication
%% HW4: Ques 3_1
%% Author: Arjun Jauhari
%% Email/Netid: aj526
%% Date: 10/24/2015
%% Monte-Carlo simulation for estimating SER of BPSK in in single tap Fading channel(y=hx+n) decision on(dot(h/|h|,y)) with SIMO case
%% Detection performed with joint ML channel estimates

%clear all;close all;
function [SER legendtext] = HW4_Q5_2(L,splot)
% Find the SER for SIMO case with L channel outputs(antennaes),
% decoding done by Maximal-Ratio Combining(MRC),combining signals from all the receive antennae 
%
% Input:
% L = Row vector with each value tells number of receive antennaes
% eg. L = [1 3] or [1:4]
% splot = 1-> generate plot 0->no plot(optional)
%
% Output:
% SER = A LxNumOfSnrPoints matrix with each row corresponds to particular L outputs
%
% Plot:
% A plot corresponding to each value in vector L

if ~exist('splot','var')
    splot = 0;
end

SNR_db = 0:30;  % Sweeping over SNR of -10dB to 20dB
SNR = 10.^(SNR_db/10);
sd = sqrt(1./SNR);  % Standard Deviation
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
      % Generating COMPLEX RANDOM NOISE(Lx2T) as L rx chains MEAN 0 & VAR = N0 = 1/SNR
      noise = (1/sqrt(2))*sd(1,k)*randn(L(p),2*T) + 1i*(1/sqrt(2))*sd(1,k)*randn(L(p),2*T);
    
      % Generating COMPLEX RANDOM CHANNEL(LxT) WITH MEAN 0 & VAR = 1
      h_channel = (1/sqrt(2))*randn(L(p),T) + 1i*(1/sqrt(2))*randn(L(p),T);
    
      %%STEP 3 OF M-C SIMULATION
      %% Phase 1: Training through Pilot x=1
      y_1 = h_channel*1 + noise(:,1:T);
      %% RECEIVED SIGNAL ACCORDING TO RELATION y(LxT) = hx + n
      y_2 = h_channel.*repmat(x_bpsk,L(p),1) + noise(:,T+1:end);

      %% ML channel estimate: h_hat = y_tr/(1+N0)
      argm=[-1,1];
      for i=1:length(argm)
        h_hat = (y_1+argm(i).*y_2)/repmat((1+(argm(i).^2)'),1,T);

        %% Detection Rule
        temp1 = (sum((conj(y_1).*y_1),1) + sum((conj(y_2).*y_2),1))/(1+var(1,k));
        
        temp2 = ((y_1.*(argm(i).^2))-(y_2.*argm(i)));
        temp3 = sum(conj(temp2).*temp2,1);
        
        temp4 = ((y_2)-(y_1.*argm(i)));
        temp5 = sum(conj(temp4).*temp4,1);
        
        temp6 = (temp3+temp5)/(var(1,k)*(1+argm(i).^2));
        
        obj(i,:) = temp1+temp6;
      end
      [~,x_h] = min(obj,[],1);
      x_hat = ((x_h-1).*2)-1;

      %% STEP 4 OF M-C SIMULATION
      %% Using the detector threshold to do detection and get x_hat
      %% On receiver we do (h_hat/||h_hat||) dot(takes harmitian for complex numbers) with y<=>(h_hat*/||h_hat||)xY, projection, Matched Filter, MRC
      %% Matched Filter/MRC step(Scalar sufficient statistic, dot product considering cols as vectors)
      %y_new = dot(h_hat./repmat(sqrt(sum(abs(h_hat).^2,1)),L(p),1),y,1);    
      %y_new = dot(h_channel./repmat(sqrt(sum(abs(h_channel).^2,1)),L(p),1),y,1);    
      %y_new = sum(conj(h_hat./norm(h_hat)).*y,1);
    
      %x_hat = sign(real(y_new));    %% since BPSK, so taking real sufficient statistic
            
      %% STEP 5 OF M-C SIMULATION
      %% Evaluate I
      SER(p,k) = mean(x_hat~=x_bpsk);
    end
end

%%PLOTTING
legendtext = strcat('ML joint chEst L= ',cellstr(num2str(L')));
if splot ~= 0
    figure(1)
    semilogy(SNR_db,SER,'o-');
    grid on
    axis([min(SNR_db) max(SNR_db) 1e-6 1])
    title('BPSK - SIMO(MRC) SER simulation with joint ML channel estimate')
    xlabel('signal-to-noise ratio (SNR) [dB]')
    ylabel('symbol error rate (SER)')
    legend(legendtext)
end

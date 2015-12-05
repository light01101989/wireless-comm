% -----------------------------------------------------
% -- Rayleigh Fading MIMO Capacity Simulator 
% -- 2015 (c) studer@cornell.edu
% -----------------------------------------------------

function cap_sim_fixthis(varargin)

  % -- set up default/custom parameters
  
  if isempty(varargin)
    
    disp('using default simulation settings and parameters...')
        
    % set default simulation parameters 
   
    par.runId = 0; % simulation ID (used to reproduce results)
    par.MR = 2; % receive antennas 
    par.MT = 2; % transmit antennas (set not larger than MR!) 
    par.mod = 'QPSK'; % modulation type: 'BPSK','QPSK','16QAM','64QAM'
    par.SNRdB_list = -10:4:20; % list of SNR [dB] values to be simulated
    par.trials = 200; % number of channel realizations
    par.integral = 200; % number of Monte-Carlo integration samples
    par.simName = [ 'CAP_' num2str(par.MR) 'x' num2str(par.MT) '_' par.mod ]; % simulation name (used for saving results)
    
  else
      
    disp('use custom simulation settings and parameters...')    
    par = varargin{1}; % only argument is par structure
    
  end

  % -- initialization
  
  % use runId random seed (enables reproducibility)
  rng(par.runId); 

  % set up Gray-mapped constellation alphabet (according to IEEE 802.11)
  switch (par.mod)
    case 'BPSK',
      par.symbols = [ -1 1 ];
    case 'QPSK', 
      par.symbols = [ -1-1i,-1+1i, ...
                      +1-1i,+1+1i ];
    case '16QAM',
      par.symbols = [ -3-3i,-3-1i,-3+3i,-3+1i, ...
                      -1-3i,-1-1i,-1+3i,-1+1i, ...
                      +3-3i,+3-1i,+3+3i,+3+1i, ...
                      +1-3i,+1-1i,+1+3i,+1+1i ];
    case '64QAM',
      par.symbols = [ -7-7i,-7-5i,-7-1i,-7-3i,-7+7i,-7+5i,-7+1i,-7+3i, ...
                      -5-7i,-5-5i,-5-1i,-5-3i,-5+7i,-5+5i,-5+1i,-5+3i, ...
                      -1-7i,-1-5i,-1-1i,-1-3i,-1+7i,-1+5i,-1+1i,-1+3i, ...
                      -3-7i,-3-5i,-3-1i,-3-3i,-3+7i,-3+5i,-3+1i,-3+3i, ...
                      +7-7i,+7-5i,+7-1i,+7-3i,+7+7i,+7+5i,+7+1i,+7+3i, ...
                      +5-7i,+5-5i,+5-1i,+5-3i,+5+7i,+5+5i,+5+1i,+5+3i, ...
                      +1-7i,+1-5i,+1-1i,+1-3i,+1+7i,+1+5i,+1+1i,+1+3i, ...
                      +3-7i,+3-5i,+3-1i,+3-3i,+3+7i,+3+5i,+3+1i,+3+3i ];
                         
  end
  par.Es = mean(abs(par.symbols).^2); % average symbol energy
  par.Q = log2(length(par.symbols)); % number of bits per symbol

  % create set with all possible transmit symbols
  % this is a terrible idea if there are a lot of transmit antennas
  par.all_symbols_idx = de2bi([0:2^(par.Q*par.MT)-1],par.MT,2^par.Q)'+1;
  par.all_symbols = par.symbols(par.all_symbols_idx);  
  
  % track simulation time
  time_elapsed = 0;
  
  % initialize result arrays (trials x SNR)
  res.GCAP = zeros(par.trials,length(par.SNRdB_list)); % Capacity (Gaussian)
  res.DCAP = zeros(par.trials,length(par.SNRdB_list)); % Achievable rate 

  % trials loop
  tic 
  for tt=1:par.trials
  
    % generate i.i.d. Rayleigh channel matrix
    H = sqrt(0.5)*(randn(par.MR,par.MT)+1i*randn(par.MR,par.MT));
            
    for ii=1:par.integral
    
      % generate transmit symbol
      idx = randi(2^par.Q,par.MT,1);
      s = par.symbols(idx).';
    
      % generate i.i.d. Gaussian channel matrix & noise vector
      n = sqrt(0.5)*(randn(par.MR,1)+1i*randn(par.MR,1));

      % noiseless transmission
      x = H*s;
    
      % SNR loop
      for kk=1:length(par.SNRdB_list)    

        % transmit data over noisy channel
        N0 = par.MT*par.Es*10^(-par.SNRdB_list(kk)/10);
        y = x+sqrt(N0)*n;        
      
        % compute p(y|Hs)
        pyHs = 1/(pi*N0)^par.MT*exp(-sum(abs(y-x).^2,1)/N0);
      
        % compute p(y), assuming equally likely transmit symbols
        py = 1/length(par.all_symbols)*sum( 1/(pi*N0)^par.MT*exp(-sum(abs(y*ones(1,2^(par.Q*par.MT))-H*par.all_symbols).^2,1)/N0) );

        % compute Ex[log2(p(y|Hs)/p(y))]
        if (pyHs~=0) && (py~=0)
          res.DCAP(tt,kk) = res.DCAP(tt,kk) + log2(pyHs/py)/par.integral;
        end
  
      end
    
    end

    % Compute Gaussian capacity for given channel H
    for kk=1:length(par.SNRdB_list)
      N0 = par.MT*par.Es*10^(-par.SNRdB_list(kk)/10);
      res.GCAP(tt,kk) = log2(real(det(eye(par.MT)+par.Es/N0*(H'*H))));
    end
    
    % keep track of simulation time    
    if toc>10
      time=toc;
      time_elapsed = time_elapsed + time;
      fprintf('estimated remaining simulation time: %3.0f min.\n',time_elapsed*(par.trials/tt-1)/60);
      tic
    end      

  end

  % Compute ergodic capacity  
  res.E_GCAP = mean(res.GCAP,1);
  res.E_DCAP = mean(res.DCAP,1);
                                                                  
  % Compute 10% epsilon-outage capacity
  epsilon = 0.1;
  %  ___________ _____ _____   _   _  ___________ _____   _ 
  % |  ___|  _  \_   _|_   _| | | | ||  ___| ___ \  ___| | |
  % | |__ | | | | | |   | |   | |_| || |__ | |_/ / |__   | |
  % |  __|| | | | | |   | |   |  _  ||  __||    /|  __|  | |
  % | |___| |/ / _| |_  | |   | | | || |___| |\ \| |___  |_|
  % \____/|___/  \___/  \_/   \_| |_/\____/\_| \_\____/  (_)
  num = par.trials*epsilon;
  for kk=1:length(par.SNRdB_list)
      temp = sort(res.GCAP(:,kk));
      res.CG_epsout(kk) = (temp(num)+temp(num+1))/2;
      temp = sort(res.DCAP(:,kk));
      res.CD_epsout(kk) = (temp(num)+temp(num+1))/2;
  end
  
  
  % -- save final results (par and res structure)    
  save([ par.simName '_' num2str(par.runId) ],'par','res');    
     
  % -- show ergodic capacity results (generates fairly nice Matlab plot)    
  figure(1)
  plot(par.SNRdB_list,res.E_GCAP,'bo-','LineWidth',2)
  hold on
  plot(par.SNRdB_list,res.E_DCAP,'rs-','LineWidth',2)
  hold off
  grid on
  xlabel('average SNR per receive antenna [dB]','FontSize',12)
  ylabel('bits per channel use [bit/s/Hz]','FontSize',12)
  axis([min(par.SNRdB_list) max(par.SNRdB_list) 0 10])
  legend('Capacity','Achievable rate',2)
  set(gca,'FontSize',13)
  print('-depsc',[ par.simName '.eps' ])
  
%   % -- show epsilon-outage capacity results (generates fairly nice Matlab plot)    
%   figure(2)
%   plot(par.SNRdB_list,res.O_GCAP,'bo-','LineWidth',2)
%   hold on
%   plot(par.SNRdB_list,res.O_DCAP,'rs-','LineWidth',2)
%   hold off
%   grid on
%   xlabel('average SNR per receive antenna [dB]','FontSize',12)
%   ylabel('bits per channel use [bit/s/Hz]','FontSize',12)
%   axis([min(par.SNRdB_list) max(par.SNRdB_list) 0 10])
%   legend('10%-outage capacity','10%-outage achievable rate',2)
%   set(gca,'FontSize',13)
%   print('-depsc',[ par.simName '_outage.eps' ])
  
end

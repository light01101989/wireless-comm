% -----------------------------------------------------
% -- Simple MIMO simulator (v0.2)
% -- 2014 (c) studer@cornell.edu
% -----------------------------------------------------

function simpleMIMOsim(varargin)

  % -- set up default/custom parameters
  
  if isempty(varargin)
    
    disp('using default simulation settings and parameters...')
        
    % set default simulation parameters 
    par.simName = 'ERR_4x4_16QAM'; % simulation name (used for saving results)
    par.runId = 0; % simulation ID (used to reproduce results)
    par.MR = 4; % receive antennas 
    par.MT = 4; % transmit antennas (set not larger than MR!) 
    par.mod = '16QAM'; % modulation type: 'BPSK','QPSK','16QAM','64QAM'
    par.trials = 10000; % number of Monte-Carlo trials (transmissions)
    par.SNRdB_list = 10:4:42; % list of SNR [dB] values to be simulated
    par.detector = {'ZF','bMMSE','uMMSE','ML','sML','SIC','MGS','MGS-MR','ZF-comp'}; % define detector(s) to be simulated 
    par.algotime = 0; % calculate individual detector algo time: can only be used if one detector specified
    par.sigmak = 1; % channel variance
    par.cmin = 10; % min iteration after stall event
    par.c1 = 20; % choose c1 based on qam size(higher value for higher QAM)
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

  % extract average symbol energy
  par.Es = mean(abs(par.symbols).^2); 
  
  % precompute bit labels
  par.Q = log2(length(par.symbols)); % number of bits per symbol
  par.bits = de2bi(0:length(par.symbols)-1,par.Q,'left-msb');

  % track simulation time
  time_elapsed = 0;
  res.talgo = zeros(1,length(par.SNRdB_list));
  
  % -- start simulation 
  
  % initialize result arrays (detector x SNR)
  res.VER = zeros(length(par.detector),length(par.SNRdB_list)); % vector error rate
  res.SER = zeros(length(par.detector),length(par.SNRdB_list)); % symbol error rate
  res.BER = zeros(length(par.detector),length(par.SNRdB_list)); % bit error rate

  % generate random bit stream (antenna x bit x trial)
  bits = randi([0 1],par.MT,par.Q,par.trials);

  % symbol vec gen
  %[par.complexs,par.symvec,par.num] = symbol_vec_gen(par);

  % trials loop
  tic
  for t=1:par.trials
  
    % generate transmit symbol
    idx = bi2de(bits(:,:,t),'left-msb')+1;
    s = par.symbols(idx).';
    
    % generate iid Gaussian channel matrix & noise vector
    n = sqrt(0.5)*(randn(par.MR,1)+1i*randn(par.MR,1));
    H = sqrt(0.5)*(randn(par.MR,par.MT)+1i*randn(par.MR,par.MT));

    % BF:symbol generation & normalize transmit symbol power to 1(from all antennae)
    s_bf = s./sqrt(par.MT*par.Es);

    % ZFPC:tx symbol
    s_zfpc = H\s;
    % extract transmit energy
    alpha = 1/sqrt(sum(abs(s_zfpc).^2));
    % normalize it with its energy to make overall tx power as 1
    s_zfpc = alpha.*s_zfpc;

    % BF:SVD of H at Tx
    [~,~,V] = svd(H);
    
    % transmit over noiseless channel (will be used later)
    x = H*s;
    x_bf = H*(V*s_bf); % BF
    x_zfpc = H*s_zfpc; % ZFPC
  
    % SNR loop
    for k=1:length(par.SNRdB_list)
      
      % compute noise variance (average SNR per receive antenna is: SNR=MT*Es/N0)
      N0 = par.MT*par.Es*10^(-par.SNRdB_list(k)/10);
      % normalised SNR for BF E[xvec^2] = 1 i.e. tx energy from all MT is 1
      % since effective Es(symbol power each antenna) now is (1/MT)
      N0_bf = par.MT*(par.Es/(par.MT*par.Es))*10^(-par.SNRdB_list(k)/10);
      
      % transmit data over noisy channel
      y = x+sqrt(N0)*n;
      y_bf = x_bf+sqrt(N0_bf)*n; % check
      y_zfpc = x_zfpc+sqrt(N0_bf)*n; % as tx power is same for both BF and ZFPC
          
      % algorithm loop      
      for d=1:length(par.detector)

        if par.algotime == 1
            if length(par.detector) > 1
                error('only one par.detector should be specified for algotime to work');
            end
            tic;
        end

        switch (par.detector{d}) % select algorithms
          case 'ZF', % zero-forcing detection
            [idxhat,bithat] = ZF(par,H,y);
          case 'bMMSE', % biased MMSE detector
            [idxhat,bithat] = bMMSE(par,H,y,N0);          
          case 'uMMSE', % unbiased MMSE detector
            [idxhat,bithat] = uMMSE(par,H,y,N0);
          case 'ML', % ML detection using sphere decoding
            [idxhat,bithat] = ML(par,H,y);
          case 'sML', % simple ML detection
            [idxhat,bithat] = simpleML(par,H,y);
          case 'SIC', % SIC/DFE detection
            [idxhat,bithat] = SIC(par,H,y);
          case 'BF', % BeamForming detection
            [idxhat,bithat] = BF(par,H,y_bf);
          case 'ZFPC', % Zero Forcing Precoding detection
            [idxhat,bithat] = ZFPC(par,H,y_zfpc);
          case 'MGS', % Mixed Gibbs Sampling
            %x0 = ones(2*par.MT,1);
            x0 = par.symbols(randi([1 length(par.symbols)],par.MT,1))';
            [idxhat,bithat,~,mgs_beta(t)] = mgs(par,H,y,x0,N0);
          case 'MGS-MR', % Mixed Gibbs Sampling-Multiple Restart
            [idxhat,bithat,numRestarts(t),mr_beta(t)] = mgs_mr(par,H,y,N0);
          case 'ZF-comp', % zero-forcing detection with complexity analysis
            [idxhat,bithat] = ZF_complexity(par,H,y);
          otherwise,
            error('par.detector type not defined.')      
        end
        
        if par.algotime == 1
            res.talgo(k) = res.talgo(k) + toc;
        end

        % -- compute error metrics
        err = (idx~=idxhat);
        res.VER(d,k) = res.VER(d,k) + any(err);
        res.SER(d,k) = res.SER(d,k) + sum(err)/par.MT;    
        res.BER(d,k) = res.BER(d,k) + sum(sum(bits(:,:,t)~=bithat))/(par.MT*par.Q);      
      
      end % algorithm loop
                 
    end % SNR loop    
    
    % keep track of simulation time    
    if toc>10
      time=toc;
      time_elapsed = time_elapsed + time;
      %fprintf('estimated remaining simulation time: %3.0f min.\n',time_elapsed*(par.trials/t-1)/60);
      fprintf('estimated remaining simulation time: %4.0f sec.\n',time_elapsed*(par.trials/t-1));
      tic
    end      
  
  end % trials loop

  % normalize results
  res.VER = res.VER/par.trials;
  res.SER = res.SER/par.trials;
  res.BER = res.BER/par.trials;
  res.time_elapsed = time_elapsed;
  res.talgo = res.talgo./par.trials;
  
  % -- save final results (par and res structure)
    
  save([ par.simName '_' num2str(par.runId) ],'par','res');    
  %save([ par.simName '_' num2str(par.runId) ],'par','res','mgs_beta','mr_beta','numRestarts');    
    
  % -- show results (generates fairly nice Matlab plot) 
  
  marker_style = {'bo-','rs--','mv-.','kp:','g*-','c>--','yx:'};
  figure(1)
  for d=1:length(par.detector)
    if d==1
      semilogy(par.SNRdB_list,res.BER(d,:),marker_style{d},'LineWidth',2)
      hold on
    else
      semilogy(par.SNRdB_list,res.BER(d,:),marker_style{d},'LineWidth',2)
    end
  end
  hold off
  grid on
  xlabel('average SNR per receive antenna [dB]','FontSize',12)
  ylabel('bit error rate (BER)','FontSize',12)
  axis([min(par.SNRdB_list) max(par.SNRdB_list) 1e-6 1])
  legend(par.detector,'FontSize',12)
  set(gca,'FontSize',12)
  
end

% -- set of detector functions 

%% zero-forcing (ZF) detector
function [idxhat,bithat] = ZF(par,H,y)
  xhat = H\y;    
  [~,idxhat] = min(abs(xhat*ones(1,length(par.symbols))-ones(par.MT,1)*par.symbols).^2,[],2);
  bithat = par.bits(idxhat,:);
end

%% biased MMSE detector (bMMSE)
function [idxhat,bithat] = bMMSE(par,H,y,N0)
  xhat = (H'*H+(N0/par.Es)*eye(par.MT))\(H'*y);    
  [~,idxhat] = min(abs(xhat*ones(1,length(par.symbols))-ones(par.MT,1)*par.symbols).^2,[],2);
  bithat = par.bits(idxhat,:);  
end

%% unbiased MMSE detector (uMMSE)
function [idxhat,bithat] = uMMSE(par,H,y,N0)
  W = (H'*H+(N0/par.Es)*eye(par.MT))\(H');
  xhat = W*y;
  G = real(diag(W*H));
  [~,idxhat] = min(abs(xhat*ones(1,length(par.symbols))-G*par.symbols).^2,[],2);
  bithat = par.bits(idxhat,:);
end

%% ML detection using sphere decoding
function [idxML,bitML] = ML(par,H,y)

  % -- initialization  
  Radius = inf;
  PA = zeros(par.MT,1); % path
  ST = zeros(par.MT,length(par.symbols)); % stack  

  % -- preprocessing
  [Q,R] = qr(H,0);  
  y_hat = Q'*y;    
  
  % -- add root node to stack
  Level = par.MT; 
  ST(Level,:) = abs(y_hat(Level)-R(Level,Level)*par.symbols.').^2;
  
  % -- begin sphere decoder
  while ( Level<=par.MT )          
    % -- find smallest PED in boundary    
    [minPED,idx] = min( ST(Level,:) );
    
    % -- only proceed if list is not empty
    if minPED<inf
      ST(Level,idx) = inf; % mark child as tested        
      NewPath = [ idx ; PA(Level+1:end,1) ]; % new best path
      
      % -- search child
      if ( minPED<Radius )
        % -- valid candidate found
        if ( Level>1 )                  
          % -- expand this best node
          PA(Level:end,1) = NewPath;
          Level = Level-1; % downstep
          DF = R(Level,Level+1:end) * par.symbols(PA(Level+1:end,1)).';
          ST(Level,:) = minPED + abs(y_hat(Level)-R(Level,Level)*par.symbols.'-DF).^2;
        else
          % -- valid leaf found     
          idxML = NewPath;
          bitML = par.bits(idxML',:);
          % -- update radius (radius reduction)
          Radius = minPED;    
        end
      end      
    else
      % -- no more childs to be checked
      Level=Level+1;      
    end    
  end
  
end

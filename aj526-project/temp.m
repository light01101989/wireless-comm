    % set default simulation parameters 
    %par.simName = 'ERR_4x4_16QAM'; % simulation name (used for saving results)
    %par.simName = 'MGS_16x16_16QAM_CF_MGS_MR'; % simulation name (used for saving results)
    %par.runId = 0; % simulation ID (used to reproduce results)
    %par.MR = 16; % receive antennas 
    %par.MT = 16; % transmit antennas (set not larger than MR!) 
    %par.mod = '16QAM'; % modulation type: 'BPSK','QPSK','16QAM','64QAM'
    %par.trials = 1; % number of Monte-Carlo trials (transmissions)
    %par.SNRdB_list = 18; % list of SNR [dB] values to be simulated
    %%par.SNRdB_list = 10:4:42; % list of SNR [dB] values to be simulated
    %%par.detector = {'ZF','bMMSE','uMMSE','ML','sML','SIC'}; % define detector(s) to be simulated 
    %par.detector = {'MGS','MGS-MR'}; % define detector(s) to be simulated 
    %par.algotime = 0; % calculate individual detector algo time: can only be used if one detector specified
    %par.sigmak = 1; % channel variance
    %par.cmin = 10; % min iteration after stall event
    %%par.c1 = 20; % choose c1 based on qam size(higher value for higher QAM)
    %par.c1 = 40; % choose c1 based on qam size(higher value for higher QAM)




    % set default simulation parameters 
    %par.simName = 'ERR_4x4_16QAM'; % simulation name (used for saving results)
    par.simName = 'MGS_16x16_16QAM_MGS_MGS-MR'; % simulation name (used for saving results)
    par.runId = 0; % simulation ID (used to reproduce results)
    par.MR = 16; % receive antennas 
    par.MT = 16; % transmit antennas (set not larger than MR!) 
    par.mod = '16QAM'; % modulation type: 'BPSK','QPSK','16QAM','64QAM'
    par.trials = 100; % number of Monte-Carlo trials (transmissions)
    par.SNRdB_list = 10:2:20; % list of SNR [dB] values to be simulated
    %par.SNRdB_list = 10:4:42; % list of SNR [dB] values to be simulated
    %par.detector = {'ZF','bMMSE','uMMSE','ML','sML','SIC'}; % define detector(s) to be simulated 
    par.detector = {'MGS','MGS-MR'}; % define detector(s) to be simulated 
    par.algotime = 0; % calculate individual detector algo time: can only be used if one detector specified
    par.sigmak = 1; % channel variance
    par.cmin = 10; % min iteration after stall event

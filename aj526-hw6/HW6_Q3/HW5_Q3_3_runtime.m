function [] = HW5_Q3_3_runtime()    

    % set simulation parameters 
    par.runId = 0; % simulation ID (used to reproduce results)
    par.MR = 4; % receive antennas 
    par.MT = 4; % transmit antennas (set not larger than MR!) 
    par.mod = 'QPSK'; % modulation type: 'BPSK','QPSK','16QAM','64QAM'
    par.trials = 100; % number of Monte-Carlo trials (transmissions)
    par.SNRdB_list = 0:1:40; % list of SNR [dB] values to be simulated
    %par.detector = {'ML','sML'}; % define detector(s) to be simulated  
    
    % Sphere ML time capture
    par.simName = 'HW5_Q3_2_4x4_QPSK_sphereML'; % simulation name (used for saving results)
    par.detector = {'ML'}; % define detector(s) to be simulated  
    par.algotime = 1; % calculate individual detector algo time: can only be used if one detector specified
    
    simpleMIMOsim(par);

    % Sphere ML time capture
    par.simName = 'HW5_Q3_2_4x4_QPSK_ZF'; % simulation name (used for saving results)
    par.detector = {'ZF'}; % define detector(s) to be simulated  
    par.algotime = 1; % calculate individual detector algo time: can only be used if one detector specified
    
    simpleMIMOsim(par);

    % MMSE time capture
    par.simName = 'HW5_Q3_2_4x4_QPSK_bMMSE'; % simulation name (used for saving results)
    par.detector = {'bMMSE'}; % define detector(s) to be simulated  
    par.algotime = 1; % calculate individual detector algo time: can only be used if one detector specified
    
    simpleMIMOsim(par);

    % SIC time capture
    par.simName = 'HW5_Q3_2_4x4_QPSK_SIC'; % simulation name (used for saving results)
    par.detector = {'SIC'}; % define detector(s) to be simulated  
    par.algotime = 1; % calculate individual detector algo time: can only be used if one detector specified
    
    simpleMIMOsim(par);

    % Load and plot time for both algo's
    if par.algotime == 1
        load('HW5_Q3_2_4x4_QPSK_sphereML_0.mat')
        time_sphere = res.talgo.*1e3;

        load('HW5_Q3_2_4x4_QPSK_ZF_0.mat')
        time_ZF = res.talgo.*1e3;

        load('HW5_Q3_2_4x4_QPSK_bMMSE_0.mat')
        time_MMSE = res.talgo.*1e3;

        load('HW5_Q3_2_4x4_QPSK_SIC_0.mat')
        time_SIC = res.talgo.*1e3;

        plot(par.SNRdB_list,time_sphere,'bo-',par.SNRdB_list,time_ZF,'rs--',par.SNRdB_list,time_MMSE,'k*-',par.SNRdB_list,time_SIC,'g>--');
        axis([min(par.SNRdB_list) max(par.SNRdB_list) 0 1]);
        xlabel('SNRdB');ylabel('Time[ms]');
        legend('sphereML','ZF','MMSE','SIC');
        title('MIMO:RunTime for decoding one received vector');
    end
    
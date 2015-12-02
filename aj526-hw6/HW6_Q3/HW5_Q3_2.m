function [] = HW5_Q3_2()    

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
    par.simName = 'HW5_Q3_2_4x4_QPSK_simpleML'; % simulation name (used for saving results)
    par.detector = {'sML'}; % define detector(s) to be simulated  
    par.algotime = 1; % calculate individual detector algo time: can only be used if one detector specified
    
    simpleMIMOsim(par);

    % Load and plot time for both algo's
    if par.algotime == 1
        load('HW5_Q3_2_4x4_QPSK_sphereML_0.mat')
        time_sphere = res.talgo.*1e3;

        load('HW5_Q3_2_4x4_QPSK_simpleML_0.mat')
        time_simple = res.talgo.*1e3;

        plot(par.SNRdB_list,time_sphere,'bo-',par.SNRdB_list,time_simple,'rs--');
        axis([min(par.SNRdB_list) max(par.SNRdB_list) 0 1]);
        xlabel('SNRdB');ylabel('Time[ms]');
        legend('sphereML','simpleML');
        title('MIMO:Time for decoding one received vector');
    end
    
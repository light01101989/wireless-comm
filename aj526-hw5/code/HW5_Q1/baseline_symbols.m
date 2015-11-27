function bl_sym = baseline_symbols(M)

cons_data = 0:M-1;
if M == 8
    bl_sym = pskmod(cons_data,M,0,'gray'); %gray mod
else
    bl_sym = qammod(cons_data,M,0,'gray'); %gray mod
    %bl_sym = qammod(cons_data,M); %gray mod
end

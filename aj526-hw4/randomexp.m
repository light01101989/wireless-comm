M=16;
bitspsym = log2(M);      %bits per symbol
bitsIn = randi([0 1],8,1);
bsym = reshape(bitsIn,length(bitsIn)/bitspsym,bitspsym);

symIn = qammod(bi2de(bsym),M,0,'gray'); %gray mod

dec_data = 0:M-1;
if M == 8
    sym = pskmod(dec_data,M,0,'gray'); %gray mod
else
    sym = qammod(dec_data,M,0,'gray'); %gray mod
end

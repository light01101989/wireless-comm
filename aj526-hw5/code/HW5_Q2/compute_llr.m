function [l1,l2] = compute_llr(y,lamda,gamma,M)

[r c] = size(y);

bssym = baseline_symbols(M);
for i=1:length(bssym)
    ymet(:,:,i) = y - lamda.*bssym(i);
end

%QPSK
nl1 = exp(-(abs(ymet(:,:,3)).^2)./(2*gamma)) + exp(-(abs(ymet(:,:,4)).^2)./(2*gamma));
dl1 = exp(-(abs(ymet(:,:,1)).^2)./(2*gamma)) + exp(-(abs(ymet(:,:,2)).^2)./(2*gamma));

nl2 = exp(-(abs(ymet(:,:,2)).^2)./(2*gamma)) + exp(-(abs(ymet(:,:,4)).^2)./(2*gamma));
dl2 = exp(-(abs(ymet(:,:,1)).^2)./(2*gamma)) + exp(-(abs(ymet(:,:,3)).^2)./(2*gamma));

l1 = log(nl1./dl1);
l2 = log(nl2./dl2);

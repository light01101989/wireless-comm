function [idxhat,bithat] = ZF_complexity(par,H,y)

% Step 1: calc H'*y
yMF = H'*y;
yMF_nMul = par.MT*(par.MR*4);   % as H is MRxMT

% Step 2: calc gram matrix
G = H'*H;
G_nMul = 2*par.MR*par.MT + 4*par.MR*sum(1:par.MT-1);

% Step 3a: decompose gram matrix
L = chol(G,'lower');

% Step 3b: 
fs=0;
A = zeros(par.MT,par.MT);
I = eye(par.MT);
for i=1:par.MT
    t=0;
    for j=1:par.MT
        for k=1:t
            fs = fs+L(j,k)*A(k,i);
        end
        if t==0
            k=0;
        end
        A(j,i) = (I(j,i)-fs)./L(j,k+1);
        fs=0;
        t=t+1;
    end
end

A_nMul = 4*par.MT*sum(1:par.MT-1);

G_inv = A'*A;
G_inv_nMul = 4*(par.MT)^3 + A_nMul;

% Step 4:
v = G_inv*yMF;
v_nMul = 4*(par.MT^2);

% Step 5:
[~,idxhat] = min(abs(v*ones(1,length(par.symbols))-ones(par.MT,1)*par.symbols).^2,[],2);
bithat = par.bits(idxhat,:);
idxhat_nMul = 2*par.MT*length(par.symbols);

nMul = [yMF_nMul G_nMul G_inv_nMul v_nMul idxhat_nMul];
%figure(2)
%bar(nMul)

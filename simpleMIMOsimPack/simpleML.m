function [idxhat,bithat] = simpleML(par,H,y)

    x = H*par.complexs;
    
    % solve for argmin||y-x||^2
    [~,idxhat] = min(sum((abs(repmat(y,1,par.num) - x).^2),1));
    idxhat = par.symvec(:,idxhat)+1;
    bithat = par.bits(idxhat,:);
    
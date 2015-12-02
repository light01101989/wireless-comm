function [idxhat,bithat] = BF(par,H,y)

    % Do SVD decomposition of channel matrix H
    [U,S,V] = svd(H);
    
    y_tilda = U'*y;
    
    % Solving y_tilda = Sx + n --> argminofx |y_tilda1 - S1*x|.^2
    y_diff = repmat(y_tilda,1,length(par.symbols)) - S*repmat(par.symbols,par.MT,1);
    [~,idxhat] = min(abs(y_diff).^2,[],2);
    bithat = par.bits(idxhat,:);    
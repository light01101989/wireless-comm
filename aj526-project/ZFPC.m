function [idxhat,bithat] = ZFPC(par,H,y)

    % Solving y = x + n --> argminofx |y - x|.^2
    y_diff = repmat(y,1,length(par.symbols)) - repmat(par.symbols,par.MT,1);
    [~,idxhat] = min(abs(y_diff).^2,[],2);
    bithat = par.bits(idxhat,:);
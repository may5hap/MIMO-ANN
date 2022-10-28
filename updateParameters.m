function [U, V, W, du, dv, dw] = updateParameters(U, V, W, du, dv, dw, dumean, dvmean, dwmean, lambda, lr)

    du = lambda * du + (1 - lambda) * dumean;

    dv = lambda * dv + (1 - lambda) * dvmean;

    dw = lambda * dw + (1 - lambda) * dwmean;

    U = U - lr * du;

    V = V - lr * dv;

    W = W - lr * dw;

end
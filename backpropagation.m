function [U, V, W, dutmp, dvtmp, dwtmp] = backpropagation(s, z, x, r, b, a, y, sh, U, V, W, Hr, Hd)

    [daconj, dwtmp] = backPropFromDestToRelay(y, sh, s, W, Hd);
    
    [dxconj, dvtmp] = backPropFromRelayToUser(r, b, daconj, V, Hr);
    
    dz = gradselconj(z) * conj(dxconj) + gradsel(z) * dxconj;

    dutmp = conj(s) * dz;
end
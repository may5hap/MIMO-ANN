function [sigUserRecv, dvtmp] = backPropFromRelayToUser(r, b, daconj, V, Hr)
    
    da = conj(daconj);

    db = gradselconj(b) * da + gradsel(b) * daconj;

    dvtmp = r * db';

    sigFromRelayToUser = sel(conj(V * db));

    sigUserRecv = Hr.' * sigFromRelayToUser;
    
end
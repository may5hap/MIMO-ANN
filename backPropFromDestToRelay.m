function [sigRelayRecv, dwtmp] = backPropFromDestToRelay(y, sh, s, W, Hd)

    dwtmp = y * conj(sh - s);

    sigFromReceiverToRelay = sel(conj(W * (sh - s)));

    sigRelayRecv = Hd.' * sigFromReceiverToRelay;

end
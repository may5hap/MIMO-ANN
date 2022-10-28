function [b, a, y] = ForwardFromRelayToReceiver(r, V, Hd, eta_d)

    b = V' * r;
    
    a = sel(b);
    
    y = eta_d(Hd * a);

end
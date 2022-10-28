function [z, x, r, b, a, y, sh] = forward(s, U, V, W, Hr, Hd, eta_r, eta_d)

    [z, x, r] = ForwardFromUserToRelay(s, U, Hr, eta_r);
    
    [b, a, y] = ForwardFromRelayToReceiver(r, V, Hd, eta_d);

    sh = W' * y;

end
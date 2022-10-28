function [z, x, r] = ForwardFromUserToRelay(s, U, Hr, eta_r)
    
    z = U * s;

    x = sel(z);

    r = eta_r(Hr * x);

end
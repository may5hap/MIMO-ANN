function [ret] = gradsel(x)

    lx = size(x);
    lx = lx(1);
    tmp = rand(1, lx);
    for i = 1 : lx
        if abs(x(i)) > 1
            tmp(i) = - 0.5 / abs(x(i)) * exp(1i * angle(x(i)));
        else
            tmp(i) = 0;
        end
    end
    ret = diag(tmp);
%     disp(size(ret))

end
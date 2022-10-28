function [ret] = gradselconj(x)

    lx = size(x);
    lx = lx(1);
    tmp = rand(1, lx);
    for i = 1 : lx
        if abs(x(i)) > 1
            tmp(i) = 1/(2 * abs(x(i)));
        else
            tmp(i) = 1;
        end
    end
    ret = diag(tmp);
%     disp(size(ret))

end
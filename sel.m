function [out] = sel(x)
    tmp = abs(x);
    if tmp < 1
        out = x;
    else
        rad = angle(x);
        out = exp(1i * rad);
    end
%     out = x;
%     sz = size(x);
%     for i = 1 : sz(1)
%         for j = 1 : sz(2)
%             tmp = abs(x(i,j));
%             if tmp < 1
%                 out(i,j) = x(i,j);
%             else
%                 rad = angle(x(i,j));
%                 out(i,j) = exp(1i * rad);
%             end
%         end
%     end
end
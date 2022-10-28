function [UserBit, NumBit] = generateData(L, M)
% 功能： 生成不同用户一帧内的发送比特，用cell结构体封装
% 输入： 用户数量NumUser
%        序列长度L
%        调制阶数M
% 输出： 每个用户的bit序列userbit
%        每个用户bit序列的长度userbitsize

NumBit = L * M;
UserBit = round(randi( [0, M-1],1,L ));
% UserBit = UserBit';
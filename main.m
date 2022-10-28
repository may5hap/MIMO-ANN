clear all;
close all;

NumUser = 1;                            % 用户数
NumAntennaPerUser = 2;                  % 每个用户的发射天线数
NumRelay = 1;                           % 中继节点数
NumAntennaInRelay = 4;                  % 每个中继节点的输入天线数
NumAntennaOutRelay = 4;                 % 每个中继节点的输出天线数
NumReceiver = 1;                        % 接收端个数
NumAntennaPerReceiver = 2;              % 目的端天线数

% 待优化的参数
U = rand(NumAntennaPerUser, NumUser) + 1i * (rand(NumAntennaPerUser, NumUser));                                             % 源信号波束成型参数
V = rand(NumAntennaOutRelay, NumAntennaInRelay) + 1i * (rand(NumAntennaOutRelay, NumAntennaInRelay));     % 中继节点的信号波束成型参数
W = rand(NumAntennaPerReceiver, NumReceiver) + 1i * (rand(NumAntennaPerReceiver, NumReceiver));                             % 目的端信号波束成型参数

% 先定义参数，包括：训练的轮数T，梯度更新参数λ，学习率α
T = 1000;            % 也等价于帧数，每一帧数据进行一次训练
lambda = 0.9;
lr = 0.3;

du = zeros(size(U));
dv = zeros(size(V));
dw = zeros(size(W));

SNR_r = 20;             % 20dB
SNR_d = 20;             % 20dB

sigma_r2 = NumUser * NumAntennaPerUser / (10.^(SNR_r/10));          % 从源用户到中继的噪声功率
sigma_d2 = NumRelay * NumAntennaInRelay / (10.^(SNR_d/10));         % 从中继到接收节点的噪声功率

L = 32;             % 导频序列长度
M = 4;              % QPSK

% 从用户到中继的信道，因为信道是静态的（论文中），所以预先设定好
Hr = normrnd(0, sqrt(1/2), NumAntennaInRelay, NumAntennaPerUser) + 1i * (normrnd(0, sqrt(1/2), NumAntennaInRelay, NumAntennaPerUser));

% 从中继到目的端的信道，因为信道是静态的（论文中），所以预先设定好
Hd = normrnd(0, sqrt(1/2), NumAntennaPerReceiver, NumAntennaOutRelay) + 1i * normrnd(0, sqrt(1/2), NumAntennaPerReceiver, NumAntennaOutRelay);

% 噪声。因为论文中的噪声也是静态的，所以预先设定好。
eta_r = comm.AWGNChannel("Variance", sigma_r2);
eta_d = comm.AWGNChannel("Variance", sigma_d2);

% 调制解调器。采用QPSK或者16QAM，每个天线发送的信号调制方式均相同
modulator = comm.PSKModulator(M, pi/4);
demodulator = comm.PSKDemodulator(M, pi/4);

% modulator = comm.GeneralQAMModulator();

for i = 1 : T
    % 创建原始信号序列。
    UserData = generateData(L, M);       % 训练的时候只有导频信息？

    sL = modulator(UserData');
    sL = sL';
    
    duL = zeros(NumAntennaPerUser, NumUser, L);
    dvL = zeros(NumAntennaOutRelay, NumAntennaInRelay, L);
    dwL = zeros(NumAntennaPerReceiver, NumReceiver, L);

    % 按照文章中的公式，应该是symbol-wise，否则矩阵维度不匹配
    for j = 1 : L
        s = sL(j);
        [z, x, r, b, a, y, sh] = forward(s, U, V, W, Hr, Hd, eta_r, eta_d);
    
        demodulatedSig = demodulator(sh');

        loss(j) = min(1, abs(sh-s).^2);
    
        [U, V, W, dutmp, dvtmp, dwtmp] = backpropagation(s, z, x, r, b, a, y, sh, U, V, W, Hr, Hd);

        duL(:,:,j) = (dutmp);
        dvL(:,:,j) = (dvtmp);
        dwL(:,:,j) = (dwtmp);
    end


    Loss(i) = mean(loss);
    SINR(i) = 10 * log10(1/Loss(i)-1);

    dumean = mean(duL, 3);
    dvmean = mean(dvL, 3);
    dwmean = mean(dwL, 3);

    [U, V, W, du, dv, dw] = updateParameters(U, V, W, du, dv, dw, dumean, dvmean, dwmean, lambda, lr);

end

% 画图
x = linspace(0,T);
yyaxis right      
semilogy(Loss)
ylabel('MSE')

yyaxis left      
plot(SINR)
title("Ms=Mr=Md=4, \rho_r=\rho_d=20dB, QPSK")
ylabel('SNR (dB)')

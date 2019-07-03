% plots the p BEC V/s pSuccess for multiple product codes k=9, k=16 and
% k=25, working is exactly the same as wrapper2 except this code does it
% multiple times
clear vars; clear all;

rootK = 2;
k = rootK*rootK;
N=(rootK+1).^2;
[HMat, codeWords] = productCodeBasics(rootK);

sampleSize = 50;
p = linspace(0.01, 0.99, 99);
expRes = zeros(1, sampleSize);
graphData1 = zeros(1, length(p));

for pError=1:length(p)
    for i=1:sampleSize
        noiseErasure = randsrc(1, N, [-1 0; p(pError) 1-p(pError)]);
        [expRes(i), ] = decoderBEC(HMat, codeWords(randperm(2.^k, 1), :), noiseErasure);
    end
    graphData1(pError) = sum(expRes)/sampleSize;
end

rootK = 3;
k = rootK*rootK;
N=(rootK+1).^2;
[HMat, codeWords] = productCodeBasics(rootK);

graphData2 = zeros(1, length(p));
for pError=1:length(p)
    for i=1:sampleSize
        noiseErasure = randsrc(1, N, [-1 0; p(pError) 1-p(pError)]);
        [expRes(i), ] = decoderBEC(HMat, codeWords(randperm(2.^k, 1), :), noiseErasure);
    end
    graphData2(pError) = sum(expRes)/sampleSize;
end

rootK = 4;
k = rootK*rootK;
N=(rootK+1).^2;
[HMat, codeWords] = productCodeBasics(rootK);

graphData3 = zeros(1, length(p));
for pError=1:length(p)
    for i=1:sampleSize
        noiseErasure = randsrc(1, N, [-1 0; p(pError) 1-p(pError)]);
        [expRes(i), ] = decoderBEC(HMat, codeWords(randperm(2.^k, 1), :), noiseErasure);
    end
    graphData3(pError) = sum(expRes)/sampleSize;
end


figure(1);
plot(p, graphData1); hold on;
plot(p, graphData2); hold on;
plot(p, graphData3);
title('BEC Decoder Performance for Product Code');
xlabel('Probability p of BEC'); ylabel('Probability of Successful Decoding');
legend('k=4, N=9', 'k=9, N=16', 'k=16, N=25'); grid;
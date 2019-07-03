% plots the p BEC V/s pSuccess

clear vars; clear all;

% setting up the required matrices
rootK = 2;
k = rootK*rootK;
N=(rootK+1).^2;
[HMat, codeWords] = productCodeBasics(rootK);

% defining sampleSize and the probabilities for which we will conduct the
% experiment sampleSize times so for sampleSize=500 and p = 0.01 to 0.99
% there will be a total of 500*99 experiments
sampleSize = 500;
p = linspace(0.01, 0.99, 99);
expRes = zeros(1, sampleSize);
graphData = zeros(1, length(p));

for pError=1:length(p)
    for i=1:sampleSize
        % randsrc acts as a random source which generates -1s with a
        % probabulity of p and 0s with 1-p
        noiseErasure = randsrc(1, N, [-1 0; p(pError) 1-p(pError)]);
        
        % we then select a random codeword from all available codewords
        [expRes(i), ] = decoderBEC(HMat, codeWords(randperm(2.^k, 1), :), noiseErasure);
    end
    
    % finally we store the result of each probability in the graphData
    % array
    graphData(pError) = sum(expRes)/sampleSize;
end

str = strcat('k=', num2str(k), ' N=', num2str(N), ' || Sample Size=', num2str(sampleSize));
figure(1);
plot(p, graphData);
title('BEC Decoder Performance for Product Code');
xlabel('Probability p of BEC'); ylabel('Probability of Successful Decoding');
legend(str); grid;
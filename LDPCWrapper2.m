% performs the plotting of p BEC V/s pSuccess
% the Hmatrix has to be loaded first for LDPC Code
N = length(HMat(1, :));

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
        
        % now we send the zero codeword
        [expRes(i), ] = decoderBEC(HMat, zeros(1, N), noiseErasure);
    end
    graphData(pError) = sum(expRes)/sampleSize;
end

str = strcat('N=', num2str(N), ' || Sample Size=', num2str(sampleSize));
figure(1);
plot(p, graphData);
title('BEC Decoder Performance for LDPC');
xlabel('Probability p of BEC'); ylabel('Probability of Successful Decoding');
legend(str); grid;
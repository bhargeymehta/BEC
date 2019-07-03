% plots the single experiment as well as the number of erasures v/s the
% iteration index

clear vars; clear all;

% makes the required matrices to operate on
rootK = 3;
k=rootK*rootK;
N=(rootK+1).^2;
[HMat, codeWords] = productCodeBasics(rootK);

% generates a random noise sequence which has pre-defined number of
% erasures
bits2Erase = 4;
temp = randperm(N, bits2Erase);
noiseErasure = zeros(1, N);
for i=1:bits2Erase
    noiseErasure(temp(i))=-1;
end


[result, iterationData] = decoderBEC(HMat, codeWords(randperm(2.^k, 1), :), noiseErasure);
if(result == 1)
    fprintf('Decoding successful!\n');
else
    fprintf('Decoding Unsuccesful!\n');
end
iterationNumber = linspace(0, length(iterationData)-1, length(iterationData));

% plot of the single random experiment
str = strcat('k= ', num2str(k), ' N=', num2str(N));
figure(1);
plot(iterationNumber, iterationData); ylim([0 N]);
xlabel('Iteration Index'); ylabel('Number of Erasures');
legend(str);
title('Erasures v/s Iterations for a Random Experiment Product Code BEC'); grid;


% plotting the number of erasures v/s pSuccess
% so we will erase 1 bit sampleSize times and check the probability of
% success, then we will erase 2 bits sampleSize times and so on till N

sampleSize=500;
decodingSuccess = zeros(1, N);
for bits2Erase=1:N
    pBits = zeros(1, sampleSize);
    for j=1:sampleSize
        
        % logic to delete random pre-defined number of bits
        temp = randperm(N, bits2Erase);
        noiseErasure = zeros(1, N);
        for i=1:bits2Erase
            noiseErasure(temp(i))=-1;
        end
    
        [pBits(j),] = decoderBEC(HMat, codeWords(randperm(2.^k, 1), :), noiseErasure);
    end
    pBits = sum(pBits)/sampleSize;
    
    decodingSuccess(bits2Erase)=pBits;
end

str = strcat('k= ', num2str(k), ' N=', num2str(N), ' || sampleSize=', num2str(sampleSize));
figure(2);
stem(linspace(1, N, N), decodingSuccess); ylim([0 1]);
xlabel('No. of Bits Erased'); ylabel('Probability of Successful Decoding');
legend(str);
title('Performance of Product Code in BEC'); grid;

clear i j iterationData iterationNumber noiseErasure result temp bits2Erase sampleSize;
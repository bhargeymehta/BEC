% plots the results of a single experiment and the number of erasures v/s
% the pSuccess

% we need to first load the HMatrix as HMat for LDPC Code
N = length(HMat(1, :));

% erases the pre-defined number of locations randomly
bits2Erase = 4;
temp = randperm(N, bits2Erase);
noiseErasure = zeros(1, N);
for i=1:bits2Erase
    noiseErasure(temp(i))=-1;
end

% sends the zero codeword to check to the decoder
[result, iterationData] = decoderBEC(HMat, zeros(1, N), noiseErasure);
if(result == 1)
    fprintf('Decoding Successful!\n');
else
    fprintf('Decoding Unsuccesful!\n');
end
iterationNumber = linspace(0, length(iterationData)-1, length(iterationData));

% plotting the number of erasures v/s pSuccess
% so we will erase 1 bit sampleSize times and check the probability of
% success, then we will erase 2 bits sampleSize times and so on till N
figure(1);
plot(iterationNumber, iterationData); ylim([0 N]);
xlabel('Iteration Index'); ylabel('Number of Erasures');
title('Erasures v/s Iterations for a Random Experiment LDPC Codes'); grid;

sampleSize=5000;
decodingSuccess = zeros(1, N);
for bits2Erase=1:N
    pBits = zeros(1, sampleSize);
    for j=1:sampleSize
        temp = randperm(N, bits2Erase);
        noiseErasure = zeros(1, N);
        for i=1:bits2Erase
            noiseErasure(temp(i))=-1;
        end
    
        [pBits(j),] = decoderBEC(HMat, zeros(1, N), noiseErasure);
    end
    pBits = sum(pBits)/sampleSize;
    
    decodingSuccess(bits2Erase)=pBits;
end

str = strcat('N= ', num2str(N), ' || sampleSize=', num2str(sampleSize));
figure(2);
stem(linspace(1, N, N), decodingSuccess); ylim([0 1]);
xlabel('No. of Bits Erased'); ylabel('Probability of Successful Decoding');
legend(str);
title('Performance of LDPC Code in BEC'); grid;

clear i j iterationData iterationNumber noiseErasure result temp bits2Erase sampleSize;
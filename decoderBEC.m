function [didPass, erasureMat]=decoderBEC(HMat, codeTransmitted, noiseErasure)

rowSize = length(HMat(1,:));
colSize = length(HMat(:,1));

% generating the noise induced string by replacing bit with -1 where
% erasure is encountered
codeRecieved = zeros(1, rowSize);
for i=1:rowSize
   if(noiseErasure(i)==-1)
       codeRecieved(i) = -1;
   else
       codeRecieved(i) = codeTransmitted(i);
   end
end

% making a copy of recieved codeword to work with
correctedCode = codeRecieved;

% storing the initial erasures
iterations = 0;
erasureMat = zeros(1, ((colSize).^2)+1);
for i=1:rowSize
   if(correctedCode(i)==-1)
      erasureMat(1) = erasureMat(1) + 1; 
   end
end

b=1;
% HMatrix to checkNodes
for i=1:colSize
    for j=1:rowSize
        if(HMat(i, j) == 1)
            checkNodes(i, b) = j;
            b = b+1;
        end
    end
    b=1;
end


for i=1:colSize % controlling the maximum iterations of the full codeWord
    for j=1:colSize %selecting the parity check relation ie the check node
        
        %finding the number of erasures in a particular check node
        canReconst=0;
        for k=1:length(checkNodes(1, :))
            if(checkNodes(j, k)~=0)
                if(correctedCode(checkNodes(j, k))==-1)
                   canReconst = canReconst+1;
                end
            end
        end
        
        % if only one erasure is encountered then we proceed to correct it
        % we traverse the particular checkNode and if the corresponding
        % data bit index contains 1 or 0 we add it to a temp variable and
        % if it is -1 then we store it in erasedBit
        % Since we know that the can reconstruct variable is 1, there is
        % only one -1 present in this checkNode
        % So finally we assign the modulo-2 sum of the rest of data node to
        % the erased node
        if(canReconst==1)
            temp=0;
            for k=1:length(checkNodes(1, :))
                if(checkNodes(j, k)~=0)
                   if(correctedCode(checkNodes(j, k)) ~= -1)
                      temp = temp+correctedCode(checkNodes(j, k));
                   else
                      erasedBit = checkNodes(j, k);
                   end
                end
            end
            correctedCode(erasedBit) = rem(temp, 2);
        end
        
        % fprintf('i=%d, j=%d, canReconst=%d\n', i, j, canReconst); 
        % to show which parity check relation is being corrected
        
        % storing the number of erasures after checking one check node
        iterations = iterations + 1;
        for m=1:rowSize
            if(correctedCode(m)==-1)
                erasureMat(iterations+1) = erasureMat(iterations+1) + 1; 
            end
        end
        
        % flag to check if the codeWord has been reconstructed after every
        % iteration so as to be able to decide when to break from the
        % process
        isRecovered = 1;
        for k=1:rowSize
           if(correctedCode(k)==-1)
              isRecovered = 0;
              break;
           end
        end
        
        if(isRecovered == 1)
           break; 
        end
        
    end
    
    if(isRecovered == 1)
        break;
    end
    
end

if(correctedCode == codeTransmitted)
   %fprintf('Successful recovery in %d iterations!\n', iterations);
   didPass=1;
else
   %fprintf('Unsuccessful recovery!\n');
   didPass=0;
end

end
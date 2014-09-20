% Initialize mirror system training data
% numPatterns - number of training patterns
% inSize - input layer size
% outSize - output layer size
function TrainingData=initTrainingData(numPatterns, inSize, outSize)

TrainingData.numPatterns=numPatterns;
TrainingData.inSize=inSize;
TrainingData.outSize=outSize;
TrainingData.input_patterns=zeros(numPatterns,inSize);
TrainingData.output_patterns=zeros(numPatterns,outSize);

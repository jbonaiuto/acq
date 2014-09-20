% Train the mirror system
% numHiddenUnits1 = number of hidden units in the first hidden layer
% numHiddenUnits2 = number of hidden units in the second hidden layer
function trainMNS(numHiddenUnits1, numHiddenUnits2)

AlstermarkParams=generateMirrorTrainingData();
save 'trainingData.mat' AlstermarkParams;
range=zeros(12,2);
range(:,2)=1.0;
net=newffnet(range, [numHiddenUnits1 numHiddenUnits2 9], {'logsig', 'logsig', 'purelin'});
net.trainParam.epochs=10000;
net.trainParam.min_grad=1e-100;
net=train(net,AlstermarkParams.TrainingData.input_patterns',AlstermarkParams.TrainingData.output_patterns');
save 'net.mat' net;

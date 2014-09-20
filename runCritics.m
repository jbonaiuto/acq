% Run critics
% predictorInput = input
% internalState = internal state
function CriticParams=runCritics(CriticParams, predictorInput, internalState, primaryR)

% Predictors
CriticParams.p=predictorInput;

% TD error
CriticParams.td=primaryR+CriticParams.gamma*CriticParams.p-CriticParams.p_delayed;

% Update predictor delayed
CriticParams.p_delayed=CriticParams.p;

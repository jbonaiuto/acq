% Reset critics
function CriticParams=resetCriticNetwork(CriticParams)

% Predictor outputs
CriticParams.p=zeros(CriticParams.nIntState,1);
% Delayed predictor outputs
CriticParams.p_delayed=zeros(CriticParams.nIntState,1);
% Secondary reinforcement
CriticParams.secondaryR=zeros(CriticParams.nIntState,1);
% TD errors
CriticParams.tdError=zeros(CriticParams.nIntState,1);

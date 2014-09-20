% Initialize critics
% nIntState = number of internal state variables
function CriticParams=initCritics(nIntState)

CriticParams.nIntState=nIntState;

% Discount factor
CriticParams.gamma=0.9;

% Predictor output
CriticParams.p=zeros(nIntState,1);

% Delayed predictor output
CriticParams.p_delayed=zeros(nIntState,1);

% TD errors
CriticParams.td=zeros(nIntState,1);

% Tonic dopamine level
CriticParams.tonicD=1.25;

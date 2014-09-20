% Reset model variables
function AlstermarkParams=resetNetwork(AlstermarkParams)

% Reset internal state
AlstermarkParams.intState=100.0;

% Reset paw position
AlstermarkParams.p=[0 0];
% Reset mouth position
AlstermarkParams.m=[0 35];
% Reset food position
AlstermarkParams.f=[30 30];
% Reset tube opening position
AlstermarkParams.b=[15 30];

% Reset paw-food population code
AlstermarkParams.pf=zeros(AlstermarkParams.Pmax,AlstermarkParams.Pmax);
% Reset mouth-food population code
AlstermarkParams.mf=zeros(AlstermarkParams.Pmax,AlstermarkParams.Pmax);
% Reset tube-food population code
AlstermarkParams.bf=zeros(AlstermarkParams.Pmax,AlstermarkParams.Pmax);

% Reset motor signal
AlstermarkParams.x=zeros(AlstermarkParams.nActions,1);
% Reset delayed motor signal
AlstermarkParams.delayed_x=zeros(AlstermarkParams.nActions,1);
% Action recognition - mirror system output
AlstermarkParams.ar=zeros(AlstermarkParams.nActions,1);
% Delayed action recognition output
AlstermarkParams.delayed_ar=zeros(AlstermarkParams.nActions,1);
% Reward
AlstermarkParams.r=0;

% Reset ACQ network
AlstermarkParams.ACQParams=resetACQNetwork(AlstermarkParams.ACQParams);
% Reset critics
AlstermarkParams.CriticParams=resetCriticNetwork(AlstermarkParams.CriticParams);

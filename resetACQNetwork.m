% Reset ACQ network
function ACQParams=resetACQNetwork(ACQParams)

% Executability
ACQParams.e=zeros(ACQParams.nActions,1);
% Internal state
ACQParams.is=zeros(ACQParams.nIntState,1);


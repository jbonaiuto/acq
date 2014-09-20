% Initialize ACQ model
% nActions = number of actions available for execution
% nIntState = number of internal state variables
function ACQParams=initACQ(nActions,nIntState)

ACQParams.nActions=nActions;
ACQParams.nIntState=nIntState;

% Variance of the noise in the desirability
ACQParams.sigma_sq_d=0.05;

% Time constant of the internal state layer neurons
ACQParams.tau_is=5;

% Internal state firing rate
ACQParams.is=zeros(nIntState,1);

% Internal state membrane potential
ACQParams.u_is=zeros(nIntState,1);

% Executability
ACQParams.e=zeros(nActions,1);

% Internal state -> parallel planning layer weights
ACQParams.w_is=zeros(nActions,nIntState);

% Competitive choice layer -> critic predictor weights
ACQParams.w_cp=zeros(nIntState,nActions);

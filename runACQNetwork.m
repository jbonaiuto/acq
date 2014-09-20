% Run the ACQ network
% intState = internal state inputs
function ACQParams=runACQNetwork(ACQParams, intState)

% Get internal state
ACQParams.u_is=(-ACQParams.u_is+intState)/ACQParams.tau_is+ACQParams.u_is;
ACQParams.is=max(0.0, min(1.0, ACQParams.u_is));

% Compute desirability
ACQParams.noise=sqrt(ACQParams.sigma_sq_d)*rand(ACQParams.nActions,1);
ACQParams.d=(ACQParams.w_is*ACQParams.is)+ACQParams.noise;
ACQParams.p=ACQParams.e.*ACQParams.d;

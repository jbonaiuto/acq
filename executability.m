% Compute action executability from affordance input
function e=executability(AlstermarkParams)

e=zeros(AlstermarkParams.nActions,1);

% Executability is affordance input times executability 
% weights plus noise
for i=1:AlstermarkParams.nActions
    pf_e=sum(sum(AlstermarkParams.pf.*squeeze(AlstermarkParams.pf_w(i,:,:))));
    mf_e=sum(sum(AlstermarkParams.mf.*squeeze(AlstermarkParams.mf_w(i,:,:))));
    bf_e=sum(sum(AlstermarkParams.bf.*squeeze(AlstermarkParams.bf_w(i,:,:))));
    pb_e=sum(sum(AlstermarkParams.pb.*squeeze(AlstermarkParams.pb_w(i,:,:))));
    e(i)=max(0.0, min(1.0, pf_e+mf_e+bf_e+pb_e))+2*sqrt(AlstermarkParams.sigma_sq_exec)*(rand-.5);
end

% Dummy actions are always executable
if AlstermarkParams.nActions>9
    e(10:AlstermarkParams.nActions)=.99;
end

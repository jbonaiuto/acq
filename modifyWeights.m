% Modify desirability connection weights
function AlstermarkParams=modifyWeights(AlstermarkParams)

% Total effective reinforcement
dR=sum(AlstermarkParams.CriticParams.td);


for i=1:AlstermarkParams.nActions

    eR=0;
    % Modify external state -> parallel planning layer weights
    if AlstermarkParams.ar(i)>0
        eR=1;
    elseif AlstermarkParams.x(i)>0 && AlstermarkParams.ar(i)<.25
        eR=-1;
    end
        
    AlstermarkParams.mf_w(i,:,:)=min(1.0,max(-5.0,squeeze(AlstermarkParams.mf_w(i,:,:))+AlstermarkParams.mf.*eR.*AlstermarkParams.alpha));
    AlstermarkParams.pf_w(i,:,:)=min(1.0,max(-5.0,squeeze(AlstermarkParams.pf_w(i,:,:))+AlstermarkParams.pf.*eR.*AlstermarkParams.alpha));
    AlstermarkParams.bf_w(i,:,:)=min(1.0,max(-5.0,squeeze(AlstermarkParams.bf_w(i,:,:))+AlstermarkParams.bf.*eR.*AlstermarkParams.alpha));
    AlstermarkParams.pb_w(i,:,:)=min(1.0,max(-5.0,squeeze(AlstermarkParams.pb_w(i,:,:))+AlstermarkParams.pb.*eR.*AlstermarkParams.alpha));
   
    if AlstermarkParams.t>1
        % Modify internal state -> parallel planning layer weights
        AlstermarkParams.ACQParams.w_is(i,:)=max(0,AlstermarkParams.ACQParams.w_is(i,:)+AlstermarkParams.ACQParams.is'.*(AlstermarkParams.alpha)*dR*AlstermarkParams.ar_rec(AlstermarkParams.trial,AlstermarkParams.t-1,i));

        % Modify competitive choice layer -> critic predictor weights
        AlstermarkParams.ACQParams.w_cp(:,i)=max(0,AlstermarkParams.ACQParams.w_cp(:,i)+AlstermarkParams.ACQParams.is.*(AlstermarkParams.alpha)*dR*AlstermarkParams.ar_rec(AlstermarkParams.trial,AlstermarkParams.t-1,i));
    end
end

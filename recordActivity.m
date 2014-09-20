% Record network activity
function AlstermarkParams=recordActivity(AlstermarkParams)

AlstermarkParams.trial_len(AlstermarkParams.trial)=AlstermarkParams.t;
AlstermarkParams.ar_rec(AlstermarkParams.trial,AlstermarkParams.t,:)=AlstermarkParams.ar;

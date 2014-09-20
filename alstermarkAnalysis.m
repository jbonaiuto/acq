function Analysis=alstermarkAnalysis(instances, dummy, numTrials, ratio, timeLimit, actionLimit)

Analysis.recoveryThreshold=ratio;
Analysis.recoveryHistorySize=5;

Analysis.postStats.trial_len=zeros(length(dummy),length(instances),numTrials);
Analysis.postNoMirrorStats.trial_len=zeros(length(dummy), length(instances),numTrials);
Analysis.postStats.lastUnsuccessful=zeros(length(dummy),length(instances));
Analysis.postNoMirrorStats.lastUnsuccessful=zeros(length(dummy),length(instances));
Analysis.postStats.firstSuccessful=zeros(length(dummy),length(instances));
Analysis.postNoMirrorStats.firstSuccessful=zeros(length(dummy),length(instances));
Analysis.postStats.firstSuccessfulRatio=zeros(length(dummy),length(instances));
Analysis.postNoMirrorStats.firstSuccessfulRatio=zeros(length(dummy),length(instances));
Analysis.postStats.firstSuccessfulTimeLimit=zeros(length(dummy),length(instances));
Analysis.postNoMirrorStats.firstSuccessfulTimeLimit=zeros(length(dummy),length(instances));
Analysis.postStats.firstSuccessfulRatioTimeLimit=zeros(length(dummy),length(instances));
Analysis.postNoMirrorStats.firstSuccessfulRatioTimeLimit=zeros(length(dummy),length(instances));
Analysis.postStats.firstSuccessfulActionLimit=zeros(length(dummy),length(instances));
Analysis.postNoMirrorStats.firstSuccessfulActionLimit=zeros(length(dummy),length(instances));
Analysis.postStats.firstSuccessfulRatioActionLimit=zeros(length(dummy),length(instances));
Analysis.postNoMirrorStats.firstSuccessfulRatioActionLimit=zeros(length(dummy),length(instances));
Analysis.postStats.lastDummy=zeros(length(dummy),length(instances));
Analysis.postNoMirrorStats.lastDummy=zeros(length(dummy),length(instances));
Analysis.postStats.firstIntentional=zeros(length(dummy),length(instances));
Analysis.postNoMirrorStats.firstIntentional=zeros(length(dummy),length(instances));
Analysis.postStats.firstIntentionalRatio=zeros(length(dummy),length(instances));
Analysis.postNoMirrorStats.firstIntentionalRatio=zeros(length(dummy),length(instances));
Analysis.postStats.unsuccessful=zeros(length(dummy),length(instances));
Analysis.postNoMirrorStats.unsuccessful=zeros(length(dummy),length(instances));

dummyIdx=1;
% For each number of dummy actions used
for i=dummy
    ['processing ' num2str(i)]
    instanceIdx=1;
    % For each instance
    for j=instances

        % Load postlesion with mirror data
        load([num2str(i) '/alstermark_postlesion_mirror_' num2str(j) '.mat']);
        
        % Record trial length
        Analysis.postStats.trial_len(dummyIdx,instanceIdx,:)=post.trial_len(1:numTrials);

        % compute recovery metrics
        % last unsuccessful trial
        Analysis.postStats.lastUnsuccessful(dummyIdx, instanceIdx)=max(find(post.trial_len==50));
        % first successful trial
        if length(find(post.trial_len<50))>0
            Analysis.postStats.firstSuccessful(dummyIdx, instanceIdx)=min(find(post.trial_len<50));
        else
            Analysis.postStats.firstSuccessful(dummyIdx, instanceIdx)=numTrials;
        end
        % first a/b successful trials
        Analysis.postStats.firstSuccessfulRatio(dummyIdx,instanceIdx)=numTrials;
        % first a/b successful trials in under X time steps
        Analysis.postStats.firstSuccessfulRatioTimeLimit(dummyIdx,instanceIdx)=numTrials;
        % first a/b successful trials in under X attempted actions
        Analysis.postStats.firstSuccessfulRatioActionLimit(dummyIdx,instanceIdx)=numTrials;
        % first a/b intentionally successful trials
        Analysis.postStats.firstIntentionalRatio(dummyIdx,instanceIdx)=numTrials;

        history=zeros(Analysis.recoveryHistorySize,1);
        action_history=zeros(Analysis.recoveryHistorySize,1);
        intentional_history=zeros(Analysis.recoveryHistorySize,1);
        for k=1:numTrials
            for l=1:Analysis.recoveryHistorySize-1
                history(l)=history(l+1);
                action_history(l)=action_history(l+1);
                intentional_history(l)=intentional_history(l+1);
            end
          
            history(Analysis.recoveryHistorySize)=post.trial_len(k);

            action_history(Analysis.recoveryHistorySize)=squeeze(sum(sum(post.x_rec(k,:,:),3)));

            if post.trial_len(k)<50 && sum(post.x_rec(k,:,7))>0
                intentional_history(Analysis.recoveryHistorySize)=0;
            else
                intentional_history(Analysis.recoveryHistorySize)=numTrials;
            end

            if k>=Analysis.recoveryHistorySize && length(find(history<numTrials))/Analysis.recoveryHistorySize >= Analysis.recoveryThreshold && Analysis.postStats.firstSuccessfulRatio(dummyIdx,instanceIdx)==numTrials
                Analysis.postStats.firstSuccessfulRatio(dummyIdx,instanceIdx)=k-Analysis.recoveryHistorySize+1;
            end

            if k>=Analysis.recoveryHistorySize && length(find(history<timeLimit))/Analysis.recoveryHistorySize >= Analysis.recoveryThreshold && Analysis.postStats.firstSuccessfulRatioTimeLimit(dummyIdx,instanceIdx)==numTrials
                Analysis.postStats.firstSuccessfulRatioTimeLimit(dummyIdx,instanceIdx)=k-Analysis.recoveryHistorySize+1;
            end

            if k>=Analysis.recoveryHistorySize && length(find(action_history<actionLimit))/Analysis.recoveryHistorySize >= Analysis.recoveryThreshold && Analysis.postStats.firstSuccessfulRatioActionLimit(dummyIdx,instanceIdx)==numTrials
                Analysis.postStats.firstSuccessfulRatioActionLimit(dummyIdx,instanceIdx)=k-Analysis.recoveryHistorySize+1;
            end

            if k>=Analysis.recoveryHistorySize && length(find(intentional_history<numTrials))/Analysis.recoveryHistorySize >= Analysis.recoveryThreshold && Analysis.postStats.firstIntentionalRatio(dummyIdx,instanceIdx)>=numTrials
                Analysis.postStats.firstIntentionalRatio(dummyIdx,instanceIdx)=k-Analysis.recoveryHistorySize+1;
            end
        end
        % first successful trial in under X time steps
        if length(find(post.trial_len<timeLimit))>0
            Analysis.postStats.firstSuccessfulTimeLimit(dummyIdx, instanceIdx)=min(find(post.trial_len<timeLimit));
        else
            Analysis.postStats.firstSuccessfulTimeLimit(dummyIdx, instanceIdx)=numTrials;
        end
        % first successful trial in under X attempted actions
        if length(find(squeeze(sum(sum(post.x_rec,3)))<actionLimit))>0
            Analysis.postStats.firstSuccessfulActionLimit(dummyIdx, instanceIdx)=min(find(squeeze(sum(sum(post.x_rec,3)))<actionLimit));
        else
            Analysis.postStats.firstSuccessfulActionLimit(dummyIdx, instanceIdx)=numTrials;
        end
        % last execution of a dummy action
        if post.nActions>9 
            if length(find(sum(sum(post.x_rec(:,:,10:post.nActions),2),3)>0))>0
                Analysis.postStats.lastDummy(dummyIdx, instanceIdx)=max(find(sum(sum(post.x_rec(:,:,10:post.nActions),2),3)>0));
            else
                Analysis.postStats.lastDummy(dummyIdx, instanceIdx)=numTrials;
            end
        end
        % first intentionally successful trial (using rake instead of grasp paw)
        a=find(post.trial_len<50);
        b=find(sum(sum(post.x_rec(:,:,7),2),3)>0);
        if length(intersect(a,b))>0
            Analysis.postStats.firstIntentional(dummyIdx, instanceIdx)=min(intersect(a,b));
        else
            Analysis.postStats.firstIntentional(dummyIdx, instanceIdx)=numTrials;
        end
        % number of unsuccessful trials
        if Analysis.postStats.trial_len(dummyIdx,instanceIdx,numTrials)==50
            Analysis.postStats.unsuccessful(dummyIdx, instanceIdx)=1;
        end

        % Load postlesion without mirror data
        load([num2str(i) '/alstermark_postlesion_no_mirror_' num2str(j) '.mat']);

        % Record trial length
        Analysis.postNoMirrorStats.trial_len(dummyIdx,instanceIdx,:)=post.trial_len(1:numTrials);

        % compute recovery metrics
        Analysis.postNoMirrorStats.lastUnsuccessful(dummyIdx, instanceIdx)=max(find(post.trial_len==50));
        if length(find(post.trial_len<50))>0
            Analysis.postNoMirrorStats.firstSuccessful(dummyIdx, instanceIdx)=min(find(post.trial_len<50));
        else
            Analysis.postNoMirrorStats.firstSuccessful(dummyIdx, instanceIdx)=numTrials;
        end
        % first a/b successful trials
        Analysis.postNoMirrorStats.firstSuccessfulRatio(dummyIdx,instanceIdx)=numTrials;
        % first a/b successful trials in under X time steps
        Analysis.postNoMirrorStats.firstSuccessfulRatioTimeLimit(dummyIdx,instanceIdx)=numTrials;
        % first a/b successful trials in under X attempted actions
        Analysis.postNoMirrorStats.firstSuccessfulRatioActionLimit(dummyIdx,instanceIdx)=numTrials;
        % first a/b intentionally successful trials
        Analysis.postNoMirrorStats.firstIntentionalRatio(dummyIdx,instanceIdx)=numTrials;

        history=zeros(Analysis.recoveryHistorySize,1);
        action_history=zeros(Analysis.recoveryHistorySize,1);
        intentional_history=zeros(Analysis.recoveryHistorySize,1);
        for k=1:numTrials
            for l=1:Analysis.recoveryHistorySize-1
                history(l)=history(l+1);
                action_history(l)=action_history(l+1);
                intentional_history(l)=intentional_history(l+1);
            end
          
            history(Analysis.recoveryHistorySize)=post.trial_len(k);

            action_history(Analysis.recoveryHistorySize)=squeeze(sum(sum(post.x_rec(k,:,:),3)));

            if post.trial_len(k)<numTrials && sum(post.x_rec(k,:,7))>0
                intentional_history(Analysis.recoveryHistorySize)=0;
            else
                intentional_history(Analysis.recoveryHistorySize)=numTrials;
            end

            if k>=Analysis.recoveryHistorySize && length(find(history<numTrials))/Analysis.recoveryHistorySize >= Analysis.recoveryThreshold && Analysis.postNoMirrorStats.firstSuccessfulRatio(dummyIdx,instanceIdx)==numTrials
                Analysis.postNoMirrorStats.firstSuccessfulRatio(dummyIdx,instanceIdx)=k-Analysis.recoveryHistorySize+1;
            end

            if k>=Analysis.recoveryHistorySize && length(find(history<timeLimit))/Analysis.recoveryHistorySize >= Analysis.recoveryThreshold && Analysis.postNoMirrorStats.firstSuccessfulRatioTimeLimit(dummyIdx,instanceIdx)==numTrials
                Analysis.postNoMirrorStats.firstSuccessfulRatioTimeLimit(dummyIdx,instanceIdx)=k-Analysis.recoveryHistorySize+1;
            end

            if k>=Analysis.recoveryHistorySize && length(find(action_history<actionLimit))/Analysis.recoveryHistorySize >= Analysis.recoveryThreshold && Analysis.postNoMirrorStats.firstSuccessfulRatioActionLimit(dummyIdx,instanceIdx)==numTrials
                Analysis.postNoMirrorStats.firstSuccessfulRatioActionLimit(dummyIdx,instanceIdx)=k-Analysis.recoveryHistorySize+1;
            end

            if k>=Analysis.recoveryHistorySize && length(find(intentional_history<numTrials))/Analysis.recoveryHistorySize >= Analysis.recoveryThreshold && Analysis.postNoMirrorStats.firstIntentionalRatio(dummyIdx,instanceIdx)==numTrials
                Analysis.postNoMirrorStats.firstIntentionalRatio(dummyIdx,instanceIdx)=k-Analysis.recoveryHistorySize+1;
            end
        end
        % first successful trial in under X time steps
        if length(find(post.trial_len<timeLimit))>0
            Analysis.postNoMirrorStats.firstSuccessfulTimeLimit(dummyIdx, instanceIdx)=min(find(post.trial_len<timeLimit));
        else
            Analysis.postNoMirrorStats.firstSuccessfulTimeLimit(dummyIdx, instanceIdx)=numTrials;
        end
        % first successful trial in under X attempted actions
        if length(find(squeeze(sum(sum(post.x_rec,3)))<actionLimit))>0
            Analysis.postNoMirrorStats.firstSuccessfulActionLimit(dummyIdx, instanceIdx)=min(find(squeeze(sum(sum(post.x_rec,3)))<actionLimit));
        else
            Analysis.postNoMirrorStats.firstSuccessfulActionLimit(dummyIdx, instanceIdx)=numTrials;
        end
        % last execution of a dummy action
        if post.nActions>9 
            if length(find(sum(sum(post.x_rec(:,:,10:post.nActions),2),3)>0))>0
                Analysis.postNoMirrorStats.lastDummy(dummyIdx, instanceIdx)=max(find(sum(sum(post.x_rec(:,:,10:post.nActions),2),3)>0));
            else
                Analysis.postNoMirrorStats.lastDummy(dummyIdx, instanceIdx)=numTrials;
            end
        end
        % first intentionally successful trial (using rake instead of grasp paw)
        a=find(post.trial_len<50);
        b=find(sum(sum(post.x_rec(:,:,7),2),3)>0);
        if length(intersect(a,b))>0
            Analysis.postNoMirrorStats.firstIntentional(dummyIdx, instanceIdx)=min(intersect(a,b));
        else
            Analysis.postNoMirrorStats.firstIntentional(dummyIdx, instanceIdx)=numTrials;
        end
        % number of unsuccessful trials
        if Analysis.postNoMirrorStats.trial_len(dummyIdx,instanceIdx,numTrials)==50
            Analysis.postNoMirrorStats.unsuccessful(dummyIdx, instanceIdx)=1;
        end

        instanceIdx=instanceIdx+1;
    end
    dummyIdx=dummyIdx+1;
end



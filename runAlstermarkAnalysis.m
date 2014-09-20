% Runs analysis on Alstermark simulatiosn
% instances = instance IDs
% dummy = number of dummy actions
% numTrials = number of trials each instance was run for
% ratio = ratio of successful trials before recovery
% threshold = number of actions in a successful trial before recovery
function Analysis=alstermarkAnalysis(instances, dummy, numTrials, ratio, threshold)

Analysis.recoveryThreshold=ratio;
Analysis.recoveryHistorySize=5;
Analysis.recoveryThresholdActions=threshold;

% Postlesion with mirror system stats
Analysis.postStats.trial_len=zeros(length(dummy),length(instances),numTrials);
Analysis.postStats.numActions=zeros(length(instances),numTrials);
Analysis.postStats.recoveryTime=zeros(length(dummy),length(instances));
Analysis.postStats.meanRecoveryTime=zeros(length(dummy),1);
Analysis.postStats.stdErrRecoveryTime=zeros(length(dummy),1);

% Postlesion without mirror system stats
Analysis.postNoMirrorStats.trial_len=zeros(length(dummy), length(instances),numTrials);
Analysis.postNoMirrorStats.numActions=zeros(length(instances),numTrials);
Analysis.postNoMirrorStats.recoveryTime=zeros(length(dummy),length(instances));
Analysis.postNoMirrorStats.meanRecoveryTime=zeros(length(dummy),1);
Analysis.postNoMirrorStats.stdErrRecoveryTime=zeros(length(dummy),1);

dummyIdx=1;
% For each number of dummy actions used
for i=dummy
    numActions=9+i;
    instanceIdx=1;
    successful=[];

    % For each instance
    for j=instances

        % Load postlesion with mirror data
        load(['/lab/tmpib/u/jbonaiuto/new/acq/v12/' num2str(i) '/alstermark_postlesion_mirror_' num2str(j) '.mat']);
        
        % Record trial length
        Analysis.postStats.trial_len(dummyIdx,instanceIdx,:)=post.trial_len(1:numTrials);
        
        % Recovery time is initialized to numTrials (maximum recovery time)
        Analysis.postStats.recoveryTime(dummyIdx,instanceIdx)=numTrials;

        % Look for recovery time
        history=zeros(Analysis.recoveryHistorySize,1);
        for k=1:numTrials
            for l=1:Analysis.recoveryHistorySize-1
                history(l)=history(l+1);
            end
          
            % Look at number of actions attempted this trial
            history(Analysis.recoveryHistorySize)=sum(sum(post.x_rec(k,:,:),2));
            %history(Analysis.recoveryHistorySize)=squeeze(sum(sum(post.ar_rec(k,:,:),2),3));
            %history(Analysis.recoveryHistorySize)=post.trial_len(k);

            % look at the fraction of previous trials which were successful in less than recoveryThreshold 
            % actions. recovery is when this fraction is greather than or equal to recoveryThreshold
            if k>=Analysis.recoveryHistorySize && length(find(history<Analysis.recoveryThresholdActions))/Analysis.recoveryHistorySize >= Analysis.recoveryThreshold
                Analysis.postStats.recoveryTime(dummyIdx,instanceIdx)=k-Analysis.recoveryHistorySize+1;
                break;
            end
        end
        
        % Load postlesion without mirror data
        load(['/lab/tmpib/u/jbonaiuto/new/acq/v12/' num2str(i) '/alstermark_postlesion_no_mirror_' num2str(j) '.mat']);

        % Record trial length
        Analysis.postNoMirrorStats.trial_len(dummyIdx,instanceIdx,:)=post.trial_len(1:numTrials);
        
        % Recovery time is initialized to numTrials (maximum recovery time)
        Analysis.postNoMirrorStats.recoveryTime(dummyIdx,instanceIdx)=numTrials;

        % Look for recovery time
        history=zeros(Analysis.recoveryHistorySize,1);
        for k=1:numTrials
            for l=1:Analysis.recoveryHistorySize-1
                history(l)=history(l+1);
            end

            % Look at number of actions attempted this trial
            history(Analysis.recoveryHistorySize)=sum(sum(post.x_rec(k,:,:),2));
            %history(Analysis.recoveryHistorySize)=squeeze(sum(sum(post.ar_rec(k,:,:),2),3));
            %history(Analysis.recoveryHistorySize)=squeeze(post.trial_len(k));

            % look at the fraction of previous trials which were successful in less than recoveryThreshold 
            % actions. recovery is when this fraction is greather than or equal to recoveryThreshold
            if k>=Analysis.recoveryHistorySize && length(find(history<Analysis.recoveryThresholdActions))/Analysis.recoveryHistorySize >= Analysis.recoveryThreshold
                Analysis.postNoMirrorStats.recoveryTime(dummyIdx,instanceIdx)=k-Analysis.recoveryHistorySize+1;
                break;
            end
        end
        instanceIdx=instanceIdx+1;
    end

    % Calculate mean and std err of recovery time for all instances with mirror system
    successful=[1:length(instances)];%find(Analysis.postStats.recoveryTime(dummyIdx,:)<numTrials);
    Analysis.postStats.meanRecoveryTime(dummyIdx)=mean(Analysis.postStats.recoveryTime(dummyIdx,successful));
    Analysis.postStats.stdErrRecoveryTime(dummyIdx)=std(Analysis.postStats.recoveryTime(dummyIdx,successful))/sqrt(length(successful));
        
    % Calculate mean and std err of recovery time for all instances without mirror system
    %successful=find(Analysis.postNoMirrorStats.recoveryTime(dummyIdx,:)<numTrials);
    Analysis.postNoMirrorStats.meanRecoveryTime(dummyIdx)=mean(Analysis.postNoMirrorStats.recoveryTime(dummyIdx,successful));
    Analysis.postNoMirrorStats.stdErrRecoveryTime(dummyIdx)=std(Analysis.postNoMirrorStats.recoveryTime(dummyIdx,successful))/sqrt(length(successful));
    
    dummyIdx=dummyIdx+1;
end

% Plot recovery time data
[m1 b1]=polyfit(dummy,Analysis.postStats.meanRecoveryTime',1);
[m2 b2]=polyfit(dummy,Analysis.postNoMirrorStats.meanRecoveryTime',1);
plot(dummy,m1(1).*dummy+m1(2),'b',dummy,Analysis.postStats.meanRecoveryTime,'bx',dummy,m2(1).*dummy+m2(2),'r',dummy,Analysis.postNoMirrorStats.meanRecoveryTime,'rx')
xlabel('Irrelevant Actions');
ylabel('Mean Recovery Time');
legend('Mirror',['y=' num2str(m1(1)) 'x+' num2str(m1(2))],'No Mirror',['y=' num2str(m2(1)) 'x+' num2str(m2(2))])

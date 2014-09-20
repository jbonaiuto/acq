% Runs the Alstermark simulation with and without reinforcement of apparent
% actions recognized by the mirror system.
% instance - the id of this instance
% dummy - the number of dummy actions available to the model
% debug - debug mode (0 or 1)
function runAlstermarkCondition(instance, dummy, debug)

    % initialize random number generator
    rand('state',sum(100*instance*clock));

    % train the model on the initial task (prelesion)
    %pre=initAlstermark(dummy, 0);
    %pre=runAlstermarkInstance(pre, debug);
    %save(['/lab/tmpib/u/jbonaiuto/new/acq/v12/' num2str(dummy) '/alstermark_prelesion_' num2str(instance) '.mat'], 'pre');
    
    % load pretrained model 
    load alstermark_prelesion_1.mat

    % initialize pretrained model with lesioned grasp-paw schema and mirror 
    % system
    postMirror=initAlstermark(dummy,0);
    postMirror.pf_w(1:9,:,:)=pre.pf_w;
    postMirror.mf_w(1:9,:,:)=pre.mf_w;
    postMirror.bf_w(1:9,:,:)=pre.bf_w;
    postMirror.pb_w(1:9,:,:)=pre.pb_w;
    postMirror.ACQParams.w_is(1:6,1)=pre.ACQParams.w_is(1:6,1);
    postMirror.ACQParams.w_cp(1,1:6)=pre.ACQParams.w_cp(1,1:6);
    postMirror.ACQParams.w_is(7:postMirror.nActions,1)=.05*rand(postMirror.nActions-6,1);
    postMirror.ACQParams.w_cp(1,7:postMirror.nActions)=.05*rand(1,postMirror.nActions-6);
    postMirror.lesion(4)=1.0;
    postMirror.mirror=1;
    % run simulation with pretrained model with lesioned grasp-paw and 
    % mirror system
    post=runAlstermarkInstance(postMirror, debug);
    % save simulation results
    save([num2str(dummy) '/alstermark_postlesion_mirror_' num2str(instance) '.mat'], 'post');

    if debug>0
        figure(2);
        plot(post.trial_len);
        ylim([0 post.L]);
        figure(1);
    end    
    
    % initialize pretrained model with lesioned grasp-paw schema and no 
    % mirror system
    postNoMirror=initAlstermark(dummy,0);
    postNoMirror.pf_w(1:9,:,:)=pre.pf_w;
    postNoMirror.mf_w(1:9,:,:)=pre.mf_w;
    postNoMirror.bf_w(1:9,:,:)=pre.bf_w;
    postNoMirror.pb_w(1:9,:,:)=pre.pb_w;
    postNoMirror.ACQParams.w_is(1:6,1)=pre.ACQParams.w_is(1:6,1);
    postNoMirror.ACQParams.w_cp(1,1:6)=pre.ACQParams.w_cp(1,1:6);
    postNoMirror.ACQParams.w_is(7:postMirror.nActions,1)=.05*rand(postNoMirror.nActions-6,1);
    postNoMirror.ACQParams.w_cp(1,7:postMirror.nActions)=.05*rand(1,postNoMirror.nActions-6);
    postNoMirror.lesion(4)=1.0;
    postNoMirror.mirror=0;
    % run simulation with pretrained model with lesioned grasp-paw and no 
    % mirror system
    post=runAlstermarkInstance(postNoMirror, debug);
    % save simulation results
    save([num2str(dummy) '/alstermark_postlesion_no_mirror_' num2str(instance) '.mat'], 'post');

    if debug>0
        figure(2);
        hold on;
        plot(post.trial_len,'r');
        ylim([0 post.L]);
    end
    


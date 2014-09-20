% Run an instance of the ACQ model in the Alstermark's cat task
% debug - debug level (0=none, 1=output comments and plot desirability, 
% 2=plot mouth, paw, and food locations
function AlstermarkParams=runAlstermarkInstance(AlstermarkParams, debug)

% If debug level greater than 0, plot action desirability
if debug>0
    subplot(2,1,1);
    t_plt=plot([1:1],0);
    xlim([1 AlstermarkParams.trials]); ylim([0 AlstermarkParams.L]);
    subplot(2,1,2);
    d_plt=bar(AlstermarkParams.ACQParams.w_is(:,1));
    xlim([0 AlstermarkParams.nActions]);ylim([0 1]);
end

% Loop over number of trials
for trial=1:AlstermarkParams.trials
    AlstermarkParams.trial=trial;

    if debug>0
        trial
    end

    % Reset network
    AlstermarkParams=resetNetwork(AlstermarkParams);
    
    % Run trial
    % Initialize working memory
    AlstermarkParams.wm=[AlstermarkParams.intState AlstermarkParams.p AlstermarkParams.m AlstermarkParams.f AlstermarkParams.b];

    for t=1:AlstermarkParams.L
        AlstermarkParams.t=t;
    
        % Extract affordances
        AlstermarkParams=affordanceExtraction(AlstermarkParams);
        % Compute executability
        AlstermarkParams.ACQParams.e=executability(AlstermarkParams);
    
        % Get internal state
        AlstermarkParams.ACQParams.is=max(0.0, min(1.0, AlstermarkParams.intState));

        % Compute desirability
        AlstermarkParams.ACQParams.noise=sqrt(AlstermarkParams.ACQParams.sigma_sq_d)*rand(AlstermarkParams.ACQParams.nActions,1);
        AlstermarkParams.ACQParams.d=(AlstermarkParams.ACQParams.w_is*AlstermarkParams.ACQParams.is)+AlstermarkParams.ACQParams.noise;

        % Compute priority
        AlstermarkParams.ACQParams.p=AlstermarkParams.ACQParams.e.*AlstermarkParams.ACQParams.d;

        % Select action
        winner=find(AlstermarkParams.ACQParams.p==max(AlstermarkParams.ACQParams.p));
        if length(winner)==1
            AlstermarkParams.x(winner)=1.0;
            AlstermarkParams.x_rec(AlstermarkParams.trial,t,winner)=1.0;

            % Execute action (only if actually executable)
            AlstermarkParams=motorController(AlstermarkParams, debug);
            cur_action=find(AlstermarkParams.x==1.0);

            % Recognize actions
            AlstermarkParams=actionRecognition(AlstermarkParams, debug);
            rec_action=find(AlstermarkParams.ar>0.75);

            % Compute critic input
            predictorInput=AlstermarkParams.ACQParams.w_cp*max(0.0,min(1.0,AlstermarkParams.ar));

            % Run critics
            AlstermarkParams.CriticParams=runCritics(AlstermarkParams.CriticParams, predictorInput, AlstermarkParams.ACQParams.is, AlstermarkParams.r);

            % Modify desirability weights
            AlstermarkParams=modifyWeights(AlstermarkParams);
            
            % Break if no more drive
            if AlstermarkParams.intState<0.001                
                AlstermarkParams.ar_rec(AlstermarkParams.trial,AlstermarkParams.t,:)=AlstermarkParams.ar;
                AlstermarkParams.t=AlstermarkParams.t+1;
                AlstermarkParams.r=1.0;
                AlstermarkParams.x=zeros(AlstermarkParams.nActions,1);
                actionValues=AlstermarkParams.ACQParams.w_cp*AlstermarkParams.x;
                AlstermarkParams.CriticParams=runCritics(AlstermarkParams.CriticParams, actionValues, AlstermarkParams.ACQParams.is, AlstermarkParams.r);
                AlstermarkParams=modifyWeights(AlstermarkParams);
                AlstermarkParams.successful(AlstermarkParams.trial)=1;
                break
            end

            % Plot mouth, paw, food locations
            if debug==2
                figure(2);
                plot(AlstermarkParams.m(1),AlstermarkParams.m(2),'rx',AlstermarkParams.p(1),AlstermarkParams.p(2),'bx',AlstermarkParams.f(1),AlstermarkParams.f(2),'gx');xlim([0 AlstermarkParams.Vmax]);ylim([0 AlstermarkParams.Vmax]);
                input('');
            end
        end

        % Update working memory
        AlstermarkParams.wm=[AlstermarkParams.intState AlstermarkParams.p AlstermarkParams.m AlstermarkParams.f AlstermarkParams.b];

        % Record network activity
        AlstermarkParams.x=zeros(AlstermarkParams.nActions,1);
        AlstermarkParams=recordActivity(AlstermarkParams); 

        % End if food batted out of bounds
        if AlstermarkParams.f(1)<0 || AlstermarkParams.f(1)>AlstermarkParams.Vmax || AlstermarkParams.f(2)<0.0 || AlstermarkParams.f(2)>AlstermarkParams.Vmax
            AlstermarkParams.x_rec(trial, t,:)
            AlstermarkParams.f
            'out of bounds'
            break
        end

        % If debugging, plot desirability weights
        if debug>0            
            set(d_plt, 'YData', AlstermarkParams.ACQParams.w_is(:,1));
            drawnow();
        end
    end
    if debug>0
        set(t_plt, 'YData', AlstermarkParams.trial_len(1:trial));
        set(t_plt, 'XData', [1:trial]);
        drawnow();
    end
end

% Initialize simulation variables and parameters
% nDummyActions - number of dummy actions available to the model
% training - whether or not initialization is for training the mirror system 
% (0 or 1)
function AlstermarkParams=initAlstermark(nDummyActions, training)

%% Parameters
% Range of visual space (Vmax x Vmax)
AlstermarkParams.Vmax=35.0;

% Size of population codes (Pmax x Pmax)
AlstermarkParams.Pmax=35.0;

% Variance in the population codes
AlstermarkParams.sigma_sq_pop=0.25;

% Variance of the noise in executability components
AlstermarkParams.sigma_sq_exec=0.0;

% Number of perceptions
AlstermarkParams.numPerceptions=6; %hunger, thirst, paw position, mouth position, food position, tube opening

% Number of actions
AlstermarkParams.nActions=9+nDummyActions; % 1=eat, 2=grasp jaws, 3=bring to mouth, 4=grasp paw, 5=reach food, 6=reach tube, 7=rake, 8=drop neck, 9=raise neck, 10...=dummy actions

% Learning rate
AlstermarkParams.alpha=0.1;

% Number of trials
AlstermarkParams.trials=200;

% Length of the action sequence in a trial
AlstermarkParams.L = 50;

% Initialize ACQ
AlstermarkParams.ACQParams=initACQ(AlstermarkParams.nActions, 1);

% Initialize Critics
AlstermarkParams.CriticParams=initCritics(1);

%% Variables
% Internal state
AlstermarkParams.intState=100.0;

% Paw position
AlstermarkParams.p=[0 0];

% Mouth position
AlstermarkParams.m=[0 35];

% Food position
AlstermarkParams.f=[30 30];

% Center of tube opening
AlstermarkParams.b=[5 30];

% Paw-food population code
AlstermarkParams.pf=zeros(AlstermarkParams.Pmax,AlstermarkParams.Pmax);

% Paw-food population - executability weights
AlstermarkParams.pf_w=ones(AlstermarkParams.nActions,AlstermarkParams.Pmax,AlstermarkParams.Pmax);

% Mouth-food population code
AlstermarkParams.mf=zeros(AlstermarkParams.Pmax,AlstermarkParams.Pmax);

% Mouth-food population - executability weights
AlstermarkParams.mf_w=ones(AlstermarkParams.nActions,AlstermarkParams.Pmax,AlstermarkParams.Pmax);

% Tube opening - food population code
AlstermarkParams.bf=zeros(AlstermarkParams.Pmax,AlstermarkParams.Pmax);

% Tube opening - food population - executability weights
AlstermarkParams.bf_w=ones(AlstermarkParams.nActions,AlstermarkParams.Pmax,AlstermarkParams.Pmax);

% Paw-tube opening population code
AlstermarkParams.pb=zeros(AlstermarkParams.Pmax,AlstermarkParams.Pmax);

% Paw-tube opening population - executability weights
AlstermarkParams.pb_w=zeros(AlstermarkParams.nActions,AlstermarkParams.Pmax,AlstermarkParams.Pmax);

% Initialize executability weights
AlstermarkParams=initExecWeights(AlstermarkParams);

% Action output
AlstermarkParams.x=zeros(AlstermarkParams.nActions,1);

% Reward
AlstermarkParams.r=0;

% Perceptual working memory
AlstermarkParams.wm=zeros(1,(AlstermarkParams.numPerceptions-2)*2+1);

% Action recognition output layer
AlstermarkParams.ar=zeros(AlstermarkParams.nActions,1);

% Initialize working memory
AlstermarkParams.wm=[AlstermarkParams.intState AlstermarkParams.p AlstermarkParams.m AlstermarkParams.f AlstermarkParams.b];

% Record action execution attempts
AlstermarkParams.x_rec=zeros(AlstermarkParams.trials,AlstermarkParams.L,AlstermarkParams.nActions);

% Record action recognition
AlstermarkParams.ar_rec=zeros(AlstermarkParams.trials,AlstermarkParams.L,AlstermarkParams.nActions);

% Trial length
AlstermarkParams.trial_len=zeros(1,AlstermarkParams.trials);

% Number of successful actions per trial
AlstermarkParams.successful=zeros(1,AlstermarkParams.trials);

% Number of unsuccessful actions per trial
AlstermarkParams.unsuccessful=zeros(1,AlstermarkParams.trials);

% Lesion
AlstermarkParams.lesion=zeros(AlstermarkParams.nActions,1);

% Mirror system flag
AlstermarkParams.mirror=1;

% Current trial
AlstermarkParams.trial=1;

% Inputs: hunger, d_hunger, m, d_m, mf, d_mf, pf, d_pf, pb, d_pb
% Outputs: eat, grasp jaws, bring to mouth, grasp paw, reach food, reach tube, rake, drop neck, raise neck
AlstermarkParams.training=training;
% If training the mirror system, initialize training data
if training==1
    AlstermarkParams.TrainingData=initTrainingData(20000,12,9);
    AlstermarkParams.currentPattern=1;
% Otherwise load pretrained mirror system connection weights
else
    load 'net.mat'
    AlstermarkParams.ms_net=net;
end

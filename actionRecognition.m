% Action recogntion
% debug = debug level
function AlstermarkParams=actionRecognition(AlstermarkParams, debug)

% Reset output
AlstermarkParams.ar=zeros(AlstermarkParams.nActions,1);

% Compute relative distances and changes in distances between paw, food, tube, and mouth
mf_dist=norm(AlstermarkParams.m-AlstermarkParams.f,2);
mf_dist1d=norm(AlstermarkParams.m(1)-AlstermarkParams.f(1),2);
d_mf_dist=mf_dist-sqrt((AlstermarkParams.wm(4)-AlstermarkParams.wm(6))^2+(AlstermarkParams.wm(5)-AlstermarkParams.wm(7))^2);
d_mf_dist1d=mf_dist1d-sqrt((AlstermarkParams.wm(4)-AlstermarkParams.wm(6))^2);
pf_dist=norm(AlstermarkParams.p-AlstermarkParams.f,2);
d_pf_dist=pf_dist-sqrt((AlstermarkParams.wm(2)-AlstermarkParams.wm(6))^2+(AlstermarkParams.wm(3)-AlstermarkParams.wm(7))^2);
pb_dist=norm(AlstermarkParams.p-AlstermarkParams.b,2);
d_pb_dist=pb_dist-sqrt((AlstermarkParams.wm(2)-AlstermarkParams.wm(8))^2+(AlstermarkParams.wm(3)-AlstermarkParams.wm(9))^2);
hand_tactile=0;
if norm(AlstermarkParams.p-AlstermarkParams.f,2)<.01
    hand_tactile=1;
end
mouth_tactile=0;
if norm(AlstermarkParams.m-AlstermarkParams.f,2)<.01
    mouth_tactile=1;
end

% Set up mirror system input
ms_input=[AlstermarkParams.intState (AlstermarkParams.intState-AlstermarkParams.wm(1)) AlstermarkParams.m(2) (AlstermarkParams.m(2)-AlstermarkParams.wm(5)) mf_dist d_mf_dist pf_dist d_pf_dist pb_dist d_pb_dist hand_tactile mouth_tactile];
ms_input(1:2)=ms_input(1:2)./200+.5;
ms_input(3:10)=ms_input(3:10)./90+.5;

% If training the mirror system
if AlstermarkParams.training==1
    % If action was successful, set training signal
    if AlstermarkParams.successfulAction==1
        AlstermarkParams.ar(find(AlstermarkParams.x==1.0))=1.0;
    end

    % Set training input and output patterns
    if AlstermarkParams.currentPattern<AlstermarkParams.TrainingData.numPatterns
        if length(find(AlstermarkParams.ar==1))==0 || find(AlstermarkParams.x==1)==find(AlstermarkParams.ar==1)
            AlstermarkParams.TrainingData.input_patterns(AlstermarkParams.currentPattern,:)=ms_input;
            AlstermarkParams.TrainingData.output_patterns(AlstermarkParams.currentPattern,:)=AlstermarkParams.ar;

            AlstermarkParams.currentPattern=AlstermarkParams.currentPattern+1;

            if rand<.5
                ms_input([2 4 6 7 10])=0;
                AlstermarkParams.TrainingData.input_patterns(AlstermarkParams.currentPattern,:)=ms_input;
                AlstermarkParams.TrainingData.output_patterns(AlstermarkParams.currentPattern,:)=zeros(size(AlstermarkParams.ar));
                AlstermarkParams.currentPattern=AlstermarkParams.currentPattern+1;
            end
        end
    end
% If not training, run mirror system and get output
else
    if length(find(AlstermarkParams.x==1))>0 && AlstermarkParams.successfulAction>0
        % Mirror system represents intended and apparent action
        AlstermarkParams.ar=[sim(AlstermarkParams.ms_net, ms_input');AlstermarkParams.x(10:AlstermarkParams.nActions)]+AlstermarkParams.x;
    end
end

% If debugging, output recognized action
if debug>0    
    if AlstermarkParams.ar(1)>.6
        'Recognized Eat'
    end
    if AlstermarkParams.ar(2)>.6
        'Recognized Grasp Jaws'
    end
    if AlstermarkParams.ar(3)>.6
        'Recognized Bring to Mouth'
    end
    if AlstermarkParams.ar(4)>.6
        'Recognized Grasp Paw'
    end
    if AlstermarkParams.ar(5)>.6
        'Recognized Reach Food'
    end
    if AlstermarkParams.ar(6)>.6
        'Recognized Reach Tube'
    end
    if AlstermarkParams.ar(7)>.6
        'Recognized Rake'
    end
    if AlstermarkParams.ar(8)>.6
        'Recognized Drop Neck'
    end
    if AlstermarkParams.ar(9)>.6
        'Recognized Raise Neck'
    end
    if length(find(AlstermarkParams.ar(10:AlstermarkParams.nActions)>0.6))>0
        'Recognized Dummy'
    end
end

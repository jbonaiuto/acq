% Generate input and output patterns for training the mirror system
function AlstermarkParams=generateMirrorTrainingData()

AlstermarkParams=initAlstermark(0,1);

% For each action
for i=1:AlstermarkParams.nActions
    % Generate 100 positive examples
    for j=1:100
        % Reset environment
        AlstermarkParams=resetNetwork(AlstermarkParams);
        
        % Eat
        if i==1
            % Neck can be up or down
            if rand<.5
                AlstermarkParams.m(2)=3.0;
            else
                AlstermarkParams.m(2)=AlstermarkParams.Vmax;
            end
            % Paw can be anywhere
            AlstermarkParams.p=round(rand(1,2)*AlstermarkParams.Vmax);
            % Food must be within 1 unit of mouth
            theta=(pi/2+pi/2)*rand-pi/2;
            r=rand;
            AlstermarkParams.f(1)=min(AlstermarkParams.Vmax,round(AlstermarkParams.m(1)+r*cos(theta)));
            AlstermarkParams.f(2)=min(AlstermarkParams.Vmax,round(AlstermarkParams.m(2)+r*sin(theta)));

        % Grasp-Jaws
        elseif i==2
            % Neck can be up or down
            if rand<.5
                AlstermarkParams.m(2)=3.0;
            else
                AlstermarkParams.m(2)=AlstermarkParams.Vmax;
            end
            % Food on floor
            if rand<.5 && AlstermarkParams.m(2)==3.0;
                % Paw can be anywhere
                AlstermarkParams.p=round(rand(1,2)*AlstermarkParams.Vmax);
                % Food on floor and within 5 units of mouth, but greater than 1 unit
                AlstermarkParams.f=[0 round(4*rand+1)];
            % Food in paw
            else
                AlstermarkParams.p=round(AlstermarkParams.m+[5 0]);
                AlstermarkParams.f=AlstermarkParams.p;
            end

        % Bring to Mouth
        elseif i==3
            % Neck can be up or down
            if rand<.5
                AlstermarkParams.m(2)=3.0;
            else
                AlstermarkParams.m(2)=AlstermarkParams.Vmax;
            end
            % Paw can be anywhere
            AlstermarkParams.p=round(rand(1,2)*AlstermarkParams.Vmax);
            % Food must be in paw
            AlstermarkParams.f=AlstermarkParams.p;
        
        % Grasp Paw
        elseif i==4
            % Neck can be up or down
            if rand<.5
                AlstermarkParams.m(2)=3.0;
            else
                AlstermarkParams.m(2)=AlstermarkParams.Vmax;
            end
            % Paw can be anywhere
            AlstermarkParams.p=round(rand(1,2)*AlstermarkParams.Vmax);
            % Food must be within 5 units of paw but greater than 1 unit
            theta=(2*pi-pi)*rand+pi;
            r=(5-1)*rand+1;
            AlstermarkParams.f(1)=min(AlstermarkParams.Vmax,round(AlstermarkParams.p(1)+r*cos(theta)));
            AlstermarkParams.f(2)=min(AlstermarkParams.Vmax,round(AlstermarkParams.p(2)+r*sin(theta)));
        
        % Reach Food
        elseif i==5
            % Neck can be up or down
            if rand<.5
                AlstermarkParams.m(2)=3.0;
            else
                AlstermarkParams.m(2)=AlstermarkParams.Vmax;
            end
            % Food in tube
            if rand<.5
                % Food can be anywhere in tube
                AlstermarkParams.f(1)=round((AlstermarkParams.Vmax-15)*rand+15);
                AlstermarkParams.f(2)=30;
                % Paw must also be in tube
                AlstermarkParams.p(1)=round((AlstermarkParams.Vmax-(AlstermarkParams.b(1)+3))*rand+AlstermarkParams.b(1)+3);
                AlstermarkParams.p(2)=round((AlstermarkParams.Vmax-(AlstermarkParams.b(2)+5))*rand+AlstermarkParams.b(2)+5);
            % Food on ground
            else
                AlstermarkParams.f(1)=round(AlstermarkParams.Vmax*rand);
                AlstermarkParams.f(2)=0.0;
                % Paw can be anywhere
        		AlstermarkParams.p=round(rand(1,2)*AlstermarkParams.Vmax);
            end

        % Reach Tube
        elseif i==6
            % Neck can be up or down
            if rand<.5
                AlstermarkParams.m(2)=3.0;
            else
                AlstermarkParams.m(2)=AlstermarkParams.Vmax;
            end
            % Food can be anywhere
            AlstermarkParams.f=round(rand(1,2)*AlstermarkParams.Vmax);
            % Paw can be anywhere but inside tube
            AlstermarkParams.p=round(rand(1,2).*AlstermarkParams.b);

        % Rake
        elseif i==7
            % Neck can be up or down
            if rand<.5
                AlstermarkParams.m(2)=3.0;
            else
                AlstermarkParams.m(2)=AlstermarkParams.Vmax;
            end
            % Food in tube
            if rand<.5
                % Food can be anywhere in tube
                AlstermarkParams.f(1)=round((AlstermarkParams.Vmax-15)*rand+15);
                AlstermarkParams.f(2)=30;
            % Food on ground
            else
                AlstermarkParams.f(1)=round(AlstermarkParams.Vmax*rand);
                AlstermarkParams.f(2)=0.0;
            end
            % Paw must be above and to the right of food
            %theta=pi/2*rand;
            % Paw must be between 1 and 5 units away from food
            %r=(5-1)*rand+1;
            %AlstermarkParams.p(1)=min(AlstermarkParams.Vmax,round(AlstermarkParams.f(1)+r*cos(theta)));
            %AlstermarkParams.p(2)=min(AlstermarkParams.Vmax,round(AlstermarkParams.f(2)+r*sin(theta)));
            AlstermarkParams.p=round(AlstermarkParams.f+[0 5]);
        % Drop Neck
        elseif i==8
            % Neck must be up
            AlstermarkParams.m(2)=AlstermarkParams.Vmax;
            % Food can be anywhere
            AlstermarkParams.f=round(rand(1,2)*AlstermarkParams.Vmax);
            % Paw can be anywhere
            AlstermarkParams.p=round(rand(1,2)*AlstermarkParams.Vmax);

        % Raise Neck
        elseif i==9
            % Neck must be down
            AlstermarkParams.m(2)=3.0;
            % Food can be anywhere
            AlstermarkParams.f=round(rand(1,2)*AlstermarkParams.Vmax);
            % Paw can be anywhere
            AlstermarkParams.p=round(rand(1,2)*AlstermarkParams.Vmax);

        end

        % Execute action
        AlstermarkParams.x=zeros(AlstermarkParams.nActions,1);
        AlstermarkParams.x(i)=1.0;
        % Initialize working memory
        AlstermarkParams.wm=[AlstermarkParams.intState' AlstermarkParams.p AlstermarkParams.m AlstermarkParams.f AlstermarkParams.b];
        AlstermarkParams=motorController(AlstermarkParams,0);
        % Recognize action and write pattern
        AlstermarkParams=actionRecognition(AlstermarkParams,0);
    end
    % Generate 100 negative examples
    for j=1:100
        % Reset environment
        AlstermarkParams=resetNetwork(AlstermarkParams);
        
        % Eat
        if i==1
            % Neck can be up or down
            if rand<.5
                AlstermarkParams.m(2)=3.0;
            else
                AlstermarkParams.m(2)=AlstermarkParams.Vmax;
            end
            % Paw can be anywhere
            AlstermarkParams.p=round(rand(1,2)*AlstermarkParams.Vmax);
            % Food must be greater than 1 unit from mouth
            theta=2*pi*rand;
            r=(AlstermarkParams.Vmax-1)*rand+1;
            AlstermarkParams.f(1)=min(AlstermarkParams.Vmax,round(AlstermarkParams.m(1)+r*cos(theta)));
            AlstermarkParams.f(2)=min(AlstermarkParams.Vmax,round(AlstermarkParams.m(2)+r*sin(theta)));
        % Grasp-Jaws
        elseif i==2
            % Neck can be up or down
            if rand<.5
                AlstermarkParams.m(2)=3.0;
            else
                AlstermarkParams.m(2)=AlstermarkParams.Vmax;
            end
            % Paw can be anywhere
            AlstermarkParams.p=round(rand(1,2)*AlstermarkParams.Vmax);
            % Food must be greater than 5 units from mouth or in mouth
            if rand<.5
                AlstermarkParams.f=AlstermarkParams.m;
            else
                theta=2*pi*rand;
                r=(AlstermarkParams.Vmax-5)*rand+5;
                AlstermarkParams.f(1)=min(AlstermarkParams.Vmax,round(AlstermarkParams.m(1)+r*cos(theta)));
                AlstermarkParams.f(2)=min(AlstermarkParams.Vmax,round(AlstermarkParams.m(2)+r*sin(theta)));
            end

        % Bring to Mouth
        elseif i==3
            % Neck can be up or down
            if rand<.5
                AlstermarkParams.m(2)=3.0;
            else
                AlstermarkParams.m(2)=AlstermarkParams.Vmax;
            end
            % Paw can be anywhere
            AlstermarkParams.p=round(rand(1,2)*AlstermarkParams.Vmax);
            % Food must not be in paw
            AlstermarkParams.f=min(AlstermarkParams.Vmax,round(AlstermarkParams.p+(1+rand(1,2))));

        % Grasp Paw
        elseif i==4
            % Neck can be up or down
            if rand<.5
                AlstermarkParams.m(2)=3.0;
            else
                AlstermarkParams.m(2)=AlstermarkParams.Vmax;
            end
            % Paw can be anywhere
            AlstermarkParams.p=round(rand(1,2)*AlstermarkParams.Vmax);
            % Food must be greater than 5 units from paw or in paw
            if rand<.5
                AlstermarkParams.f=AlstermarkParams.p;
            else
                theta=2*pi*rand;
                r=(AlstermarkParams.Vmax-5)*rand+5;
                AlstermarkParams.f(1)=min(AlstermarkParams.Vmax,round(AlstermarkParams.p(1)+r*cos(theta)));
                AlstermarkParams.f(2)=min(AlstermarkParams.Vmax,round(AlstermarkParams.p(2)+r*sin(theta)));
            end

        % Reach Food
        elseif i==5
            % Neck can be up or down
            if rand<.5
                AlstermarkParams.m(2)=3.0;
            else
                AlstermarkParams.m(2)=AlstermarkParams.Vmax;
            end
            % Food in tube
            if rand<.5
                % Food can be anywhere in tube
                AlstermarkParams.f(1)=round((AlstermarkParams.Vmax-15)*rand+15);
                AlstermarkParams.f(2)=30;
                % Paw not be in tube
                if rand<.5
                    AlstermarkParams.p=round((AlstermarkParams.b-1).*rand(1,2));
                % Paw already at food
                else
                    AlstermarkParams.p=AlstermarkParams.f+[0 5];
                end
            else
                % Food on ground
                AlstermarkParams.f(1)=round(AlstermarkParams.Vmax*rand);
                AlstermarkParams.f(2)=0.0;
                % Paw already at food
                AlstermarkParams.p=AlstermarkParams.f+[0 5];
            end
        % Reach Tube
        elseif i==6
            % Neck can be up or down
            if rand<.5
                AlstermarkParams.m(2)=3.0;
            else
                AlstermarkParams.m(2)=AlstermarkParams.Vmax;
            end
            % Food can be anywhere
            AlstermarkParams.f=round(rand(1,2)*AlstermarkParams.Vmax);
            % Paw must be in tube
            AlstermarkParams.p=round((AlstermarkParams.Vmax-AlstermarkParams.b).*rand(1,2)+AlstermarkParams.b);

        % Rake
        elseif i==7
            % Neck can be up or down
            if rand<.5
                AlstermarkParams.m(2)=3.0;
            else
                AlstermarkParams.m(2)=AlstermarkParams.Vmax;
            end
            % Food in tube
            if rand<.5
                % Food can be anywhere in tube
                AlstermarkParams.f(1)=round((AlstermarkParams.Vmax-15)*rand+15);
                AlstermarkParams.f(2)=30;
            % Food on ground
            else
                AlstermarkParams.f(1)=round(AlstermarkParams.Vmax*rand);
                AlstermarkParams.f(2)=0.0;
            end
            % Paw must be below or to the left of food
            theta=(2*pi-pi/2)*rand+pi/2;
            % Paw must be between greater than units away from food or on food
            if rand<.5
                r=0;
            else
                r=(AlstermarkParams.Vmax-6)*rand+6;
            end
            AlstermarkParams.p(1)=min(AlstermarkParams.Vmax,round(AlstermarkParams.f(1)+r*cos(theta)));
            %AlstermarkParams.p(1)=min(AlstermarkParams.Vmax,round(AlstermarkParams.f(1)));
            AlstermarkParams.p(2)=min(AlstermarkParams.Vmax,round(AlstermarkParams.f(2)+6));
   
        % Drop Neck
        elseif i==8
            % Neck must be down
            AlstermarkParams.m(2)=3.0;
            % Food can be anywhere
            AlstermarkParams.f=round(rand(1,2)*AlstermarkParams.Vmax);
            % Paw can be anywhere
            AlstermarkParams.p=round(rand(1,2)*AlstermarkParams.Vmax);

        % Raise Neck
        elseif i==9
            % Neck must be up
            AlstermarkParams.m(2)=AlstermarkParams.Vmax;
            % Food can be anywhere
            AlstermarkParams.f=round(rand(1,2)*AlstermarkParams.Vmax);
            % Paw can be anywhere
            AlstermarkParams.p=round(rand(1,2)*AlstermarkParams.Vmax);
        end

        % Execute action
        AlstermarkParams.x=zeros(AlstermarkParams.nActions,1);
        AlstermarkParams.x(i)=1.0;
        % Initialize working memory
        AlstermarkParams.wm=[AlstermarkParams.intState' AlstermarkParams.p AlstermarkParams.m AlstermarkParams.f AlstermarkParams.b];
        AlstermarkParams=motorController(AlstermarkParams,0);
        % Recognize action and write pattern
        AlstermarkParams=actionRecognition(AlstermarkParams,0);

    end
end

AlstermarkParams.TrainingData.input_patterns=AlstermarkParams.TrainingData.input_patterns(1:AlstermarkParams.currentPattern-1,:);
AlstermarkParams.TrainingData.output_patterns=AlstermarkParams.TrainingData.output_patterns(1:AlstermarkParams.currentPattern-1,:);
%AlstermarkParams.TrainingData.input_patterns(:,1:2)=AlstermarkParams.TrainingData.input_patterns(:,1:2)./200+.5;
%AlstermarkParams.TrainingData.input_patterns(:,3:10)=AlstermarkParams.TrainingData.input_patterns(:,3:10)./90+.5;

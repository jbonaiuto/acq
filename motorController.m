% Motor controller
function AlstermarkParams=motorController(AlstermarkParams, debug)
AlstermarkParams.successfulAction=1;

% Eat
% If eat action is attempted and food is in mouth
if AlstermarkParams.x(1)==1.0 && norm(AlstermarkParams.m-AlstermarkParams.f,2)<=1
    if debug>0
        '******* Eat *******'
    end
    % Not hungry anymore
    AlstermarkParams.intState=0.0;

% Grasp jaws
% If grasp jaws is attempted and food is close to mouth but not in mouth
elseif AlstermarkParams.x(2)==1.0 && norm(AlstermarkParams.m-AlstermarkParams.f,2)<=5.0 && norm(AlstermarkParams.m-AlstermarkParams.f,2)>0.1
    if debug>0
        'Grasp jaws'
    end
    % Food is now in mouth
    AlstermarkParams.f=AlstermarkParams.m;

% Bring to mouth
% If bring to mouth is attempted, food is in paw, and food is not already close to mouth
elseif AlstermarkParams.x(3)==1.0 && norm(AlstermarkParams.p-AlstermarkParams.f,2)==0.0 && norm(AlstermarkParams.m-AlstermarkParams.f,2)>5.0
    if debug>0
        'Bring to mouth'
    end
    % Paw and food are now close to mouth
    AlstermarkParams.p=round(AlstermarkParams.m+[5 0]);
    AlstermarkParams.f=AlstermarkParams.p;

% Grasp paw
% If grasp paw is attempted and food is not already in paw but is close enough to the paw to grasp
elseif AlstermarkParams.x(4)==1.0 && norm(AlstermarkParams.p-AlstermarkParams.f,2)>0.0 && norm(AlstermarkParams.p-AlstermarkParams.f,2)<=5.0
    if debug>0
        'Grasp paw'
    end
    % If not lesioned, food is now in paw
    if AlstermarkParams.lesion(4)==0.0        
        if AlstermarkParams.p(2)>AlstermarkParams.Vmax
            AlstermarkParams.p(2)=AlstermarkParams.Vmax;
        end
        AlstermarkParams.f=AlstermarkParams.p;
    % If lesioned
    else
        % Put paw above food
        AlstermarkParams.p=round(AlstermarkParams.f+[0 5]);
        % Random displacement with tendency towards cat
        displacement=10*(2*rand-1.5);
        % Move food by displacement amount
        AlstermarkParams.f(1)=round(AlstermarkParams.f(1)+displacement);
        % Food fell out of tube
        if AlstermarkParams.f(2)==AlstermarkParams.b(2) && AlstermarkParams.f(1)<AlstermarkParams.b(1)
            AlstermarkParams.f(2)=0.0;
	    end
        % Food can't move beyond zero or Vmax in horizontal plane
        AlstermarkParams.f(1)=min(AlstermarkParams.Vmax,max(0.0,AlstermarkParams.f(1)));
        % If displaced toward cat, put paw above food
        if displacement<0
            AlstermarkParams.p=round(AlstermarkParams.f+[0 5]);
        end
    end

% Reach food
% If reach food attempted, food is not already close enough to grasp but within reach, and if the food is in the tube then the paw must also already be in the tube
elseif AlstermarkParams.x(5)==1.0 && norm(AlstermarkParams.p-AlstermarkParams.f,2)>5.0 && norm(AlstermarkParams.p-AlstermarkParams.f,2)<100.0 && (AlstermarkParams.f(2)==0.0 || (AlstermarkParams.p(1)>AlstermarkParams.b(1) && AlstermarkParams.p(2)>=AlstermarkParams.b(2)))
    if debug>0
        'Reach food'
    end
    % Paw is now close enough to food to grasp it
    AlstermarkParams.p=round(AlstermarkParams.f+[0 5]);

% Reach tube
% If reach tube attempted and paw is not already in tube
elseif AlstermarkParams.x(6)==1.0 && (AlstermarkParams.p(1)<AlstermarkParams.b(1) || AlstermarkParams.p(2)<AlstermarkParams.b(2))
    if debug>0
        'Reach tube'
    end
    old_p=AlstermarkParams.p;
    % Put paw in tube
    AlstermarkParams.p=round(AlstermarkParams.b+[3 5]);
    % If food was grasped in paw, move it to still be in the paw in the new position
    if AlstermarkParams.f==old_p
        AlstermarkParams.f=AlstermarkParams.p;
    end

% Rake
% If rake attempted, food is not already in the paw but close enough to grasp, food is not already at feet, and paw is above and at or beyond location of food
elseif AlstermarkParams.x(7)==1.0 && norm(AlstermarkParams.p-AlstermarkParams.f,2)>0.0 && norm(AlstermarkParams.p-AlstermarkParams.f,2)<=5.0 && AlstermarkParams.p(2)>AlstermarkParams.f(2) && AlstermarkParams.p(1)>=AlstermarkParams.f(1) && AlstermarkParams.f(1)>1
    if debug>0
        'Rake'
    end
    % Food is now close to cat
    AlstermarkParams.f(2)=0.0;
    AlstermarkParams.f(1)=1.0;
    % Paw is above food
    AlstermarkParams.p=round(AlstermarkParams.f+[1 3]);

% Drop neck
% If drop neck attempted and neck is raised
elseif AlstermarkParams.x(8)==1.0 && AlstermarkParams.m(2)>3.0
    if debug>0
        'Drop neck'
    end
    old_m=AlstermarkParams.m;
    % Neck is lowered
    AlstermarkParams.m(2)=3.0;
    % If food was grasped in jaws, move it to still be in the mouth in the new position
    if AlstermarkParams.f==old_m
        AlstermarkParams.f=AlstermarkParams.m;
    end

% Raise neck
% If raise neck attempted and neck is lowered
elseif AlstermarkParams.x(9)==1.0 && AlstermarkParams.m(2)<AlstermarkParams.Vmax
    if debug>0
        'Raise neck'
    end
    old_m=AlstermarkParams.m;
    % Neck is now raised
    AlstermarkParams.m(2)=AlstermarkParams.Vmax;
    % If food was grasped in jaws, move it to still be in the mouth in the new position
    if AlstermarkParams.f==old_m
        AlstermarkParams.f=AlstermarkParams.m;
    end

% Dummy
% If dummy action was attempted - no preconditions
elseif find(AlstermarkParams.x==1.0)>9
    if debug>0
        'Dummy'
    end

% No action attempted
else
    AlstermarkParams.successfulAction=-1;
end

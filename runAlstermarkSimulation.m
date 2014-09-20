% Runs Alstermark simulation - each instance will be run with each number of dummy actions
% instances = IDs of instances to run
% dummy = number of dummy actions to use
function runAlstermark(instances, dummy)

     all_instances=zeros(1,length(instances)*length(dummy));
     all_dummy=zeros(1,length(instances)*length(dummy));
     for i=1:length(dummy)
          for j=1:length(instances)
                all_instances((i-1)*length(instances)+j)=instances(j);
                all_dummy((i-1)*length(instances)+j)=dummy(i);
          end
     end
     p=pecon({'ibeo','ibeo','ibeo','ibeo','ibeo','ibeo',});
     x=feval(p,@runAlstermarkCondition,num2cell(all_instances),num2cell(all_dummy),num2cell(zeros(1,length(instances)*length(dummy))));
     halt(p);
     quit;


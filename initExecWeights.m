% Rough initialization of executability weights
function AlstermarkParams=initExecWeights(AlstermarkParams)

center=[AlstermarkParams.Vmax/2 AlstermarkParams.Vmax/2]';
for x=1:AlstermarkParams.Vmax
    for y=1:AlstermarkParams.Vmax
        real_x_dist=(x/(AlstermarkParams.Pmax/AlstermarkParams.Vmax)-AlstermarkParams.Vmax/2)*2;
        real_y_dist=(y/(AlstermarkParams.Pmax/AlstermarkParams.Vmax)-AlstermarkParams.Vmax/2)*2;
        %dist=sqrt(sum((pos-center).^2));
        dist=sqrt(real_x_dist^2+real_y_dist^2);
        if dist <= 6
            AlstermarkParams.mf_w(2,x,y)=4.0;
            AlstermarkParams.mf_w(3,x,y)=-5.0;
            
            if dist <= 2
                AlstermarkParams.mf_w(1,x,y)=4.0;
		AlstermarkParams.pf_w(3,x,y)=4.0;
                AlstermarkParams.pf_w(4,x,y)=-5.0;
            else
                AlstermarkParams.mf_w(1,x,y)=-5.0;
		AlstermarkParams.pf_w(3,x,y)=-5.0;
                AlstermarkParams.pf_w(4,x,y)=4.0;
            end
        else
            AlstermarkParams.mf_w(1,x,y)=-5.0;
            AlstermarkParams.mf_w(2,x,y)=-5.0;
            AlstermarkParams.mf_w(3,x,y)=4.0;
	    AlstermarkParams.pf_w(3,x,y)=-5.0;
            AlstermarkParams.pf_w(4,x,y)=-5.0;
        end
        
    end
end
AlstermarkParams.mf_w(2,round(AlstermarkParams.Vmax/2),round(AlstermarkParams.Vmax/2))=-5.0;

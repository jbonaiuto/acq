% Extract action affordances from external input
function AlstermarkParams=affordanceExtraction(AlstermarkParams)

% Reset population codes
AlstermarkParams.pf=zeros(AlstermarkParams.Pmax,AlstermarkParams.Pmax);
AlstermarkParams.mf=zeros(AlstermarkParams.Pmax,AlstermarkParams.Pmax);
AlstermarkParams.bf=zeros(AlstermarkParams.Pmax,AlstermarkParams.Pmax);
AlstermarkParams.pb=zeros(AlstermarkParams.Pmax,AlstermarkParams.Pmax);

% Scale input
pf_x_scaled=round(((AlstermarkParams.f(1)-AlstermarkParams.p(1))/2+AlstermarkParams.Vmax/2)*AlstermarkParams.Pmax/AlstermarkParams.Vmax);
pf_y_scaled=round(((AlstermarkParams.f(2)-AlstermarkParams.p(2))/2+AlstermarkParams.Vmax/2)*AlstermarkParams.Pmax/AlstermarkParams.Vmax);
mf_x_scaled=round(((AlstermarkParams.f(1)-AlstermarkParams.m(1))/2+AlstermarkParams.Vmax/2)*AlstermarkParams.Pmax/AlstermarkParams.Vmax);
mf_y_scaled=round(((AlstermarkParams.f(2)-AlstermarkParams.m(2))/2+AlstermarkParams.Vmax/2)*AlstermarkParams.Pmax/AlstermarkParams.Vmax);
bf_x_scaled=round(((AlstermarkParams.f(1)-AlstermarkParams.b(1))/2+AlstermarkParams.Vmax/2)*AlstermarkParams.Pmax/AlstermarkParams.Vmax);
bf_y_scaled=round(((AlstermarkParams.f(2)-AlstermarkParams.b(2))/2+AlstermarkParams.Vmax/2)*AlstermarkParams.Pmax/AlstermarkParams.Vmax);
pb_x_scaled=round(((AlstermarkParams.b(1)-AlstermarkParams.p(1))/2+AlstermarkParams.Vmax/2)*AlstermarkParams.Pmax/AlstermarkParams.Vmax);
pb_y_scaled=round(((AlstermarkParams.b(2)-AlstermarkParams.p(2))/2+AlstermarkParams.Vmax/2)*AlstermarkParams.Pmax/AlstermarkParams.Vmax);

AlstermarkParams.pf(min(AlstermarkParams.Pmax,max(1.0,pf_x_scaled)),min(AlstermarkParams.Pmax,max(1.0,pf_y_scaled)))=1.0;
AlstermarkParams.mf(min(AlstermarkParams.Pmax,max(1.0,mf_x_scaled)),min(AlstermarkParams.Pmax,max(1.0,mf_y_scaled)))=1.0;
AlstermarkParams.bf(min(AlstermarkParams.Pmax,max(1.0,bf_x_scaled)),min(AlstermarkParams.Pmax,max(1.0,bf_y_scaled)))=1.0;
AlstermarkParams.pb(min(AlstermarkParams.Pmax,max(1.0,pb_x_scaled)),min(AlstermarkParams.Pmax,max(1.0,pb_y_scaled)))=1.0;

% Activity is population code of input
if AlstermarkParams.sigma_sq_pop>0.0
    gaussKern=fspecial('gaussian',AlstermarkParams.Pmax,sqrt(AlstermarkParams.sigma_sq_pop));
    AlstermarkParams.pf=imfilter(AlstermarkParams.pf,gaussKern,'replicate');
    AlstermarkParams.mf=imfilter(AlstermarkParams.mf,gaussKern,'replicate');
    AlstermarkParams.bf=imfilter(AlstermarkParams.bf,gaussKern,'replicate');
    AlstermarkParams.pb=imfilter(AlstermarkParams.pb,gaussKern,'replicate');
    AlstermarkParams.pf=AlstermarkParams.pf.*1/max(max(AlstermarkParams.pf));
    AlstermarkParams.mf=AlstermarkParams.mf.*1/max(max(AlstermarkParams.mf));
    AlstermarkParams.bf=AlstermarkParams.bf.*1/max(max(AlstermarkParams.bf));
    AlstermarkParams.pb=AlstermarkParams.pb.*1/max(max(AlstermarkParams.pb));
end

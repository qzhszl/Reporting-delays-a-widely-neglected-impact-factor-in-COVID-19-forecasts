clear,clc 
%SIRD model-sampling-based sensitivity analysis
% this .m generates 5 SIRD epidemic model datasets and added synthetic reported delays to obtained times series
% With the generated dataset with delays, the inferred model is executed to recover the
% generated SIRD model data without delays
%--------------------------------------------------------------------------
% Generate an SIRD model, beta is the infection rate
% gammar is the recovery rate and gammam is the deseased rate
rng(11)
beta=0.5;
gammar=0.2;
gammam=0.05;
N=1;
tspan=0:0.1:100;
y0=[99990/100000,10/100000,0,0];
[t,y]=ode45(@(t,y) odefcn(y,N,beta,gammar,gammam),tspan,y0);
maker_idx = 1:10:length(t);

% Daily reported: 10 timeslot in the generated SIRD model are regarded as one day.
% Obtain daily increased I,R,D as  I_daily, R_daily and D_daily
y_daily=y(maker_idx,:);
I_daily=zeros(101,1);
R_daily=zeros(101,1);
D_daily=zeros(101,1);
R_daily(1)=y_daily(1,3);
D_daily(1)=y_daily(1,4);
I_daily(1)=y_daily(1,2);
for ki=1:100
    R_daily(ki+1)=y_daily(ki+1,3)-y_daily(ki,3);
    D_daily(ki+1)=y_daily(ki+1,4)-y_daily(ki,4);
    I_daily(ki+1)=y_daily(ki+1,2)-y_daily(ki,2)+R_daily(ki)+D_daily(ki);
end

%random data 
trueparameters = zeros(5,6);
saverandomnb = zeros(5,10);

% 1:5
for knum = 1:5
    %reported data
    targetini = -1;
    
    % Add synthetic reporting delays which are generated with the Pólya-Aeppli distributions
    p_D=rand();
    p_I=rand();
    p_R=rand();
    mD=1*rand();
    mI= mD + 15*rand();
    mR= mD + 15*rand();
    r_D=mD*(p_D);
    r_I=mI*(p_I);
    r_R=mR*(p_R);

    trueparameters(knum,1) = p_D;
    trueparameters(knum,2) = p_I;
    trueparameters(knum,3) = p_R;
    trueparameters(knum,4) = r_D;
    trueparameters(knum,5) = r_I;
    trueparameters(knum,6) = r_R;

    % p_D=0.6574;
    % p_I=0.1632;
    % p_R=0.0553;
    % r_D=0.1713;
    % r_I=1.0803;
    % r_R=1.2673;

    L1=100;
    x = 0:L1;

    P_D=polyapdf(x,r_D,p_D);
    P_I=polyapdf(x,r_I,p_I);
    P_R=polyapdf(x,r_R,p_R);

    I_daily2=zeros(101,1); % Daily I,R,D with delays
    R_daily2=zeros(101,1);
    D_daily2=zeros(101,1);
    for ki=1:101
        for kk=1:ki
            if ki-kk+1>0
               I_daily2(ki)=I_daily2(ki)+P_I(1,kk)*I_daily(ki-kk+1);
               R_daily2(ki)=R_daily2(ki)+P_R(1,kk)*R_daily(ki-kk+1);
               D_daily2(ki)=D_daily2(ki)+P_D(1,kk)*D_daily(ki-kk+1);
            end
        end
    end

    % Uncover reporting delays 
    for numi=1:10^7
        %generate candidate parameters   
        %There are three delay distributions (infection, recovery and death)
        %There are two parameters in each distribution.  Thus there are in
        %total 6 parameters 

        p_D=rand();
        p_I=rand();
        p_R=rand();
        mD=30*rand();
        mI=30*rand();
        mR=30*rand();
        r_D=mD*(p_D);
        r_I=mI*(p_I);
        r_R=mR*(p_R);

    %     saverandomnb(numi,1)=p_D;
    %     saverandomnb(numi,2)=p_I;
    %     saverandomnb(numi,3)=p_R;
    %     saverandomnb(numi,4)=r_D;
    %     saverandomnb(numi,5)=r_I;
    %     saverandomnb(numi,6)=r_R;

        P_D=polyapdf(x,r_D,p_D);
        P_I=polyapdf(x,r_I,p_I);
        P_R=polyapdf(x,r_R,p_R);

        %Wuhan_Death
        vectorDrep=hubei_death0';
        matrixD=zeros(L1+1,L1+1);

        for km=1:L1+1
            for kn=1:km
                eta=kn-1;
                if km-eta>=0
                   matrixD(km,km-eta)=P_D(1,kn);
                end
            end
        end

        vectorDreal=matrixD\vectorDrep;

        %Wuhan infections
        vectorIrep=hubei_infected0';
        matrixI=zeros(L1+1,L1+1);

        for km=1:L1+1
            for kn=1:km
                eta=kn-1;
                if km-eta>=0
                   matrixI(km,km-eta)=P_I(1,kn);
                end
            end
        end

        vectorIreal=matrixI\vectorIrep;

        %wuhan recovery
        vectorRrep=hubei_recovered0';
        matrixR=zeros(L1+1,L1+1);

        for km=1:L1+1
            for kn=1:km
                eta=kn-1;
                if km-eta>=0
                   matrixR(km,km-eta)=P_R(1,kn);
                end
            end
        end

        vectorRreal=matrixR\vectorRrep;

        wuhan_infected=vectorIreal';
        wuhan_recovered=vectorRreal';
        wuhan_death=vectorDreal';

        %get accumulative data
        acwuhaninf=zeros(1,length(wuhan_infected));
        acwuhanrec=zeros(1,length(wuhan_infected));
        acwuhandea=zeros(1,length(wuhan_infected));
        for ki=1:length(wuhan_infected)
            acwuhaninf(1,ki)=sum(wuhan_infected(1:ki));
            acwuhanrec(1,ki)=sum(wuhan_recovered(1:ki));
            acwuhandea(1,ki)=sum(wuhan_death(1:ki));
        end

        Iwuhan = acwuhaninf - acwuhanrec - acwuhandea;
        if length(find(Iwuhan<0))>0||length(find(wuhan_recovered<0))>0||length(find(wuhan_death<0))>0||length(find(wuhan_infected<0))>0
           numi
    %     elseif sum(wuhan_infected)<sum(hubei_infected0)||sum(wuhan_recovered)<sum(hubei_recovered0)||sum(wuhan_death)<sum(hubei_death0)
    %         saverandomnb(numi,7)=nan;
        else
            % infection-recovery
            [R1,P1] = corrcoef(Iwuhan(1:end-1),wuhan_recovered(2:end));
            %infection-death
            [R4,P4] = corrcoef(Iwuhan(1:end-1),wuhan_death(2:end));
            % recovery-death
            [R2,P2] = corrcoef(wuhan_recovered,wuhan_death);
            
            if R1(1,2)*R4(1,2)*R2(1,2)>targetini
                targetini = R1(1,2)*R4(1,2)*R2(1,2);
                saverandomnb(knum,1)=p_D;
                saverandomnb(knum,2)=p_I;
                saverandomnb(knum,3)=p_R;
                saverandomnb(knum,4)=r_D;
                saverandomnb(knum,5)=r_I;
                saverandomnb(knum,6)=r_R;          
                saverandomnb(knum,7)=targetini;
                saverandomnb(knum,8)=R1(1,2);
                saverandomnb(knum,9)=R4(1,2);
                saverandomnb(knum,10)=R2(1,2);
            end
        end
    end
end
save saverandomnb saverandomnb   % The inferred correspongding parameters of the added P-A distribution delays ; target function(product of the Pearson correlation coefficent between Iexist, Rdaliy and D daliy) value of the reconstructed data; Pearson correlation coefficent between Iexist, Rdaliy and D daliy 
save trueparameters trueparameters % The correspongding parameters of the added P-A distribution delays (the one we added)

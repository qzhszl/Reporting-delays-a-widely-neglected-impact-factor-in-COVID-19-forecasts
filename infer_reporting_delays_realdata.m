clear
clc
% this .m Uncover reporting delay in real data(e.g. Spain)
% Input is the number of daily infected, recovered and deceased case
% Output is the inferred delay parameters
% ----------------------------------------------------------------------

%new confirmed data for Spain
spain_infected0=xlsread('i_cnov.xlsx'); %number of daily infected cases 
spain_recovered0=xlsread('r_cnov.xlsx'); %number of daily recovered cases
spain_death0=xlsread('d_cnov.xlsx');     %number of daily deceased cases

%smooth curve
spain_infected0=smoothdata(spain_infected0);
spain_recovered0=smoothdata(spain_recovered0);
spain_death0=smoothdata(spain_death0);

%add 60 days zeros before recorded data
%(since the cases may offer before the first day that the cases reported)
initialv=zeros(1,60);
spain_infected0=[initialv spain_infected0];
spain_recovered0=[initialv spain_recovered0];
spain_death0=[initialv spain_death0];

L1=length(spain_recovered0)-1;
x = 0:L1;

saverandomnb=zeros(10^7,10); %save the data

h=0;
for numi=1:10^7
    numi
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
    
    %save the 6 parameters of delay distributions
    saverandomnb(numi,1)=p_D;
    saverandomnb(numi,2)=p_I;
    saverandomnb(numi,3)=p_R;
    saverandomnb(numi,4)=r_D;
    saverandomnb(numi,5)=r_I;
    saverandomnb(numi,6)=r_R;
                        
    P_D=polyapdf(x,r_D,p_D); %Pólya–Aeppli distribution
    P_I=polyapdf(x,r_I,p_I); %Pólya–Aeppli distribution
    P_R=polyapdf(x,r_R,p_R); %Pólya–Aeppli distribution

    %Death (delay distribution)
    vectorDrep=spain_death0';
    matrixD=zeros(L1+1,L1+1);

    for km=1:L1+1
        for kn=1:km
            eta=kn-1;
            if km-eta>=0
               matrixD(km,km-eta)=P_D(1,kn);
            end
        end
    end 
    %obtain the data with no delay
    vectorDreal=matrixD\vectorDrep;

    %infections (delay distribution)
    vectorIrep=spain_infected0';
    matrixI=zeros(L1+1,L1+1);

    for km=1:L1+1
        for kn=1:km
            eta=kn-1;
            if km-eta>=0
               matrixI(km,km-eta)=P_I(1,kn);
            end
        end
    end
    %obtain the data with no delay
    vectorIreal=matrixI\vectorIrep;

    %recovery (delay distribution)
    vectorRrep=spain_recovered0';
    matrixR=zeros(L1+1,L1+1);

    for km=1:L1+1
        for kn=1:km
            eta=kn-1;
            if km-eta>=0
               matrixR(km,km-eta)=P_R(1,kn);
            end
        end
    end
    %obtain the data with no delay
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

    Iwuhan = acwuhaninf - acwuhanrec - acwuhandea;%get the cumulative fractions

    if length(find(wuhan_recovered<0))>15||length(find(wuhan_death<0))>15||length(find(Iwuhan<0))>15||length(find(wuhan_infected<0))>15
        saverandomnb(numi,:)=nan;
    else
        %calculate the correlation coefficients
        % recovery-death
        [R1,P1] = corrcoef(wuhan_death,wuhan_recovered);
        % infection-recovery
        [R2,P2] = corrcoef(Iwuhan(1:end-1),wuhan_recovered(2:end));
        %infection-death
        [R3,P3] = corrcoef(Iwuhan(1:end-1),wuhan_death(2:end));                         
        saverandomnb(numi,7)=R1(1,2)*R2(1,2)*R3(1,2);
        saverandomnb(numi,8)=R1(1,2);
        saverandomnb(numi,9)=R2(1,2);
        saverandomnb(numi,10)=R3(1,2);
    end   
end

save saverandomnb saverandomnb

saverandomnb(saverandomnb<=0)=nan;
%find the delay parameters that corresponds with the largest correlation coefficients
[maxval,maxidx]=max(saverandomnb(:,7));
A=saverandomnb(maxidx,:);
%inferred delay parameters
a=[A(1),A(2),A(3),A(4),A(5),A(6)]
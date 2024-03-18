function dydt=odefcn(y,N,beta,gammar,gammam)

%   dydt=odefcn(y,N,beta,gammar,gammam) returns the differential equations of an SIRD epidemic model 
%   The input N is a normalized parameter(default N = 1), beta is the infection rate
%   gammar is the recovery rate and gammam is the deseased rate
%   example: [t,y]=ode45(@(t,y) odefcn(y,N,beta,gammar,gammam),tspan,y0);


dydt=zeros(4,1);
dydt(1)=-beta*y(2)*y(1)/N;
dydt(2)=beta*y(2)*y(1)/N-gammar*y(2)-gammam*y(2);
dydt(3)=gammar*y(2);
dydt(4)=gammam*y(2);

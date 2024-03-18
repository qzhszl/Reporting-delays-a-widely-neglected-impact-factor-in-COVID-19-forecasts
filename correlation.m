clear
clc
% Plot reproted I, delta R and delta D with the change of Day.


% load data
% -------------------------------------------------------------------------
% %new confirmed data from Jan.10th to Mar.7th
% wuhan_infected=xlsread('China.xlsx','wuhan_infected');
% wuhan_recovered=xlsread('China.xlsx','wuhan_recovered');
% wuhan_death=xlsread('China.xlsx','wuhan_death');
% hubei_infected=xlsread('China.xlsx','hubei_infected');
% hubei_recovered=xlsread('China.xlsx','hubei_recovered');
% hubei_death=xlsread('China.xlsx','hubei_death');
% out_hubei_infected=xlsread('China.xlsx','out_hubei_infected');
% out_hubei_recovered=xlsread('China.xlsx','out_hubei_recovered');
% out_hubei_death=xlsread('China.xlsx','out_hubei_death');

% spain_infected=xlsread('i_cnov.xlsx');
% spain_recovered=xlsread('r_cnov.xlsx');
% spain_death=xlsread('d_cnov.xlsx');

spain_infected=xlsread('Idelay.xlsx');   %  reproted I
spain_recovered=xlsread('Rdelay.xlsx');  %  reproted delta R
spain_death=xlsread('Ddelay.xlsx');      %  reproted delta D
L=length(spain_infected);


Ispain = spain_infected;
txisx2=1:length(spain_infected)-1;
subplot(1,2,1)
y7 = Ispain(1:length(spain_infected)-1)./1;
g7=plot(txisx2,0.01*y7,'-','color',[0, 0, 0],'LineWidth',2.5);
A=Ispain(1:length(spain_infected)-1);
[p7,v7]=max(A)
line([v7,v7],[10^(-8),10^(-2)])
hold on
g8=plot(txisx2,0.01*spain_recovered(2:length(spain_infected))./1,'-','color',[0, 0.4, 1],'LineWidth',2.5);
A=spain_recovered(2:length(spain_infected));
[p8,v8]=max(A)
line([v8,v8],[10^(-8),10^(-2)])
hold on
g9=plot(txisx2,0.01*spain_death(2:length(spain_infected))./1,'-','color',[1, 0.3, 0],'LineWidth',2.5);
A=spain_death(2:length(spain_infected));
[p9,v9]=max(A)
line([v9,v9],[10^(-8),10^(-2)])
% legend([g1,g2,g3,g7,g4,g5,g6,g8],'$I(t)$ in Wuhan','$I(t)$ in Hubei','$I(t)$ out of Hubei','$I(t)$ in South Korea','$R_{rep}(t+1)$ in Wuhan','$R_{rep}(t+1)$ in Hubei','$R_{rep}(t+1)$ out of Hubei','$R_{rep}(t+1)$ in South Korea','interpreter','latex','fontsize',16,'fontname','Times New Roman');
set(gca,'linewidth',1.0,'fontsize',28,'fontname','Times New Roman');
set(gca, 'YScale', 'log')
xlim([0 80])
xlabel('$t$','interpreter','latex','FontSize',28);
ylabel('Fraction','interpreter','latex', 'FontSize', 28);
% print('Piccorrelation.eps','-depsc','-r600')


% subplot(1,2,2)
% h1=plot(txisx,Iwuhan(1:length(wuhan_infected)-1)./10607700,'-','color',[1, 0, 0],'LineWidth',2.5);
% hold on
% h2=plot(txisx,Ihubei(1:length(wuhan_infected)-1)./58438200,'-','color',[0, 0, 0],'LineWidth',2.5);
% hold on
% h3=plot(txisx,Iouhub(1:length(wuhan_infected)-1)./183795300,'-','color',[0, 0.4, 1],'LineWidth',2.5);
% hold on
% h4=plot(txisx,wuhan_death(2:length(wuhan_infected))./10607700,'--','color',[1, 0, 0],'LineWidth',2.5);
% A=wuhan_death(2:length(wuhan_infected));
% [p9,v9]=max(A)
% hold on
% h5=plot(txisx,hubei_death(2:length(wuhan_infected))./58438200,'--','color',[0, 0, 0],'LineWidth',2.5);
% A=hubei_death(2:length(wuhan_infected));
% [p10,v10]=max(A)
% hold on
% h6=plot(txisx,out_hubei_death(2:length(wuhan_infected))./183795300,'--','color',[0, 0.4, 1],'LineWidth',2.5);
% hold on
% h7=plot(txisx2,Ispain(1:length(spain_infected)-1)./46940000,'-','color',[0, 1, 0],'LineWidth',2.5);
% hold on
% h8=plot(txisx2,spain_death(2:length(spain_infected))./46940000,'--','color',[0, 1, 0],'LineWidth',2.5);
% legend([h4,h5,h6,h8],'$D_{rep}(t+1)$ in Wuhan','$D_{rep}(t+1)$ in Hubei','$D_{rep}(t+1)$ out of Hubei','$D_{rep}(t+1)$ in South Korea','interpreter','latex','fontsize',16,'fontname','Times New Roman');
% set(gca,'linewidth',1.0,'fontsize',28,'fontname','Times New Roman');
% set(gca, 'YScale', 'log')
% xlabel('$t$','interpreter','latex','FontSize',28);
% ylabel('Fraction','interpreter','latex', 'FontSize', 28);

% %correlation recovery
% %delay x; earlier y
% correlationdelayWHrec=zeros(15,8);%wuhan
% correlationdelayHBrec=zeros(15,8);%hubei
% correlationdelayOHrec=zeros(15,8);%out of hubei
% correlationdelaySKrec=zeros(15,8);%korea
% 
% 
% correlationdelayWHdea=zeros(15,8);%wuhan
% correlationdelayHBdea=zeros(15,8);%hubei
% 
% %corresponding p values
% pvaluedelayWHrec=zeros(15,8);
% pvaluedelayHBrec=zeros(15,8);
% pvaluedelayOHrec=zeros(15,8);
% pvaluedelaySKrec=zeros(15,8);
% 
% pvaluedelayWHdea=zeros(15,8);
% pvaluedelayHBdea=zeros(15,8);
% 
% for delay=0:14  %time difference between inf and rec
%     for early=0:7 %time difference between inf and die
%         Iwuhan = acwuhaninf((1+early):(58-delay)) - acwuhanrec((1+early+delay):58) - acwuhandea(1:(58-delay-early));
%         Ihubei = achubeiinf((1+early):(58-delay)) - achubeirec((1+early+delay):58) - achubeidea(1:(58-delay-early));
%         Iouhub = acouhubinf((1+early):(58-delay)) - acouhubrec((1+early+delay):58) - acouhubdea(1:(58-delay-early));   
%         Ikorea = ackoreainf((1+early):(L-delay)) - ackorearec((1+early+delay):L) - ackoreadea(1:(L-delay-early));
%         % infection-recovery
%         [R1,P1] = corrcoef(Iwuhan(1:length(Iwuhan)-1),wuhan_recovered((2+delay+early):58));
%         correlationdelayWHrec(delay+1,early+1)=R1(1,2);
%         pvaluedelayWHrec(delay+1,early+1)=P1(1,2);
%         [R2,P2] = corrcoef(Ihubei(1:length(Ihubei)-1),hubei_recovered((2+delay+early):58));
%         correlationdelayHBrec(delay+1,early+1)=R2(1,2);
%         pvaluedelayHBrec(delay+1,early+1)=P2(1,2);        
%         [R3,P3] = corrcoef(Iouhub(1:length(Iwuhan)-1),out_hubei_recovered((2+delay+early):58));
%         correlationdelayOHrec(delay+1,early+1)=R3(1,2);
%         pvaluedelayOHrec(delay+1,early+1)=P3(1,2);  
%         [R6,P6] = corrcoef(Ikorea(1:length(Ikorea)-1),korea_recovered((2+delay+early):L));
%         correlationdelaySKrec(delay+1,early+1)=R6(1,2);
%         pvaluedelaySKrec(delay+1,early+1)=P6(1,2);
%         
%         %infection-death
%         [R4,P4] = corrcoef(Iwuhan(1:length(Iwuhan)-1),wuhan_death(2:(58-delay-early)));
%         correlationdelayWHdea(delay+1,early+1)=R4(1,2);
%         pvaluedelayWHdea(delay+1,early+1)=P4(1,2);
%         [R5,P5] = corrcoef(Ihubei(1:length(Ihubei)-1),hubei_death(2:(58-delay-early)));
%         correlationdelayHBdea(delay+1,early+1)=R5(1,2);
%         pvaluedelayHBdea(delay+1,early+1)=P5(1,2);
%     end
% end
% 
% save correlationdelayWHrec correlationdelayWHrec
% save pvaluedelayWHrec pvaluedelayWHrec
% 
% save correlationdelayWHdea correlationdelayWHdea
% save pvaluedelayWHdea pvaluedelayWHdea
% 
% save correlationdelayHBrec correlationdelayHBrec
% save pvaluedelayHBrec pvaluedelayHBrec
% 
% save correlationdelayHBdea correlationdelayHBdea
% save pvaluedelayHBdea pvaluedelayHBdea
% 
% save correlationdelayOHrec correlationdelayOHrec
% save pvaluedelayOHrec pvaluedelayOHrec
% 
% save correlationdelaySKrec correlationdelaySKrec
% save pvaluedelaySKrec pvaluedelaySKrec



%heatmap
% WHrec = heatmap(correlationdelayWHrec);
% WHrec.XDisplayLabels = num2cell(0:7);
% WHrec.YDisplayLabels = num2cell(0:14);
% a2 = axes('Position', WHrec.Position);               %new axis on top to add label's
% a2.Color = 'none';               %new axis transparent
% a2.YTick = [];                   %Remove ytick
% a2.XTick = [];                   %Remove xtick
% a2.YDir = 'Reverse';             %flip your y axis to correspond with heatmap's
% xlabel('$\tau_I$','interpreter','latex','FontSize',24);        %you can use any commands under axes properties to edit the axes appearance 
% ylabel('$\tau_R$','interpreter','latex','FontSize',24);

% WHrec = heatmap(correlationdelayHBrec);
% WHrec.XDisplayLabels = num2cell(0:7);
% WHrec.YDisplayLabels = num2cell(0:14);

% WHrec = heatmap(correlationdelayOHrec);
% WHrec.XDisplayLabels = num2cell(0:7);
% WHrec.YDisplayLabels = num2cell(0:14);

% WHrec = heatmap(correlationdelaySKrec);
% WHrec.XDisplayLabels = num2cell(0:7);
% WHrec.YDisplayLabels = num2cell(0:14);

% WHrec = heatmap(correlationdelayWHdea);
% WHrec.XDisplayLabels = num2cell(0:7);
% WHrec.YDisplayLabels = num2cell(0:14);

% WHrec = heatmap(correlationdelayHBdea);
% WHrec.XDisplayLabels = num2cell(0:7);
% WHrec.YDisplayLabels = num2cell(0:14);


% %curve_after revision
% delay=11;
% early=3;
% 
% Iwuhan = acwuhaninf((1+early):(58-delay)) - acwuhanrec((1+early+delay):58) - acwuhandea(1:(58-delay-early));
% Ihubei = achubeiinf((1+early):(58-delay)) - achubeirec((1+early+delay):58) - achubeidea(1:(58-delay-early));
% txisx=1:57-delay-early;
% subplot(1,2,1)
% g1=plot(txisx,Iwuhan(1:length(Iwuhan)-1),'-','color',[0, 0, 0],'LineWidth',2);
% hold on
% g2=plot(txisx,wuhan_recovered((2+delay+early):58),'-','color',[1, 0, 0],'LineWidth',2);
% hold on
% g3=plot(txisx,wuhan_death(2:(58-delay-early)),'-','color',[0, 0, 1],'LineWidth',2);
% legend([g1,g2,g3],'Revised $I(t)$ in Wuhan','Revised $R_{rep}(t+1)$ in Wuhan','Revised $D_{rep}(t+1)$ in Wuhan','interpreter','latex','fontsize',16,'fontname','Times New Roman');
% set(gca,'linewidth',1.0,'fontsize',12,'fontname','Times New Roman');
% set(gca, 'YScale', 'log')
% xlabel('$t$','interpreter','latex','FontSize',24);
% ylabel('Number','interpreter','latex', 'FontSize', 24);
% 
% subplot(1,2,2)
% g1=plot(txisx,Ihubei(1:length(Ihubei)-1),'-','color',[0, 0, 0],'LineWidth',2);
% hold on
% g2=plot(txisx,hubei_recovered((2+delay+early):58),'-','color',[1, 0, 0],'LineWidth',2);
% hold on
% g3=plot(txisx,hubei_death(2:(58-delay-early)),'-','color',[0, 0, 1],'LineWidth',2);
% legend([g1,g2,g3],'Revised $I(t)$ in Hubei','Revised $R_{rep}(t+1)$ in Hubei','Revised $D_{rep}(t+1)$ in Hubei','interpreter','latex','fontsize',16,'fontname','Times New Roman');
% set(gca,'linewidth',1.0,'fontsize',12,'fontname','Times New Roman');
% set(gca, 'YScale', 'log')
% xlabel('$t$','interpreter','latex','FontSize',24);
% ylabel('Number','interpreter','latex', 'FontSize', 24);


%data_to_plot_scatter


% delay=12;
% early=0;
% 
% Iwuhan = acwuhaninf((1+early):(58-delay)) - acwuhanrec((1+early+delay):58) - acwuhandea(1:(58-delay-early));
% Ihubei = achubeiinf((1+early):(58-delay)) - achubeirec((1+early+delay):58) - achubeidea(1:(58-delay-early));
% Iouhub = acouhubinf((1+early):(58-delay)) - acouhubrec((1+early+delay):58) - acouhubdea(1:(58-delay-early));
% Ikorea = ackoreainf((1+early):(L-delay)) - ackorearec((1+early+delay):L) - ackoreadea(1:(L-delay-early));
% 
% Iwuhanafter=Iwuhan(1:length(Iwuhan)-1);
% Rwuhanafter=wuhan_recovered((2+delay+early):58);
% Dwuhanafter=wuhan_death(2:(58-delay-early));
% Ihubeiafter=Ihubei(1:length(Ihubei)-1);
% Rhubeiafter=hubei_recovered((2+delay+early):58);
% Dhubeiafter=hubei_death(2:(58-delay-early));
% Iouhubafter=Iouhub(1:length(Iouhub)-1);
% Rouhubafter=out_hubei_recovered((2+delay+early):58);
% Douhubafter=out_hubei_death(2:(58-delay-early));
% Ikoreaafter=Ikorea(1:length(Ikorea)-1);
% Rkoreaafter=korea_recovered((2+delay+early):L);
% Dkoreaafter=korea_death(2:(L-delay-early));
% 
% Iwuhanafter=Iwuhanafter';
% Rwuhanafter=Rwuhanafter';
% Dwuhanafter=Dwuhanafter';
% Ihubeiafter=Ihubeiafter';
% Rhubeiafter=Rhubeiafter';
% Dhubeiafter=Dhubeiafter';
% Iouhubafter=Iouhubafter';
% Rouhubafter=Rouhubafter';
% Douhubafter=Douhubafter';
% Ikoreaafter=Ikoreaafter';
% Rkoreaafter=Rkoreaafter';
% Dkoreaafter=Dkoreaafter';
% 
% delay=0;
% early=0;
% 
% Iwuhan = acwuhaninf((1+early):(58-delay)) - acwuhanrec((1+early+delay):58) - acwuhandea(1:(58-delay-early));
% Ihubei = achubeiinf((1+early):(58-delay)) - achubeirec((1+early+delay):58) - achubeidea(1:(58-delay-early));
% Iouhub = acouhubinf((1+early):(58-delay)) - acouhubrec((1+early+delay):58) - acouhubdea(1:(58-delay-early));
% Ikorea = ackoreainf((1+early):(L-delay)) - ackorearec((1+early+delay):L) - ackoreadea(1:(L-delay-early));
% 
% Iwuhanbefore=Iwuhan(1:length(Iwuhan)-1);
% Rwuhanbefore=wuhan_recovered((2+delay+early):58);
% Dwuhanbefore=wuhan_death(2:(58-delay-early));
% Ihubeibefore=Ihubei(1:length(Ihubei)-1);
% Rhubeibefore=hubei_recovered((2+delay+early):58);
% Dhubeibefore=hubei_death(2:(58-delay-early));
% Iouhubbefore=Iouhub(1:length(Iouhub)-1);
% Rouhubbefore=out_hubei_recovered((2+delay+early):58);
% Douhubbefore=out_hubei_death(2:(58-delay-early));
% Ikoreabefore=Ikorea(1:length(Ikorea)-1);
% Rkoreabefore=korea_recovered((2+delay+early):L);
% Dkoreabefore=korea_death(2:(L-delay-early));
% 
% Iwuhanbefore=Iwuhanbefore';
% Rwuhanbefore=Rwuhanbefore';
% Dwuhanbefore=Dwuhanbefore';
% Ihubeibefore=Ihubeibefore';
% Rhubeibefore=Rhubeibefore';
% Dhubeibefore=Dhubeibefore';
% Iouhubbefore=Iouhubbefore';
% Rouhubbefore=Rouhubbefore';
% Douhubbefore=Douhubbefore';
% Ikoreabefore=Ikoreabefore';
% Rkoreabefore=Rkoreabefore';
% Dkoreabefore=Dkoreabefore';

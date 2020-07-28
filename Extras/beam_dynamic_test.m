%% Start
clc
clear
close all

dt = 0.00005;
endt = 0.1;
t = transpose(0:dt:endt);
nt = length(t);
% TOL = 1e-15;
Tol = 1e-5;
nm = 10; % total No. of modes considered

Pmax = 1000; % [N]
endtP = 0.05;

P = zeros(nt,1);
% P(2:find(endtP==t)) = [1:(find(endtP==t)-1)]*Pmax/(find(endtP==t)-1); % ramp force
P(2:(find(endtP==t)+1)/2) = [1:(find(endtP==t)-1)/2]*2*Pmax/(find(endtP==t)-1); %
P((find(endtP==t)+1)/2+1:(find(endtP==t))) = Pmax-[1:(find(endtP==t)-1)/2]*2*Pmax/(find(endtP==t)-1); 


%% Properties of the beam
L_beam = 1; % length [m]
b_beam = 0.1; % diameter [m]
h_beam = 0.1; % diameter [m]
R_beam = inf; % [radius]
E_beam = 2E11; % for steel [N/m^2]
rho_beam = 7700; % [kg/m^3]

% L_beam = 10; % length [m]
% b_beam = 2; % diameter [m]
% h_beam = 2; % diameter [m]
% R_beam = inf; % [radius]
% E_beam = 70E9; % for steel [N/m^2]
% rho_beam = 8000; % [kg/m^3]

nu_beam = 0.3; % poisson's ratio
% psi_beam = 0.5;
psi_beam = 0;
sigy_beam = 3.5E8; % yield strength [N/mm^2]

A_beam = b_beam*h_beam; % sectional area [mm^2]
m_beam = rho_beam*A_beam*L_beam;
mpl_beam = rho_beam*A_beam; % mass per unit length
vw_beam = sqrt(E_beam/rho_beam); % velocity of wave propagation
k_beam = E_beam*A_beam/L_beam;
I_beam = 1/12*b_beam*h_beam^3; % for rectangular cross-section only


%% Modal Frequency (wn, wd), Amplitude of Shape Fuction (C1), and Modal Mass (Mn)
wn_beam = nan(nm,1);
wd_beam = nan(nm,1);
sfnAmp = nan(nm,1); % amplitude of shape fuction
Mn = nan(nm,1); % modal mass for beam
sfn = nan(nm,5); % shape function
for i = 1:nm
    wn_beam(i) = i^2*pi^2/L_beam^2*sqrt(E_beam*I_beam/mpl_beam);
    sfnAmp(i) = sqrt(2/m_beam); % shosen to make modal mass (Mi) equal to 1
    Mn(i) = 1/2*m_beam*sfnAmp(i)^2;
    
    % simply supported beam
    [sfn(i,1)] = beam_shapefunction(sfnAmp(i),i,0); % at x=0
    [sfn(i,2)] = beam_shapefunction(sfnAmp(i),i,1/4*L_beam); % at x=1/4*L
    [sfn(i,3)] = beam_shapefunction(sfnAmp(i),i,2/4*L_beam); % at x=2/4*L
    [sfn(i,4)] = beam_shapefunction(sfnAmp(i),i,3/4*L_beam); % at x=3/4*L
    [sfn(i,5)] = beam_shapefunction(sfnAmp(i),i,4/4*L_beam); % at x=4/4*L
    if psi_beam < 1
        wd_beam(i) = wn_beam(i)*sqrt(1-psi_beam^2);
    elseif psi_beam == 1
        wd_beam(i) = wn_beam(i);
    elseif psi_beam > 1
        wd_beam(i) = wn_beam(i)*sqrt(psi_beam^2-1);
    end
end


%% Initial Conditions
u = zeros(nt,1);

q = zeros(nt,nm);
qd = zeros(nt,nm);
qdd = zeros(nt,nm);

u_04L = zeros(nt,1);
u_14L = zeros(nt,1);
u_34L = zeros(nt,1);
u_44L = zeros(nt,1);




percPrev = nan;
disp('Start analysis.');
for i = 2:nt

%     u(i) = DuhamelsIntegration(Mn,wn_beam,wd_beam,psi_beam,-P,sfn,sfnAmp,nm,dt,t,i,3); % u1_24L - beam
    [u(i),q,qd,qdd] = Newmark_ModeSuperposition(Mn,wn_beam,psi_beam,-P,sfn,nm,q,qd,qdd,dt,i,3); % u1_24L - beam
	
        
    perc = i/nt*100;
    if percPrev < 20 && perc >=20
        disp('20% done.');
    elseif percPrev < 40 && perc >=40
        disp('40% done.');
    elseif percPrev < 60 && perc >=60
        disp('60% done.');
    elseif percPrev < 80 && perc >=80
        disp('80% done.');
    end
    percPrev = perc;
    
end
disp('100% done.');



figure
plot(t,-u,'r-','LineWidth',1);
% xlim([0 1e-2])
% ylim([-2e-2 2e-2])
ylabel('Displacement (m)');
xlabel('Time (sec)');
legend('u_{1} (beam)');


figure
plot(t,P,'b:','LineWidth',2);
ylabel('Force (N)');
xlabel('Time (sec)');
legend('Applied Force');



% load uABAQUS.mat

% figure
% plot(uRamp(:,1),uRamp(:,2),'k--','LineWidth',1);
% hold on
% plot(t,-u,'r-','LineWidth',1);
% % xlim([0 1e-2])
% % ylim([-2e-2 2e-2])
% ylabel('Displacement (m)');
% xlabel('Time (sec)');
% legend('u_{1} (ABAQUS)','u_{1} (analytical)');

% figure
% plot(uTri(:,1),-uTri(:,2),'k--','LineWidth',1);
% hold on
% plot(t,-u,'r-','LineWidth',1);
% % xlim([0 1e-2])
% % ylim([-2e-2 2e-2])
% ylabel('Displacement (m)');
% xlabel('Time (sec)');
% legend('u_{1} (ABAQUS)','u_{1} (analytical)');

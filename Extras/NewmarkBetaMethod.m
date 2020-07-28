function [u,ud,udd] = NewmarkBetaMethod(m,c,k,p,u,ud,udd,dt,i)

%% Constants for Newmark's Method
gamma = 1/2;
beta = 1/4; % average acceleration method
% beta = 1/6; % linear acceleration method

C1 = 1/(beta*dt^2);
C2 = 1/(2*beta);
C3 = gamma/(beta*dt);
C4 = gamma/beta;
C5 = gamma/(2*beta);
C6 = 1/(beta*dt);

%% Calculation for each time step
peff = p(i) + m*(C1*u(i-1)+C6*ud(i-1)+(C2-1)*udd(i-1)) + ...
    c*(C3*u(i-1)+(C4-1)*ud(i-1)+dt*(C5-1)*udd(i-1));
keff = C1*m + C3*c + k;

u(i) = peff*inv(keff);
udd(i) = C1*(u(i)-u(i-1)-dt*ud(i-1)) - (C2-1)*udd(i-1);
ud(i) = ud(i-1) + dt*(gamma*udd(i)+(1-gamma)*udd(i-1));
% ud(i) = C3*(u(i)-u(i-1)) - (C4-1)*ud(i-1) - dt*(C5-1)*udd(i-1);


end

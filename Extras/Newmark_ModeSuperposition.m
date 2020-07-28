function [u,q,qd,qdd] = Newmark_ModeSuperposition(Mn,wn,psi,p,sfn,nm,q,qd,qdd,dt,i,x)

% initialization
u = 0;

for k = 1:nm
    
    qNM(:,1) = q(:,k);
    qdNM(:,1) = qd(:,k);
    qddNM(:,1) = qdd(:,k);
    
%     Pn = sfnAmp(k)*sin(k*pi/2)*p/Mn(k); % in case that load is applied on the top of the rod
    Pn = sfn(k,x)*p/Mn(k); % in case that load is applied on the top of the rod
    
    [qNM,qdNM,qddNM] = NewmarkBetaMethod(1,2*psi*wn(k),wn(k)^2,Pn,qNM,qdNM,qddNM,dt,i);
    
    u = u + sfn(k,x)*qNM(i);
    
    q(i,k) = qNM(i);
    qd(i,k) = qdNM(i);
    qdd(i,k) = qddNM(i);

end

end
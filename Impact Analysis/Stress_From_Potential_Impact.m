height = 1;
mass = 10;
OD = .0504; 
ID = .0381;
E = 7 * 10^10;
Length = 2; 

I = (3.14/4) * (((OD/2)^4)-((ID/2)^4));
PE = 9.81 * mass * height;
Static_Load = ((96*PE*E*I)/(Length^3))^0.5;
Stress = (10^-6) * ((Static_Load * Length * OD) / (8 * I));

Deflection = (10^2)*(Static_Load * Length ^ 3) / ( 48 * E * I);

disp(strcat('Equivilant Static Load: ', strcat(num2str((10^-3) * Static_Load), ' KN')));

disp(strcat('Stress: ', strcat(num2str(Stress), ' MPa')));

disp(strcat('Deflection: ', strcat(num2str(Deflection), ' cm')));
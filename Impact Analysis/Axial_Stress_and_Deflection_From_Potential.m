height = 1;
mass = 10;
OD = .0504; 
ID = .0381;
E = 7 * 10^10;
Length = 2; 

Area = 3.14 * ((OD^2) - (ID^2));
I = (3.14/4) * (((OD/2)^4)-((ID/2)^4));
PE = 9.81 * mass * height;
Static_Load = sqrt((2 * PE * Area * E) / (Length));
Stress = Static_Load / Area;
Deflection = (10^3) * (Static_Load * Length) / (Area * E);

disp(strcat('Equivilant Static Load: ', strcat(num2str((10^-3) * Static_Load), ' KN')));

disp(strcat('Stress: ', strcat(num2str((10^-6) * Stress), ' MPa')));

disp(strcat('Deflection: ', strcat(num2str(Deflection), ' mm')));

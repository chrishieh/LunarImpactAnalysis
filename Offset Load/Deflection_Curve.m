base = 0.1; %Cross Section
height = base;
E = 200 * 10^9; %200 GPa

Length = 1; %Meters 
a = .01;  %for centered impact, set a to Length / 2
b = Length - a; %The amount of significant figures in a and b are limited to the significant figures in the variable "step"

I = (1/12) * base * (height^3); %m^4

Static_Load = 10000; %10 KN

%Note: Xm model only works when a >= b. Any results for 
if a >= b
    Xm = sqrt(((Length^2)-(b^2))/3); 
else 
    Xm = 1 - (sqrt(((Length^2)-(a^2))/3)); 
end

Maximum_Deflection = (Static_Load * b * (((Length^2)-(b^2))^(3/2))) / (9 * sqrt(3) * Length * E * I);
Center_Deflection = ((Static_Load * b) / (48 * E *I)) * ((3 * (Length ^2)) - (4 * (b^2)));

step = 0.01;
start = zeros(1, Length/step);
first = double(start);
x = double(start);
for k = 1: a / step
    deflection = -(((Static_Load * b * (k * step))) / (6 * Length * E * I)) * (Length^2 - b^2 - (k * step)^2);    
    first(k) = deflection;
    x(k) = k * step;
end

for k = a/step : Length / step
    
    deflection = -(((Static_Load * b )/ (6 * Length * E * I)) * ((Length/b) * ((k*step)-a)^3 +((Length^2)-(b^2))*(k*step)-(k*step)^3));
    first(k) = deflection;
    x(k) = k * step;

end
plot(x, first);
filename = 'Beam_Deflection.xlsx';
%writematrix(x, filename, 'Sheet', 'Deflections2', 'Range', 'B2');  %Used
%to write to an Excel chart
%writematrix(first, filename, 'Sheet', 'Deflections2', 'Range', 'B4');

Xm

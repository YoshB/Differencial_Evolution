%DIferencial Evolution
clc;
clear all;
close all;

% choose the function with this value (Ej. 0, 1, 2... etc.)
f_objetivo = 2;

switch f_objetivo
    case 0
        %Griewank
        tit = "Griewank function";
       f = @(x,y) ((x.^2 + y.^2)/4000)-cos(x).*cos(y/sqrt(2)) + 1;
       U = [10 10];
       L = [-10 -10];
       %Minimo = 0; x= 0, y= 0
       
    case 1
        %Rastrigin
        tit = "Rastrigin function";
       f = @(x,y)  10*2 + x.^2 - 10 .*cos(pi*x)+ y.^2 - 10 .* cos(pi*y);
       U = [5 5];
       L = [-5 -5];
       %Minimo = 0; x = 0, y = 0 
       
      
    case 2
         %DropWave
         tit = "DropWave function";
        f = @(x,y) - ((1 + cos(12*sqrt(x.^2+y.^2))) ./ (0.5 *(x.^2+y.^2) + 2));
        U = [2 2];
        L = [-2 -2];
           %Minimo = -1; x = 0, y =0
       
    otherwise
        disp("Choose a valid value for a function")
        return
end


D = 2;
poblacion = 150;
G = 80;

%Amplification factor
F = 0.15;
% Combination factor
Cr = 0.7;

% INICIALIZATION
ind = zeros(D, poblacion);
for i=1:poblacion
    r = rand(1,D);
    ind(:,i) = L + (U - L) .* r;
end

[X,Y] = meshgrid(L(1):0.25:U(1), L(2):0.25:U(2));
Z = f(X,Y);
contour(X,Y,Z,35);
hold on
title(tit);

gif('DropWave_DE.gif','DelayTime',0.15)

for k=1:G
    
    
    for i=1: poblacion
        %Calculating a mutation vector and take
        %a parent plus the sum of  the difference between another 2 parents
        r = randperm(poblacion);
        r = r(r~=i);

        v = ind(:,r(1)) + F*(ind(:,r(2)) - ind(:,r(3)));
        
        %proof vector initialized with the values of the actual parent
        u = ind(:,i);

        for j=1: D
            %Combinating the proof vector with the mutation vector
            if rand < Cr
                u(j) = v(j);
            end
        end
        
        %If the proof vector has better accuracy than the original we
        %switch them
        if f(ind(1,i),ind(2,i)) > f(u(1),u(2))
            ind(:,i) = u;
        end
    end
    
    %Graphics
     axis([L(1),U(1),L(2),U(2)]);
     h = plot(ind(1,:), ind(2,:),'rx');
     pause(0.1)
     gif
     delete(h)
     
    
end

h = plot(ind(1,:), ind(2,:),'rx');


%Choosing better solution
values = f(ind(1,:),ind(2,:));
[~,n] = min(values);

best = ind(:,n)
f = f(best(1),best(2))

figure
surf(X,Y,Z)
hold on
plot3(best(1),best(2), f, 'rx','MarkerSize',7, 'LineWidth', 2);
plot3(best(1),best(2), f, 'ro','MarkerSize',9, 'LineWidth', 2);
title(tit)




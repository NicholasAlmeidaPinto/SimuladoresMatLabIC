clear;
close;
clc;

disp('Simulador TVD/NonStandard Hibrido Bifasico 2D');
disp('---------------------------------------------');
%VALORES INICIAIS 
N1 = 100;
alpha = 2;
alpha = input('Alpha(2, 2.08, 2.97): ');
t = input('Tempo: ');
disp('    INJECAO')
disp('1 none   2 poco')
disp('3 line   4 duplo')
disp('5 five')
injecao = input('--> ');
disp('      POROSIDADE')
% disp('[0;1] Cte      2 Circulo')
% disp('3 Labirinto    4 Espiral')
% disp('5 Retangulos   6 rand')
porosidade = input('--> ');
maxp = 1;
minp = 0.4;
miw = 1;
mio = 1;
deltx = 5;
delty = 5;
deltt = 2;

%VARIAVEIS
Sw(1:N1,1:N1,1:t) = 0;
Ax(1:N1,1:N1) = 0;
Ay(1:N1,1:N1) = 0;
Bx(1:N1,1:N1) = 0;
By(1:N1,1:N1) = 0;
Anx(1:N1,1:N1) = 0;
Any(1:N1,1:N1) = 0;
Bnx(1:N1,1:N1) = 0;
Bny(1:N1,1:N1) = 0;
Fx(1:N1,1:N1) = 0;
Fy(1:N1,1:N1) = 0;
phi(1:N1,1:N1) = 0; 

phix=(1/(2*alpha))*((1-exp(-alpha*deltt/deltx)));
phiy=(1/(2*alpha))*((1-exp(-alpha*deltt/delty)));

%POROSIDADE
for x = 1:1:N1
    for y = 1:1:N1
        if porosidade > 1 %rand
            phi(x,y) = rand(1);
            while phi(x,y) > maxp || phi(x,y) < minp
                phi(x,y) = rand(1);
            end
        else %const
            phi(x,y) = porosidade;
        end
    end 
end

%INJECAO COM 1 PULSO
if injecao == 1
    Sw(1,N1/2,1) = 1;
end

%COMECO DO TEMPO E LOADING
disp('---------------------------------------------');
disp('Loading...')
for j=1:1:t-1 %pois o Sw eh calculado para o proximo tempo (j+1)
    if rem(j,10) == 0
        ja = 100*j/t;
        fprintf('%f', ja); disp('%');
    end
    
    inicio = 1; %para analisar quanto foi injetado
    for x = 1:1:N1
        for y = 1:1:N1
            
            %INJECAO
            if injecao == 2 %Poco
                inicio = inicio + (1-Sw(N1/2,N1/2,j));
                Sw(N1/2,N1/2,j) = 1;
            elseif injecao == 3 %line
                Sw(1,1:N1,j) = 1;
            elseif injecao == 4 %duo
                Sw(N1/4,N1/4,j) = 1;
                Sw(N1-N1/4,N1-N1/4,j) = 1;
            elseif injecao == 5 %five spot
                Sw(1,1,j) = 1;
                Sw(N1,1,j) = 1;
                Sw(1,N1,j) = 1;
                Sw(N1,N1,j) = 1;
            end
            
            %CONTAS
            if x > 2 && x < N1
                Ax(x,y) = Sw(x-1,y,j) + 0.5*(Sw(x,y,j) - Sw(x-1,y,j))* max(0, min(1,(Sw(x-1,y,j) - Sw(x-2,y,j))/(Sw(x,y,j) - Sw(x-1,y,j))));
                Bx(x,y) = Sw(x,y,j) + 0.5*(Sw(x+1,y,j) - Sw(x,y,j))* max(0, min(1,(Sw(x,y,j) - Sw(x-1,y,j))/(Sw(x+1,y,j) - Sw(x,y,j))));
                
                Anx(N1+1-x,N1+1-y) = Sw(N1+1-x+1,N1+1-y,j) + 0.5*(Sw(N1+1-x,N1+1-y,j) - Sw(N1+1-x+1,N1+1-y,j))* max(0, min(1,(Sw(N1+1-x+1,N1+1-y,j) - Sw(N1+1-x+2,N1+1-y,j))/(Sw(N1+1-x,N1+1-y,j) - Sw(N1+1-x+1,N1+1-y,j))));
                Bnx(N1+1-x,N1+1-y) = Sw(N1+1-x,N1+1-y,j) + 0.5*(Sw(N1+1-x-1,N1+1-y,j) - Sw(N1+1-x,N1+1-y,j))* max(0, min(1,(Sw(N1+1-x,N1+1-y,j) - Sw(N1+1-x+1,N1+1-y,j))/(Sw(N1+1-x-1,N1+1-y,j) - Sw(N1+1-x,N1+1-y,j))));
            elseif x == 1
                Ax(x,y) = Sw(x,y,j);
                Bx(x,y) = Sw(x,y,j) + 0.5*(Sw(x+1,y,j) - Sw(x,y,j))* max(0, min(1,(Sw(x,y,j) - Sw(x,y,j))/(Sw(x+1,y,j) - Sw(x,y,j))));
                
                Anx(N1+1-x,N1+1-y) = Sw(N1+1-x,N1+1-y,j);
                Bnx(N1+1-x,N1+1-y) = Sw(N1+1-x,N1+1-y,j) + 0.5*(Sw(N1+1-x-1,N1+1-y,j) - Sw(N1+1-x,N1+1-y,j))* max(0, min(1,(Sw(N1+1-x,N1+1-y,j) - Sw(N1+1-x,N1+1-y,j))/(Sw(N1+1-x-1,N1+1-y,j) - Sw(N1+1-x,N1+1-y,j))));
            elseif x == 2
                Ax(x,y) = Sw(x-1,y,j) + 0.5*(Sw(x,y,j) - Sw(x-1,y,j))* max(0, min(1,0));
                Bx(x,y) = Sw(x,y,j) + 0.5*(Sw(x+1,y,j) - Sw(x,y,j))* max(0, min(1,(Sw(x,y,j) - Sw(x-1,y,j))/(Sw(x+1,y,j) - Sw(x,y,j))));
            
                Anx(N1+1-x,N1+1-y) = Sw(N1+1-x+1,N1+1-y,j) + 0.5*(Sw(N1+1-x,N1+1-y,j) - Sw(N1+1-x+1,N1+1-y,j))* max(0, min(1,0));
                Bnx(N1+1-x,N1+1-y) = Sw(N1+1-x,N1+1-y,j) + 0.5*(Sw(N1+1-x-1,N1+1-y,j) - Sw(N1+1-x,N1+1-y,j))* max(0, min(1,(Sw(N1+1-x,N1+1-y,j) - Sw(N1+1-x+1,N1+1-y,j))/(Sw(N1+1-x-1,N1+1-y,j) - Sw(N1+1-x,N1+1-y,j))));
            elseif x == N1
                Ax(x,y) = Sw(x-1,y,j) + 0.5*(Sw(x,y,j) - Sw(x-1,y,j))* max(0, min(1,(Sw(x-1,y,j) - Sw(x-2,y,j))/(Sw(x,y,j) - Sw(x-1,y,j))));
                Bx(x,y) = Sw(x,y,j);
                
                Anx(N1+1-x,N1+1-y) = Sw(N1+1-x+1,N1+1-y,j) + 0.5*(Sw(N1+1-x,N1+1-y,j) - Sw(N1+1-x+1,N1+1-y,j))* max(0, min(1,(Sw(N1+1-x+1,N1+1-y,j) - Sw(N1+1-x+2,N1+1-y,j))/(Sw(N1+1-x,N1+1-y,j) - Sw(N1+1-x+1,N1+1-y,j))));
                Bnx(N1+1-x,N1+1-y) = Sw(N1+1-x,N1+1-y,j);
            end
            
            if y > 2 && y < N1
                Ay(x,y) = Sw(x,y-1,j) + 0.5*(Sw(x,y,j) - Sw(x,y-1,j))* max(0, min(1,(Sw(x,y-1,j) - Sw(x,y-2,j))/(Sw(x,y,j) - Sw(x,y-1,j))));
                By(x,y) = Sw(x,y,j) + 0.5*(Sw(x,y+1,j) - Sw(x,y,j))* max(0, min(1,(Sw(x,y,j) - Sw(x,y-1,j))/(Sw(x,y+1,j) - Sw(x,y,j))));
                
                Any(N1+1-x,N1+1-y) = Sw(N1+1-x,N1+1-y+1,j) + 0.5*(Sw(N1+1-x,N1+1-y,j) - Sw(N1+1-x,N1+1-y+1,j))* max(0, min(1,(Sw(N1+1-x,N1+1-y+1,j) - Sw(N1+1-x,N1+1-y+2,j))/(Sw(N1+1-x,N1+1-y,j) - Sw(N1+1-x,N1+1-y+1,j))));
                Bny(N1+1-x,N1+1-y) = Sw(N1+1-x,N1+1-y,j) + 0.5*(Sw(N1+1-x,N1+1-y-1,j) - Sw(N1+1-x,N1+1-y,j))* max(0, min(1,(Sw(N1+1-x,N1+1-y,j) - Sw(N1+1-x,N1+1-y+1,j))/(Sw(N1+1-x,N1+1-y-1,j) - Sw(N1+1-x,N1+1-y,j))));
            elseif y == 1
                Ay(x,y) = Sw(x,y,j);
                By(x,y) = Sw(x,y,j) + 0.5*(Sw(x,y+1,j) - Sw(x,y,j))* max(0, min(1,(Sw(x,y,j) - Sw(x,y,j))/(Sw(x,y+1,j) - Sw(x,y,j))));
                
                Any(N1+1-x,N1+1-y) = Sw(N1+1-x,N1+1-y,j);
                Bny(N1+1-x,N1+1-y) = Sw(N1+1-x,N1+1-y,j) + 0.5*(Sw(N1+1-x,N1+1-y-1,j) - Sw(N1+1-x,N1+1-y,j))* max(0, min(1,(Sw(N1+1-x,N1+1-y,j) - Sw(N1+1-x,N1+1-y,j))/(Sw(N1+1-x,N1+1-y-1,j) - Sw(N1+1-x,N1+1-y,j))));
            elseif y == 2
                Ay(x,y) = Sw(x,y-1,j) + 0.5*(Sw(x,y,j) - Sw(x,y-1,j))* max(0, min(1,0));
                By(x,y) = Sw(x,y,j) + 0.5*(Sw(x,y+1,j) - Sw(x,y,j))* max(0, min(1,(Sw(x,y,j) - Sw(x,y-1,j))/(Sw(x,y+1,j) - Sw(x,y,j))));
                
                Any(N1+1-x,N1+1-y) = Sw(N1+1-x,N1+1-y+1,j) + 0.5*(Sw(N1+1-x,N1+1-y,j) - Sw(N1+1-x,N1+1-y+1,j))* max(0, min(1,0));
                Bny(N1+1-x,N1+1-y) = Sw(N1+1-x,N1+1-y,j) + 0.5*(Sw(N1+1-x,N1+1-y-1,j) - Sw(N1+1-x,N1+1-y,j))* max(0, min(1,(Sw(N1+1-x,N1+1-y,j) - Sw(N1+1-x,N1+1-y+1,j))/(Sw(N1+1-x,N1+1-y-1,j) - Sw(N1+1-x,N1+1-y,j))));
            elseif y == N1
                Ay(x,y) = Sw(x,y-1,j) + 0.5*(Sw(x,y,j) - Sw(x,y-1,j))* max(0, min(1,(Sw(x,y-1,j) - Sw(x,y-2,j))/(Sw(x,y,j) - Sw(x,y-1,j))));
                By(x,y) = Sw(x,y,j);
                
                Any(N1+1-x,N1+1-y) = Sw(N1+1-x,N1+1-y+1,j) + 0.5*(Sw(N1+1-x,N1+1-y,j) - Sw(N1+1-x,N1+1-y+1,j))* max(0, min(1,(Sw(N1+1-x,N1+1-y+1,j) - Sw(N1+1-x,N1+1-y+2,j))/(Sw(N1+1-x,N1+1-y,j) - Sw(N1+1-x,N1+1-y+1,j))));
                Bny(N1+1-x,N1+1-y) = Sw(N1+1-x,N1+1-y,j);
            end
        end
    end
    
    for x = 1:1:N1
        for y = 1:1:N1
            %CONDICOES PARA AVANCO E RECUO
            if (x>1) && (Sw(x,y,j) < Sw(x-1,y,j))
                Anx(x,y) = 0;
                Bnx(x,y) = 0;
            elseif (x>1)
                Ax(x,y) = 0;
                Bx(x,y) = 0;
            end
            
            if (y>1) && (Sw(x,y,j) < Sw(x,y-1,j))
                Any(x,y) = 0;
                Bny(x,y) = 0;
            elseif (y>1)
                Ay(x,y) = 0;
                By(x,y) = 0;
            end
            
            %EQUACAO DE FLUXO
            Fx(x,y) = (Ax(x,y)^2/((Ax(x,y)^2)+((1-Ax(x,y))^2)*miw/mio)) - (Bx(x,y)^2/((Bx(x,y)^2) + ((1-Bx(x,y))^2)*miw/mio)) + (Anx(x,y)^2/((Anx(x,y)^2)+((1-Anx(x,y))^2)*miw/mio)) - (Bnx(x,y)^2/((Bnx(x,y)^2)+((1-Bnx(x,y))^2)*miw/mio));
            Fy(x,y) = (Ay(x,y)^2/((Ay(x,y)^2)+((1-Ay(x,y))^2)*miw/mio)) - (By(x,y)^2/((By(x,y)^2) + ((1-By(x,y))^2)*miw/mio)) + (Any(x,y)^2/((Any(x,y)^2)+((1-Any(x,y))^2)*miw/mio)) - (Bny(x,y)^2/((Bny(x,y)^2)+((1-Bny(x,y))^2)*miw/mio));
            
            %EQUACAO DA SATURACAO
            Sw(x,y,j+1) = Sw(x,y,j) + (Fx(x,y)*phix + Fy(x,y)*phiy)/phi(x,y);
       end
    end
   
    
    
end

%AGUA NO RESERVATORIO
r = 0;
for x = 1:1:N1
    for y = 1:1:N1
        r = r+Sw(x,y,t);
    end
end
fprintf ('Volume de agua injetado %f= ', inicio);
fprintf ('\nVolume de agua no reservatorio %f= ', r);

%NUMERO DE VARIAVEIS
n = N1*N1*t + N1*N1*11;
fprintf('\nAproximadamente %f variaveis\n', n);
disp('-------------------------');

%GRAFICOS
figure (1)
R=linspace(0,N1,N1);
surf(R,R,Sw(:,:,t))
colorbar
xlabel('x')
ylabel('y')
zlabel('saturation')

for j = 1:1:t
    figure (2)
    surf(R,R,Sw(:,:,j));
    az = 0;
    el = 90;
    view(az, el);
    colorbar
    anima(j) = getframe;
    xlabel('x')
    ylabel('y')
    zlabel('saturation')
end
movie(anima, 10, 30)
%^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
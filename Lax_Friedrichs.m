clear;
close;
clc;
disp('_____Simulador Lax-Friedrichs 1D____');
disp('====================================')
%------------------------VALORES INICIAIS----------------------------------
N = 100;
deltx = 1;
deltt = 0.1; %deltt/deltx <= 1
mio = 20;
miw = 10;
conta = 1; %qual estilo de conta será desejado 1 - teorico , 2 - decrescente
tempo = 1000;
disp('--------------Carregando------------')
Sw(1:N,1:N,1:tempo) = 0;
%--------------------------------------------------------------------------

%-------------------------------CONTA--------------------------------------
if conta==1
    Sw(1,1) = 1; %condicao de injecao inicial
    for j = 1:1:tempo-1
        for i = 1:1:N
            if i == 1
                Fp = 0; %(Sw(i-1,j)^2)/((Sw(i-1,j)^2)+(miw/mio)*((1-Sw(i-1,j))^2));
                Fn = (Sw(i+1,j)^2)/((Sw(i+1,j)^2)+(miw/mio)*((1-Sw(i+1,j))^2));
                Sw(i,j+1) = (1/2) * (0 + Sw(i+1,j) - (Fn - Fp)*(deltt/deltx));
            elseif i == N
                Fp = (Sw(i-1,j)^2)/((Sw(i-1,j)^2)+(miw/mio)*((1-Sw(i-1,j))^2));
                Fn = 0; %(Sw(i+1,j)^2)/((Sw(i+1,j)^2)+(miw/mio)*((1-Sw(i+1,j))^2));
                Sw(i,j+1) = (1/2) * (Sw(i-1,j) + 0 - (Fn - Fp)*(deltt/deltx));
            else
                Fp = (Sw(i-1,j)^2)/((Sw(i-1,j)^2)+(miw/mio)*((1-Sw(i-1,j))^2));
                Fn = (Sw(i+1,j)^2)/((Sw(i+1,j)^2)+(miw/mio)*((1-Sw(i+1,j))^2));
                Sw(i,j+1) = (1/2) * (Sw(i-1,j) + Sw(i+1,j) - (Fn - Fp)*(deltt/deltx));
            end
        end
        Sw(1,j+1) = 1; %condicao de injecao
    end
end
%--------------------------------------------------------------------------

%------------------------------CONTA_2-------------------------------------
if conta==2
    for j = 1:1:tempo-1
        Sw(N/2,:) = 1;
        for i = 1:1:N
            if i == 1
                Fp = 0; %(Sw(i-1,j)^2)/((Sw(i-1,j)^2)+(miw/mio)*((1-Sw(i-1,j))^2));
                Fn = (Sw(i+1,j)^2)/((Sw(i+1,j)^2)+(miw/mio)*((1-Sw(i+1,j))^2));
                Sw(i,j+1) = (1/2) * (0 + Sw(i+1,j) - (Fn - Fp)*(deltt/deltx));
            elseif i == N
                Fp = (Sw(i-1,j)^2)/((Sw(i-1,j)^2)+(miw/mio)*((1-Sw(i-1,j))^2));
                Fn = 0; %(Sw(i+1,j)^2)/((Sw(i+1,j)^2)+(miw/mio)*((1-Sw(i+1,j))^2));
                Sw(i,j+1) = (1/2) * (Sw(i-1,j) + 0 - (Fn - Fp)*(deltt/deltx));
            else
                Fp = (Sw(i-1,j)^2)/((Sw(i-1,j)^2)+(miw/mio)*((1-Sw(i-1,j))^2));
                Fn = (Sw(i+1,j)^2)/((Sw(i+1,j)^2)+(miw/mio)*((1-Sw(i+1,j))^2));
                if Sw(i+1,j) > Sw(i,j)
                    Fn = Fn*(-1);
                end
                if Sw(i-1,j) < Sw(i,j)
                    Fp = Fp*(-1);                    
                end
                Sw(i,j+1) = (1/2) * (Sw(i-1,j) + Sw(i+1,j) - (Fn - Fp)*(deltt/deltx));
            end
        end
    end
end
%--------------------------------------------------------------------------

%--------------------------------VOLUME------------------------------------
if 2 == 0
    volume = 0;
    for x = 1:1:N
        volume = volume + Sw(x,tempo);
    end
    fprintf('O volume de agua no reservatorio é: %d', volume);
end
%--------------------------------------------------------------------------

%-------------------------------GRAFICO FINAL------------------------------
figure (1)                                                               %|
R=linspace(0,1,N);                                                       %|
plot(R,Sw(:,tempo))                                                      %|
xlabel('x')                                                              %|
zlabel('saturation')                                                     %|
%--------------------------------------------------------------------------

%-----------------------------ANIMACAO-------------------------------------
if 2==2                                                                  %|
    for j = 1:1:tempo                                                    %|
        figure(2)                                                        %|
        plot(R,Sw(:,j), 'blue')                                          %|
        anima(j) = getframe;                                             %|
    end                                                                  %|
    movie(anima,3,20);                                                   %|
end                                                                      %|
%--------------------------------------------------------------------------
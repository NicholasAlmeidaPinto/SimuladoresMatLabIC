clear;
close;
clc;
%Nicholas de A. Pinto
disp('_____Simulador Lax-Friedrichs 2D____');
disp('====================================')
%------------------------VALORES INICIAIS----------------------------------
N = 100;
delty = 1;
deltx = 1;
deltt = 0.1;
mio = 1;
miw = 1;
porosidade = 1;
tempo = 1000;
disp('--------------Carregando------------')
Sw(1:N,1:N,1:tempo) = 0;
%--------------------------------------------------------------------------

%-------------------------------CONTA--------------------------------------
for j = 1:1:tempo-1
    Sw(1,:,1) = 1;
    for i = 1:1:N
        for k = 1:1:N
            
            if i == 1
                Fpx = 0;
                Fnx = (Sw(i+1,k,j)^2)/((Sw(i+1,k,j)^2)+(miw/mio)*((1-Sw(i+1,k,j))^2));
                X = Sw(i+1,k,j);
            elseif i == N
                Fpx = (Sw(i-1,k,j)^2)/((Sw(i-1,k,j)^2)+(miw/mio)*((1-Sw(i-1,k,j))^2));
                Fnx = 0;
                X = Sw(i-1,k,j);
            else
                Fpx = (Sw(i-1,k,j)^2)/((Sw(i-1,k,j)^2)+(miw/mio)*((1-Sw(i-1,k,j))^2));
                Fnx = (Sw(i+1,k,j)^2)/((Sw(i+1,k,j)^2)+(miw/mio)*((1-Sw(i+1,k,j))^2));
                X = Sw(i-1,k,j) + Sw(i+1,k,j);
            end
             
            if k == 1
                Fpy = 0;
                Fny = (Sw(i,k+1,j)^2)/((Sw(i,k+1,j)^2)+(miw/mio)*((1-Sw(i,k+1,j))^2));
                Y = Sw(i,k+1,j);
            elseif k == N
                Fpy = (Sw(i,k-1,j)^2)/((Sw(i,k-1,j)^2)+(miw/mio)*((1-Sw(i,k-1,j))^2));
                Fny = 0;
                Y = Sw(i,k-1,j);
            else
                Fpy = (Sw(i,k-1,j)^2)/((Sw(i,k-1,j)^2)+(miw/mio)*((1-Sw(i,k-1,j))^2));
                Fny = (Sw(i,k+1,j)^2)/((Sw(i,k+1,j)^2)+(miw/mio)*((1-Sw(i,k+1,j))^2));
                Y = Sw(i,k-1,j) + Sw(i,k+1,j);
            end
            
            Sw(i,k,j+1) = (1/4) * (X - (Fnx - Fpx)*(deltt/deltx)) + (1/4) * (Y - (Fny - Fpy)*(deltt/delty));
            
        end
    end
    Sw(1,:,j+1) = 1;
end
%--------------------------------------------------------------------------

%--------------------------------VOLUME------------------------------------
if 2==0
    volume = 0;
    for x = 1:1:N
        for y = 1:1:N
            volume = volume + Sw(x,y,tempo);
        end
    end
    fprintf('O volume de agua no reservatorio é: %d', volume);
end
%--------------------------------------------------------------------------

%-------------------------------GRAFICO FINAL------------------------------
figure (1)                                                               %|
R=linspace(0,1,N);                                                       %|
surf(R,R,Sw(:,:,tempo))                                                  %|
xlabel('x')                                                              %|
ylabel('y')                                                              %|
zlabel('saturation')                                                     %|
colorbar                                                                 %|
%--------------------------------------------------------------------------

%---------------------------------ANIMACAO---------------------------------
for t=1:1:tempo                                                          %|
        figure (2)                                                       %|
        surf(R,R,Sw(:,:,t));                                             %|
        az = 0;                                                          %|
        el = 90;                                                         %|
        view(az, el);                                                    %|
        colorbar                                                         %|
        anima(t) = getframe;                                             %|
        xlabel('x')                                                      %|
        ylabel('y')                                                      %|
        zlabel('saturation')                                             %|
end                                                                      %|
movie(anima,3,20)                                                        %|
%--------------------------------------------------------------------------

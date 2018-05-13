clear;
close;
clc;
%Nichoals de Almeida Pinto
%Simulador TVD sem limitador de fluxo. Coloquei a função de fluxo do NonStandard no lugar.
disp('Simulador TVD_NonStandard simples 2D');
disp('------------------------------------')
%------------------------VALORES INICIAIS----------------------------------
N = 100;
delty = 0.003;
deltx = 0.003;
deltt = 0.0005;
mio = 1;
miw = 1;
porosidade = 1;
tempo = input('Tempo: ');
disp('--------------Carregando------------')
Sw(1:N,1:N,1:tempo) = 0;
%--------------------------------------------------------------------------

%--------------------------------INJECAO-----------------------------------
% ESCOLHA A OPCAO DE INJECAO:
% 1 - FIVESPOT        2 - LINE
% 3 - POCO            4 - CUBO
injecao = 3;
if injecao == 1
    Sw(1,1,:) = 1;
    Sw(N,1,:) = 1;
    Sw(1,N,:) = 1;
    Sw(N,N,:) = 1;
elseif injecao == 2
    Sw(1,:,:) = 1;%Injecao tipo line
elseif injecao == 3
    Sw(N/2,N/2,:) = 1;%Poco de injecao na borda do reservatorio
elseif injecao == 4
    Sw(46:55,46:55,1) = 1; %cubo de agua sem injecao
end
%--------------------------------------------------------------------------

%-------------------------------CONTA--------------------------------------
for j = 1:1:tempo-1
    for i = 1:1:N
        for k = 1:1:N
            Fax = 0;
            Fbx = 0;
            Fay = 0;
            Fby = 0;
            Nax = 0;
            Nbx = 0;
            Nay = 0;
            Nby = 0;
            
            if i == 1
               Fax=Sw(i,k,j);
               Fbx=Sw(i,k,j);
            elseif i == N
               Nax=(Sw(i-1,k,j)^2)/((Sw(i-1,k,j)^2)+(miw/mio)*((1-Sw(i-1,k,j))^2));
               Fax=Sw(i-1,k,j)+.5*(Sw(i,k,j)-Sw(i-1,k,j))*Nax;%max(0,min(1,(Sw(i-1,k,j)-Sw(i-2,k,j),Sw(i,k,j)-Sw(i-1,k,j))))
               Fbx=Sw(i,k,j);
            else
               Nax=(Sw(i-1,k,j)^2)/((Sw(i-1,k,j)^2)+(miw/mio)*((1-Sw(i-1,k,j))^2));
               Fax=Sw(i-1,k,j)+.5*(Sw(i,k,j)-Sw(i-1,k,j))*Nax;%max(0,min(1,(Sw(i-1,k,j)-Sw(i-2,k,j),Sw(i,k,j)-Sw(i-1,k,j))))
               Nbx=(Sw(i+1,k,j)^2)/((Sw(i+1,k,j)^2)+(miw/mio)*((1-Sw(i+1,k,j))^2));
               Fbx=Sw(i,k,j)+.5*(Sw(i+1,k,j)-Sw(i,k,j))*Nbx;%max(0,min(1,(Sw(i,k,j)-Sw(i-1,k,j),Sw(i+1,k,j)-Sw(i,k,j))))
            end
             
            if k == 1
               Fay=Sw(i,k,j);
               Fby=Sw(i,k,j);
            elseif k == N
               Nay=(Sw(i,k-1,j)^2)/((Sw(i,k-1,j)^2)+(miw/mio)*((1-Sw(i,k-1,j))^2));
               Fay=Sw(i,k-1,j)+.5*(Sw(i,k,j)-Sw(i,k-1,j))*Nay;%max(0,min(1,(Sw(i,k-1,j)-Sw(i,k-2,j),Sw(i,k,j)-Sw(i,k-1,j))))
               Fby=Sw(i,k,j);
            else
               Nay=(Sw(i,k-1,j)^2)/((Sw(i,k-1,j)^2)+(miw/mio)*((1-Sw(i,k-1,j))^2));
               Fay=Sw(i,k-1,j)+.5*(Sw(i,k,j)-Sw(i,k-1,j))*Nay;%max(0,min(1,(Sw(i,k-1,j)-Sw(i,k-2,j),Sw(i,k,j)-Sw(i,k-1,j))))
               Nby=(Sw(i,k+1,j)^2)/((Sw(i,k+1,j)^2)+(miw/mio)*((1-Sw(i,k+1,j))^2));
               Fby=Sw(i,k,j)+.5*(Sw(i,k+1,j)-Sw(i,k,j))*Nby;%max(0,min(1,(Sw(i,k,j)-Sw(i,k-1,j),Sw(i,k+1,j)-Sw(i,k,j))))
            end
            
            Fx = ((Fax^2)/(Fax^2 + (miw/mio)*((1-Fax)^2))) - ((Fbx^2)/(Fbx^2 + (miw/mio)*((1-Fbx)^2)));
            Fy = ((Fay^2)/(Fay^2 + (miw/mio)*((1-Fay)^2))) - ((Fby^2)/(Fby^2 + (miw/mio)*((1-Fby)^2)));
            
            Sw(i,k,j+1) =  Sw(i,k,j) + ((Fx/deltx) + (Fy/delty))*deltt/porosidade;
        end
    end
end
%--------------------------------------------------------------------------

%--------------------------------VOLUME------------------------------------
volume = 0;
for x = 1:1:N
    for y = 1:1:N
        volume = volume + Sw(x,y,tempo);
    end
end
fprintf('O volume de agua no reservatorio é: %d', volume);
%--------------------------------------------------------------------------

%-------------------------------GRAFICO FINAL------------------------------
B(:,:) = Sw(:,:,tempo);                                                  %|
figure (1)                                                               %|
R=linspace(0,1,N);                                                       %|
surf(R,R,B(:,:))                                                         %|
xlabel('x')                                                              %|
ylabel('y')                                                              %|
zlabel('saturation')                                                     %|
colorbar                                                                 %|
%--------------------------------------------------------------------------

%---------------------------------ANIMACAO---------------------------------
for t=1:1:tempo                                                          %|
    for x=1:1:N                                                          %|
        for y=1:1:N                                                      %|
            B(x,y) = Sw(x,y,t);                                          %|
        end                                                              %|
    end                                                                  %|
        figure (2)                                                       %|
        surf(R,R,B(:,:));                                                %|
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

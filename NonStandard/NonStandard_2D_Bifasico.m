%Esquema Numérico NonStandard bidimensional
%Nelson Machado Barbosa
%Nicholas de A. Pinto
%Instituto Politécnico do Rio de Janeiro
%1.3.1 

%Definir os parâmetros
y = 0;
while y == 0
clear all;
close all;
clc;
disp('                   Esquema NonStandard')
disp('************************************************************')
N1 = 100;
deltx = 5;
delty = 5;
deltt = 1;
mio = 1;
miw = 1;
disp('* N1 = 100                          deltt = 1              *')
disp('* deltx = 5                         delty = 5              *')
disp('* Viscosidade agua = 1              Viscosidade oleo = 1   *')
disp('************************************************************')
mudarvalores = input('"1" para mudar valores acima: ');
if mudarvalores == 1
    N1 = input('Entre com a quantidade de células para o eixo x (N1): ');
    deltx = input('Entre com o valor de deltx: ');
    deltt = input('Entre com o valor de deltt: ');
    delty = input('Entre com o valor de delty: ');
    miw = input('Entre com a viscosidade da água: ');
    mio = input('Entre com a viscosidade do óleo: ');
end
c=miw/mio;
alpha = input('Entre com o valor de alpha, 2; 2.08; 2.97: ');
T1 = input('Entre com o valor para (T) tempo: ');
escolhaux = input('Entre com o valor de ux ("10" para aleatorio): ');
escolhauy = input('Entre com o valor de uy ("10" para aleatorio): ');
escolhaporosidade = input('Porosidade (Maior que 1 -> aleatorio): ');
if escolhaporosidade >1
    min = 0.25;
    max = 1;
    disp('Mín = 0.2          Máx = 1')
    esc = input('1 para mudar min ou máx: ');
    if esc == 1
        min = input('min: ');
        max = input('max: ');
    end
end
escolhainjecao = input('"1" - poço, "2" - Five Spot, "3" - Line: ');
y = input('"0" para colocar novos valores: ');
end
disp('************************************************************')
%**************************************************************************

%----------Definir as variaveis para maior velocidade----------------------
f1x(1:N1,1:N1) = 0;                                                      %|
f1y(1:N1,1:N1) = 0;                                                      %|
f2x(1:N1,1:N1) = 0;                                                      %|
f2y(1:N1,1:N1) = 0;                                                      %|
Gx(1:N1,1:N1) = 0;                                                       %|
Gy(1:N1,1:N1) = 0;                                                       %|
porosidade(1:N1,1:N1) = 0;                                               %|
B(1:N1,1:N1) = 0;                                                        %|
Sw(1:N1+1,1:N1+1,1)=0;                                                   %|
vx(1:N1,1:N1) = 0;                                                       %|
vy(1:N1,1:N1) = 0;                                                       %|
%--------------------------------^-----------------------------------------

phix=(1/(2*alpha))*((1-exp(-alpha*deltt/deltx)));
phiy=(1/(2*alpha))*((1-exp(-alpha*deltt/delty)));
 
%phix=(1/(2*alpha))*((1-abs(cos(alpha*deltt/deltx))));
%phiy=(1/(2*alpha))*((1-abs(cos(alpha*deltt/delty))));
 
%-----------------------------Porosidade-----------------------------------
 for i = 1:1:N1                                                          %|
     for k = 1:1:N1                                                      %|
         if escolhaporosidade > 1                                        %|
            porosidade(i,k) = rand(1);                                   %|
            while porosidade(i,k) < min || porosidade(i,k) > max         %|
                porosidade(i,k) = rand(1);                               %|
            end                                                          %|
         else                                                            %|
            porosidade(i,k) = escolhaporosidade;                         %|
         end                                                             %|
           if escolhauy == 10                                            %|
            vy(i,k) = 1-porosidade(i,k);                                 %|
           else                                                          %|
            vy(i,k) = escolhauy;                                         %|
           end                                                           %|
          if escolhaux == 10                                             %|
            vx(i,k) = 1-porosidade(i,k);                                 %|
          else                                                           %|
            vx(i,k) = escolhaux;                                         %|
          end                                                            %|
     end                                                                 %|
 end                                                                     %|
%--------------------------------^-----------------------------------------
disp('Loading...')
for j=1:1:T1
    
%-----------------------Mostrar a quanto já foi feito----------------------
    if rem(j,50) == 0                                                    %|
        ja = 100*j/T1;                                                   %|
        fprintf('%f', ja); disp('%');                                    %|
    end                                                                  %|
%--------------------------------^-----------------------------------------
    
%-------------------------Modo de injeção----------------------------------
    if escolhainjecao == 1 %poço                                         %|
        Sw(N1/2,N1/2,j)=1;                                               %|
    elseif escolhainjecao == 2   %Five Spot                              %|
        Sw(1,1,j) = 1;                                                   %|
        Sw(N1,1,j) = 1;                                                  %|
        Sw(1,N1,j) = 1;                                                  %|
        Sw(N1,N1,j) = 1;                                                 %|
    else %Line                                                           %|
        Sw(1,1:N1,j) = 1;                                                %|
        %Sw(1:N1,N1,j) = 1;                                               %|
    end                                                                  %|
%--------------------------------^-----------------------------------------
    
    
%---------------------------Início dos f__---------------------------------
    for k=N1:-1:1                    
        for i=N1:-1:1
            
            if i==N1 %ponto posterior
                f1x(i,k)= Sw(N1,k,j)*Sw(N1,k,j)/((Sw(N1,k,j)*Sw(N1,k,j))+(c*(1-Sw(N1,k,j))^2));
            else
                f1x(i,k)= Sw(i+1,k,j)*Sw(i+1,k,j)/((Sw(i+1,k,j)*Sw(i+1,k,j))+(c*(1-Sw(i+1,k,j))^2));
            end

            if k==N1 %ponto posterior
                f1y(i,k)= Sw(i,N1,j)*Sw(i,N1,j)/((Sw(i,N1,j)*Sw(i,N1,j))+(c*(1-Sw(i,N1,j))^2));
            else
                f1y(i,k)= Sw(i,k+1,j)*Sw(i,k+1,j)/((Sw(i,k+1,j)*Sw(i,k+1,j))+(c*(1-Sw(i,k+1,j))^2));
            end
            
        end
    end
    
    for k=1:1:N1                    
        for i=1:1:N1

            if i==1 %ponto anterior
                f2x(i,k)= Sw(1,k,j)*Sw(1,k,j)/((Sw(1,k,j)*Sw(1,k,j))+(c*(1-Sw(1,k,j))^2));
            else
                f2x(i,k)= Sw(i-1,k,j)*Sw(i-1,k,j)/((Sw(i-1,k,j)*Sw(i-1,k,j))+(c*(1-Sw(i-1,k,j))^2));   
            end

            if k==1 %ponto anterior
                f2y(i,k)= Sw(i,1,j)*Sw(i,1,j)/((Sw(i,1,j)*Sw(i,1,j))+(c*(1-Sw(i,1,j))^2));
            else
                f2y(i,k)= Sw(i,k-1,j)*Sw(i,k-1,j)/((Sw(i,k-1,j)*Sw(i,k-1,j))+(c*(1-Sw(i,k-1,j))^2));   
            end
        end
    end
%----------------------------Final dos f__---------------------------------
    
    
     for k=1:1:N1
        for i=1:1:N1
            if i == 1 
                %Gy
                if k == 1
                    if Sw(i,k,j)<Sw(i,k+1,j)
                        Gy(i,k) = vy(i,k)*phiy*(alpha*(Sw(i,k,j)-2*Sw(i,k,j)+Sw(i,k+1,j))+f1y(i,k)-f2y(i,k))*0.5/porosidade(i,k);
                    else
                        Gy(i,k) = vy(i,k)*phiy*(alpha*(Sw(i,k+1,j)-2*Sw(i,k,j)+Sw(i,k))-f1y(i,k)+f2y(i,k))*0.5/porosidade(i,k);
                    end
                elseif Sw(i,k,j)<Sw(i,k+1,j)
                        Gy(i,k) = vy(i,k)*phiy*(alpha*(Sw(i,k-1,j)-2*Sw(i,k,j)+Sw(i,k+1,j))+f1y(i,k)-f2y(i,k))*0.5/porosidade(i,k);
                elseif Sw(i,k,j)<Sw(i,k-1,j)
                        Gy(i,k) = vy(i,k)*phiy*(alpha*(Sw(i,k+1,j)-2*Sw(i,k,j)+Sw(i,k-1,j))-f1y(i,k)+f2y(i,k))*0.5/porosidade(i,k);
                end
                %Gx
                if  Sw(i,k,j)<Sw(i+1,k,j)
                    Gx(i,k) = vx(i,k)*phix*(alpha*(Sw(i,k,j)-2*Sw(i,k,j)+Sw(i+1,k,j))+f1x(i,k)-f2x(i,k))*0.5/porosidade(i,k);
                else
                    Gx(i,k) = vx(i,k)*phix*(alpha*(Sw(i+1,k,j)-2*Sw(i,k,j)+Sw(i,k,j))-f1x(i,k)+f2x(i,k))*0.5/porosidade(i,k);
                end
            elseif k == 1
                %Gx
                if i == 1
                    if  Sw(i,k,j)<Sw(i+1,k,j)
                        Gx(i,k) = vx(i,k)*phix*(alpha*(Sw(i,k,j)-2*Sw(i,k,j)+Sw(i+1,k,j))+f1x(i,k)-f2x(i,k))*0.5/porosidade(i,k);
                    else
                        Gx(i,k) = vx(i,k)*phix*(alpha*(Sw(i+1,k,j)-2*Sw(i,k,j)+Sw(i,k,j))-f1x(i,k)+f2x(i,k))*0.5/porosidade(i,k);
                    end
                elseif  Sw(i,k,j)<Sw(i+1,k,j)
                        Gx(i,k) = vx(i,k)*phix*(alpha*(Sw(i-1,k,j)-2*Sw(i,k,j)+Sw(i+1,k,j))+f1x(i,k)-f2x(i,k))*0.5/porosidade(i,k);
                else
                        Gx(i,k) = vx(i,k)*phix*(alpha*(Sw(i+1,k,j)-2*Sw(i,k,j)+Sw(i-1,k,j))-f1x(i,k)+f2x(i,k))*0.5/porosidade(i,k);
                end
                %Gy
                if Sw(i,k,j)<Sw(i,k+1,j)
                    Gy(i,k) = vy(i,k)*phiy*(alpha*(Sw(i,k,j)-2*Sw(i,k,j)+Sw(i,k+1,j))+f1y(i,k)-f2y(i,k))*0.5/porosidade(i,k);
                else
                    Gy(i,k) = vy(i,k)*phiy*(alpha*(Sw(i,k+1,j)-2*Sw(i,k,j)+Sw(i,k,j))-f1y(i,k)+f2y(i,k))*0.5/porosidade(i,k);
                end
            elseif i == N1 
                %Gy
                if k == N1
                    if Sw(i,k,j)<Sw(i,k+1,j)
                        Gy(i,k) = vy(i,k)*phiy*(alpha*(Sw(i,k-1,j)-2*Sw(i,k,j)+Sw(i,k,j))+f1y(i,k)-f2y(i,k))*0.5/porosidade(i,k);
                    else
                        Gy(i,k) = vy(i,k)*phiy*(alpha*(Sw(i,k,j)-2*Sw(i,k,j)+Sw(i,k-1,j))-f1y(i,k)+f2y(i,k))*0.5/porosidade(i,k);
                    end
                elseif Sw(i,k,j)<Sw(i,k+1,j)
                        Gy(i,k) = vy(i,k)*phiy*(alpha*(Sw(i,k-1,j)-2*Sw(i,k,j)+Sw(i,k+1,j))+f1y(i,k)-f2y(i,k))*0.5/porosidade(i,k);
                elseif Sw(i,k,j)<Sw(i,k-1,j)
                        Gy(i,k) = vy(i,k)*phiy*(alpha*(Sw(i,k+1,j)-2*Sw(i,k,j)+Sw(i,k-1,j))-f1y(i,k)+f2y(i,k))*0.5/porosidade(i,k);
                end
                %Gx
                if  Sw(i,k,j)<Sw(i+1,k,j)
                    Gx(i,k) = vx(i,k)*phix*(alpha*(Sw(i-1,k,j)-2*Sw(i,k,j)+Sw(i,k,j))+f1x(i,k)-f2x(i,k))*0.5/porosidade(i,k);
                else
                    Gx(i,k) = vx(i,k)*phix*(alpha*(Sw(i,k,j)-2*Sw(i,k,j)+Sw(i-1,k,j))-f1x(i,k)+f2x(i,k))*0.5/porosidade(i,k);
                end
            elseif k == N1
                %Gx
                if i == N1
                    if  Sw(i,k,j)<Sw(i+1,k,j)
                        Gx(i,k) = vx(i,k)*phix*(alpha*(Sw(i-1,k,j)-2*Sw(i,k,j)+Sw(i,k,j))+f1x(i,k)-f2x(i,k))*0.5/porosidade(i,k);
                    else
                        Gx(i,k) = vx(i,k)*phix*(alpha*(Sw(i,k,j)-2*Sw(i,k,j)+Sw(i-1,k,j))-f1x(i,k)+f2x(i,k))*0.5/porosidade(i,k);
                    end
                elseif  Sw(i,k,j)<Sw(i+1,k,j)
                        Gx(i,k) = vx(i,k)*phix*(alpha*(Sw(i-1,k,j)-2*Sw(i,k,j)+Sw(i+1,k,j))+f1x(i,k)-f2x(i,k))*0.5/porosidade(i,k);
                else
                        Gx(i,k) = vx(i,k)*phix*(alpha*(Sw(i+1,k,j)-2*Sw(i,k,j)+Sw(i-1,k,j))-f1x(i,k)+f2x(i,k))*0.5/porosidade(i,k);
                end
                %Gy
                if Sw(i,k,j)<Sw(i,k+1,j)
                    Gy(i,k) = vy(i,k)*phiy*(alpha*(Sw(i,k-1,j)-2*Sw(i,k,j)+Sw(i,k,j))+f1y(i,k)-f2y(i,k))*0.5/porosidade(i,k);
                else
                    Gy(i,k) = vy(i,k)*phiy*(alpha*(Sw(i,k,j)-2*Sw(i,k,j)+Sw(i,k-1,j))-f1y(i,k)+f2y(i,k))*0.5/porosidade(i,k);
                end


            else
                %Gx
                if Sw(i,k,j)<Sw(i-1,k,j)
                    Gx(i,k) = vx(i,k)*phix*(alpha*(Sw(i+1,k,j)-2*Sw(i,k,j)+Sw(i-1,k,j))-f1x(i,k)+f2x(i,k))*0.5/porosidade(i,k);
                elseif Sw(i,k,j)<Sw(i+1,k,j)
                    Gx(i,k) = vx(i,k)*phix*(alpha*(Sw(i-1,k,j)-2*Sw(i,k,j)+Sw(i+1,k,j))+f1x(i,k)-f2x(i,k))*0.5/porosidade(i,k);
                end
                %Gy
                if Sw(i,k,j)<Sw(i,k-1,j)
                    Gy(i,k) = vy(i,k)*phiy*(alpha*(Sw(i,k+1,j)-2*Sw(i,k,j)+Sw(i,k-1,j))-f1y(i,k)+f2y(i,k))*0.5/porosidade(i,k);  
                elseif Sw(i,k,j)<Sw(i,k+1,j)
                    Gy(i,k) = vy(i,k)*phiy*(alpha*(Sw(i,k-1,j)-2*Sw(i,k,j)+Sw(i,k+1,j))+f1y(i,k)-f2y(i,k))*0.5/porosidade(i,k); 
                end
            end
        end
     end
    
    for k=1:1:N1
        for i=1:1:N1
                Sw(i,k,j+1)= Sw(i,k,j)+Gx(i,k)+Gy(i,k);            
            if j==T1
                B(i,k)=Sw(i,k,T1);
            end

        end
    end
 
end
%-------------------------------Gráfico Final------------------------------
figure (1)                                                               %|
R1=linspace(0,1,N1);                                                     %|
%R2=linspace(0,1,N1);                                                     %|
surf(R1,R1,B(:,:))                                                       %|
xlabel('x')                                                              %|
ylabel('y')                                                              %|
zlabel('saturation')                                                     %|
colorbar                                                                 %|
%--------------------------------------------------------------------------

%-----------------------------Gráfico Porosidade---------------------------
if escolhaporosidade > 1                                                 %|
    figure (3)                                                           %|
    surf(R1,R1,porosidade(:,:))                                          %|
    az = 0;                                                              %|
    el = 90;                                                             %|
    view(az, el);                                                        %|
    xlabel('x')                                                          %|
    ylabel('y')                                                          %|
    zlabel('porosity')                                                   %|
    colorbar                                                             %|
    colormap(gray)                                                       %|
end                                                                      %|
%--------------------------------------------------------------------------

%---------------------------------Animação---------------------------------
for j=1:1:T1                                                             %|
    for k=1:1:N1                                                         %|
        for i=1:1:N1                                                     %|
            B(i,k) = Sw(i,k,j);                                          %|
        end                                                              %|
    end                                                                  %|
        figure (2)                                                       %|
        surf(R1,R1,B(:,:));                                              %|
        az = 0;                                                          %|
        el = 90;                                                         %|
        view(az, el);                                                    %|
        colorbar                                                         %|
        anima(j) = getframe;                                             %|
        xlabel('x')                                                      %|
        ylabel('y')                                                      %|
        zlabel('saturation')                                             %|
end                                                                      %|
movie(anima,3,20)                                                        %|
%--------------------------------------------------------------------------

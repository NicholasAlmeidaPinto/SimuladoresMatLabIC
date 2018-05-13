%Esquema Numérico NonStandard bidimensional
%Nelson Machado Barbosa
%Instituto Politécnico do Rio de Janeiro
%2.3.1 

%Definir os parâmetros
y = 0;
while y == 0
clear all;
close all;
clc;
disp('                   Esquema NonStandard')
disp('************************************************************')
N1 = 100;
N1z = 20;
deltx = 5;
delty = 5;
deltz = 5;
deltt = 1;
mio = 1;
miw = 1;
alpha = 2;
disp('* N1 = 100                          deltt = 1              *')
disp('* deltx = 5                         delty = 5              *')
disp('* deltz = 5                                                *')
disp('* Viscosidade agua = 1              Viscosidade oleo = 1   *')
disp('* Alpha = 2                                                *')
disp('************************************************************')
mudarvalores = input('"1" para mudar valores acima: ');
if mudarvalores == 1
    N1 = input('Entre com a quantidade de células para o eixo x (N1): ');
    deltx = input('Entre com o valor de deltx: ');
    deltt = input('Entre com o valor de deltt: ');
    delty = input('Entre com o valor de delty: ');
    miw = input('Entre com a viscosidade da água: ');
    mio = input('Entre com a viscosidade do óleo: ');
    alpha = input('Entre com o valor de alpha, 2; 2.08; 2.97: ');
end
c=miw/mio;
T1 = input('Entre com o valor para (T) tempo: ');
escolhaux = input('Entre com o valor de ux ("10" para aleatorio): ');
escolhauy = input('Entre com o valor de uy ("10" para aleatorio): ');
escolhauz = input('Entre com o valor de uz ("10" para aleatorio): ');
escolhaporosidade = input('Porosidade (Maior que 1 -> aleatorio): ');
if escolhaporosidade >1
    min = 0.3;
    max = 1;
    disp('Mín = 0.3          Máx = 1')
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
f1z(1:N1,1:N1) = 0;                                                      %|
f2x(1:N1,1:N1) = 0;                                                      %|
f2y(1:N1,1:N1) = 0;                                                      %|
f2z(1:N1,1:N1) = 0;                                                      %|
Gx(1:N1,1:N1) = 0;                                                       %|
Gy(1:N1,1:N1) = 0;                                                       %|
Gz(1:N1,1:N1) = 0;                                                       %|
porosidade(1:N1,1:N1,1:N1z) = 0;                                         %|
B(1:N1,1:N1) = 0;                                                        %|
Sw(1:N1+1,1:N1+1,1:N1z+1,1)=0;                                           %|
vx(1:N1,1:N1) = 0;                                                       %|
vy(1:N1,1:N1) = 0;                                                       %|
vz(1:N1z,1:N1z) = 0;                                                     %|
%--------------------------------^-----------------------------------------

phix=(1/(2*alpha))*((1-exp(-alpha*deltt/deltx)));
phiy=(1/(2*alpha))*((1-exp(-alpha*deltt/delty)));
phiz=(1/(2*alpha))*((1-exp(-alpha*deltt/deltz)));
 
%phix=(1/(2*alpha))*((1-abs(cos(alpha*deltt/deltx))));
%phiy=(1/(2*alpha))*((1-abs(cos(alpha*deltt/delty))));
 
%-----------------------------Porosidade-----------------------------------
 for i = 1:1:N1                                                          %|
     for k = 1:1:N1                                                      %|
         for z = 1:1:N1z                                                 %|
             if escolhaporosidade > 1                                    %|
                porosidade(i,k,z) = rand(1);                             %|
                while porosidade(i,k,z) < min || porosidade(i,k,z) > max %|
                    porosidade(i,k,z) = rand(1);                         %|
                end                                                      %|
             else                                                        %|
                porosidade(i,k,z) = escolhaporosidade;                   %|
             end                                                         %|
               if escolhauy == 10                                        %|
                vy(i,k,z) = 1-porosidade(i,k,z);                         %|
               else                                                      %|
                vy(i,k,z) = escolhauy;                                   %|
               end                                                       %|
              if escolhaux == 10                                         %|
                vx(i,k,z) = 1-porosidade(i,k,z);                         %|
              else                                                       %|
                vx(i,k,z) = escolhaux;                                   %|
              end                                                        %|
              if escolhauz == 10                                         %|
                vz(i,k,z) = 1-porosidade(i,k,z);                         %|
               else                                                      %|
                vz(i,k,z) = escolhauz;                                   %|
               end                                                       %|
         end                                                             %|
     end                                                                 %|
 end                                                                     %|
%--------------------------------^-----------------------------------------
disp('Loading...')
for j=1:1:T1
    
%-----------------------Mostrar a quanto já foi feito----------------------
    if rem(j,10) == 0                                                    %|
        ja = 100*j/T1;                                                   %|
        fprintf('%f', ja); disp('%');                                    %|
    end                                                                  %|
%--------------------------------^-----------------------------------------
    
%-------------------------Modo de injeção----------------------------------
    if escolhainjecao == 1 %poço                                         %|
        Sw(N1/2,N1/2,N1z/2,j)=1;                                         %|
    elseif escolhainjecao == 2   %Five Spot                              %|
        Sw(1,1,1,j) = 1;                                                 %|
        Sw(N1,1,1,j) = 1;                                                %|
        Sw(1,N1,1,j) = 1;                                                %|
        Sw(N1,N1,1,j) = 1;                                               %|
    else %Line                                                           %|
        Sw(1:N1,1,1,j) = 1;                                              %|
        Sw(1:N1,N1,1,j) = 1;                                             %|
    end                                                                  %|
%--------------------------------^-----------------------------------------
    
    
%---------------------------Início dos f__---------------------------------
    for k=N1:-1:1                    
        for i=N1:-1:1
            for z=N1z:-1:1
            
            if i==N1 %ponto posterior
                f1x(i,k,z)= Sw(N1,k,z,j)*Sw(N1,k,z,j)/((Sw(N1,k,z,j)*Sw(N1,k,z,j))+(c*(1-Sw(N1,k,z,j))^2));
            else
                f1x(i,k,z)= Sw(i+1,k,z,j)*Sw(i+1,k,z,j)/((Sw(i+1,k,z,j)*Sw(i+1,k,z,j))+(c*(1-Sw(i+1,k,z,j))^2));
            end

            if k==N1 %ponto posterior
                f1y(i,k,z)= Sw(i,N1,z,j)*Sw(i,N1,z,j)/((Sw(i,N1,z,j)*Sw(i,N1,z,j))+(c*(1-Sw(i,N1,z,j))^2));
            else
                f1y(i,k,z)= Sw(i,k+1,z,j)*Sw(i,k+1,z,j)/((Sw(i,k+1,z,j)*Sw(i,k+1,z,j))+(c*(1-Sw(i,k+1,z,j))^2));
            end
            
            if z==N1 %ponto posterior
                f1z(i,k,z)= Sw(i, k,N1,j)*Sw(i,k,N1,j)/((Sw(i,k,N1,j)*Sw(i,k,N1,j))+(c*(1-Sw(i,k,N1,j))^2));
            else
                f1z(i,k,z)= Sw(i,k,z+1,j)*Sw(i,k,z+1,j)/((Sw(i,k,z+1,j)*Sw(i,k,z+1,j))+(c*(1-Sw(i,k,z+1,j))^2));
            end
            
            end
        end
    end
    
    for k=1:1:N1                    
        for i=1:1:N1
            for z=1:1:N1z
                if i==1 %ponto anterior
                    f2x(i,k,z)= Sw(1,k,z,j)*Sw(1,k,z,j)/((Sw(1,k,z,j)*Sw(1,k,z,j))+(c*(1-Sw(1,k,z,j))^2));
                else
                    f2x(i,k,z)= Sw(i-1,k,z,j)*Sw(i-1,k,z,j)/((Sw(i-1,k,z,j)*Sw(i-1,k,z,j))+(c*(1-Sw(i-1,k,z,j))^2));   
                end

                if k==1 %ponto anterior
                    f2y(i,k,z)= Sw(i,1,z,j)*Sw(i,1,z,j)/((Sw(i,1,z,j)*Sw(i,1,z,j))+(c*(1-Sw(i,1,z,j))^2));
                else
                    f2y(i,k,z)= Sw(i,k-1,z,j)*Sw(i,k-1,z,j)/((Sw(i,k-1,z,j)*Sw(i,k-1,z,j))+(c*(1-Sw(i,k-1,z,j))^2));   
                end
                if z==1 %ponto anterior
                    f2z(i,k,z)= Sw(i,k,1,j)*Sw(i,k,1,j)/((Sw(i,k,1,j)*Sw(i,k,1,j))+(c*(1-Sw(i,k,1,j))^2));
                else
                    f2z(i,k,z)= Sw(i,k,z-1,j)*Sw(i,k,z-1,j)/((Sw(i,k,z-1,j)*Sw(i,k,z-1,j))+(c*(1-Sw(i,k,z-1,j))^2));   
                end
            end
        end
    end
%----------------------------Final dos f__---------------------------------
    
    
     for k=1:1:N1
        for i=1:1:N1
            for z=1:1:N1z
                if i == 1%Gx
                    %Gy
                    if k == 1
                        if Sw(i,k,z,j)<Sw(i,k+1,z,j)
                            Gy(i,k,z) = vy(i,k,z)*phiy*(alpha*(Sw(i,k,z,j)-2*Sw(i,k,z,j)+Sw(i,k+1,z,j))+f1y(i,k,z)-f2y(i,k,z))*0.5/porosidade(i,k,z);
                        else
                            Gy(i,k,z) = vy(i,k,z)*phiy*(alpha*(Sw(i,k+1,z,j)-2*Sw(i,k,z,j)+Sw(i,k,z,j))-f1y(i,k,z)+f2y(i,k,z))*0.5/porosidade(i,k,z);
                        end
                    elseif Sw(i,k,z,j)<Sw(i,k+1,z,j)
                            Gy(i,k,z) = vy(i,k,z)*phiy*(alpha*(Sw(i,k-1,z,j)-2*Sw(i,k,z,j)+Sw(i,k+1,z,j))+f1y(i,k,z)-f2y(i,k,z))*0.5/porosidade(i,k,z);
                    elseif Sw(i,k,z,j)<Sw(i,k-1,z,j)
                            Gy(i,k,z) = vy(i,k,z)*phiy*(alpha*(Sw(i,k+1,z,j)-2*Sw(i,k,z,j)+Sw(i,k-1,z,j))-f1y(i,k,z)+f2y(i,k,z))*0.5/porosidade(i,k,z);
                    end
                    %Gz
                    if z == 1
                        if Sw(i,k,z,j)<Sw(i,k,z+1,j)
                            Gz(i,k,z) = vz(i,k,z)*phiz*(alpha*(Sw(i,k,z,j)-2*Sw(i,k,z,j)+Sw(i,k,z+1,j))+f1z(i,k,z)-f2z(i,k,z))*0.5/porosidade(i,k,z);
                        else
                            Gz(i,k,z) = vz(i,k,z)*phiz*(alpha*(Sw(i,k,z+1,j)-2*Sw(i,k,z,j)+Sw(i,k,z,j))-f1z(i,k,z)+f2z(i,k,z))*0.5/porosidade(i,k,z);
                        end
                    elseif Sw(i,k,z,j)<Sw(i,k,z+1,j)
                            Gz(i,k,z) = vz(i,k,z)*phiz*(alpha*(Sw(i,k,z-1,j)-2*Sw(i,k,z,j)+Sw(i,k,z+1,j))+f1z(i,k,z)-f2z(i,k,z))*0.5/porosidade(i,k,z);
                    elseif Sw(i,k,z,j)<Sw(i,k,z-1,j)
                            Gz(i,k,z) = vz(i,k,z)*phiz*(alpha*(Sw(i,k,z+1,j)-2*Sw(i,k,z,j)+Sw(i,k,z-1,j))-f1z(i,k,z)+f2z(i,k,z))*0.5/porosidade(i,k,z);
                    end
                    %Gx
                    if  Sw(i,k,z,j)<Sw(i+1,k,z,j)
                        Gx(i,k,z) = vx(i,k,z)*phix*(alpha*(Sw(i,k,z,j)-2*Sw(i,k,z,j)+Sw(i+1,k,z,j))+f1x(i,k,z)-f2x(i,k,z))*0.5/porosidade(i,k,z);
                    else
                        Gx(i,k,z) = vx(i,k,z)*phix*(alpha*(Sw(i+1,k,z,j)-2*Sw(i,k,z,j)+Sw(i,k,z,j))-f1x(i,k,z)+f2x(i,k,z))*0.5/porosidade(i,k,z);
                    end

                elseif k == 1%Gy
                    %Gx
                    if i == 1
                        if  Sw(i,k,z,j)<Sw(i+1,k,z,j)
                            Gx(i,k,z) = vx(i,k,z)*phix*(alpha*(Sw(i,k,z,j)-2*Sw(i,k,z,j)+Sw(i+1,k,z,j))+f1x(i,k,z)-f2x(i,k,z))*0.5/porosidade(i,k,z);
                        else
                            Gx(i,k,z) = vx(i,k,z)*phix*(alpha*(Sw(i+1,k,z,j)-2*Sw(i,k,z,j)+Sw(i,k,z,j))-f1x(i,k,z)+f2x(i,k,z))*0.5/porosidade(i,k,z);
                        end
                    elseif  Sw(i,k,z,j)<Sw(i+1,k,z,j)
                            Gx(i,k,z) = vx(i,k,z)*phix*(alpha*(Sw(i-1,k,z,j)-2*Sw(i,k,z,j)+Sw(i+1,k,z,j))+f1x(i,k,z)-f2x(i,k,z))*0.5/porosidade(i,k,z);
                    else
                            Gx(i,k,z) = vx(i,k,z)*phix*(alpha*(Sw(i+1,k,z,j)-2*Sw(i,k,z,j)+Sw(i-1,k,z,j))-f1x(i,k,z)+f2x(i,k,z))*0.5/porosidade(i,k,z);
                    end
                    %Gz
                    if z == 1
                        if  Sw(i,k,z,j)<Sw(i,k,z+1,j)
                            Gz(i,k,z) = vz(i,k,z)*phiz*(alpha*(Sw(i,k,z,j)-2*Sw(i,k,z,j)+Sw(i,k,z+1,j))+f1z(i,k,z)-f2z(i,k,z))*0.5/porosidade(i,k,z);
                        else
                            Gz(i,k,z) = vz(i,k,z)*phiz*(alpha*(Sw(i,k,z+1,j)-2*Sw(i,k,z,j)+Sw(i,k,z,j))-f1z(i,k,z)+f2z(i,k,z))*0.5/porosidade(i,k,z);
                        end
                    elseif  Sw(i,k,z,j)<Sw(i,k,z+1,j)
                            Gz(i,k,z) = vz(i,k,z)*phiz*(alpha*(Sw(i,k,z-1,j)-2*Sw(i,k,z,j)+Sw(i,k,z+1,j))+f1z(i,k,z)-f2z(i,k,z))*0.5/porosidade(i,k,z);
                    else
                            Gz(i,k,z) = vz(i,k,z)*phiz*(alpha*(Sw(i,k,z+1,j)-2*Sw(i,k,z,j)+Sw(i,k,z-1,j))-f1z(i,k,z)+f2z(i,k,z))*0.5/porosidade(i,k,z);
                    end
                    %Gy
                    if Sw(i,k,z,j)<Sw(i,k+1,z,j)
                        Gy(i,k,z) = vy(i,k,z)*phiy*(alpha*(Sw(i,k,z,j)-2*Sw(i,k,z,j)+Sw(i,k+1,z,j))+f1y(i,k,z)-f2y(i,k,z))*0.5/porosidade(i,k,z);
                    else
                        Gy(i,k,z) = vy(i,k,z)*phiy*(alpha*(Sw(i,k+1,z,j)-2*Sw(i,k,z,j)+Sw(i,k,z,j))-f1y(i,k,z)+f2y(i,k,z))*0.5/porosidade(i,k,z);
                    end

                elseif z == 1%Gz
                    %Gx
                    if i == 1
                        if  Sw(i,k,z,j)<Sw(i+1,k,z,j)
                            Gx(i,k,z) = vx(i,k,z)*phix*(alpha*(Sw(i,k,z,j)-2*Sw(i,k,z,j)+Sw(i+1,k,z,j))+f1x(i,k,z)-f2x(i,k,z))*0.5/porosidade(i,k,z);
                        else
                            Gx(i,k,z) = vx(i,k,z)*phix*(alpha*(Sw(i+1,k,z,j)-2*Sw(i,k,z,j)+Sw(i,k,z,j))-f1x(i,k,z)+f2x(i,k,z))*0.5/porosidade(i,k,z);
                        end
                    elseif  Sw(i,k,z,j)<Sw(i+1,k,z,j)
                            Gx(i,k,z) = vx(i,k,z)*phix*(alpha*(Sw(i-1,k,z,j)-2*Sw(i,k,z,j)+Sw(i+1,k,z,j))+f1x(i,k,z)-f2x(i,k,z))*0.5/porosidade(i,k,z);
                    else
                            Gx(i,k,z) = vx(i,k,z)*phix*(alpha*(Sw(i+1,k,z,j)-2*Sw(i,k,z,j)+Sw(i-1,k,z,j))-f1x(i,k,z)+f2x(i,k,z))*0.5/porosidade(i,k,z);
                    end
                    %Gy
                    if k == 1
                        if  Sw(i,k,z,j)<Sw(i,k+1,z,j)
                            Gy(i,k,z) = vy(i,k,z)*phiy*(alpha*(Sw(i,k,z,j)-2*Sw(i,k,z,j)+Sw(i,k+1,z,j))+f1y(i,k,z)-f2y(i,k,z))*0.5/porosidade(i,k,z);
                        else
                            Gy(i,k,z) = vy(i,k,z)*phiy*(alpha*(Sw(i,k+1,z,j)-2*Sw(i,k,z,j)+Sw(i,k,z,j))-f1y(i,k,z)+f2y(i,k,z))*0.5/porosidade(i,k,z);
                        end
                    elseif  Sw(i,k,z,j)<Sw(i,k+1,z,j)
                            Gy(i,k,z) = vy(i,k,z)*phiy*(alpha*(Sw(i,k-1,z,j)-2*Sw(i,k,z,j)+Sw(i,k+1,z,j))+f1y(i,k,z)-f2y(i,k,z))*0.5/porosidade(i,k,z);
                    else
                            Gy(i,k,z) = vy(i,k,z)*phiy*(alpha*(Sw(i,k+1,z,j)-2*Sw(i,k,z,j)+Sw(i,k-1,z,j))-f1y(i,k,z)+f2y(i,k,z))*0.5/porosidade(i,k,z);
                    end
                    %Gz
                    if Sw(i,k,z,j)<Sw(i,k,z+1,j)
                        Gz(i,k,z) = vz(i,k,z)*phiz*(alpha*(Sw(i,k,z,j)-2*Sw(i,k,z,j)+Sw(i,k,z+1,j))+f1z(i,k,z)-f2z(i,k,z))*0.5/porosidade(i,k,z);
                    else
                        Gz(i,k,z) = vz(i,k,z)*phiz*(alpha*(Sw(i,k,z+1,j)-2*Sw(i,k,z,j)+Sw(i,k,z,j))-f1z(i,k,z)+f2z(i,k,z))*0.5/porosidade(i,k,z);
                    end
                elseif i == N1 
                    %Gy
                    if k == N1
                        if Sw(i,k,z,j)<Sw(i,k+1,z,j)
                            Gy(i,k,z) = vy(i,k,z)*phiy*(alpha*(Sw(i,k-1,z,j)-2*Sw(i,k,z,j)+Sw(i,k,z,j))+f1y(i,k,z)-f2y(i,k,z))*0.5/porosidade(i,k,z);
                        else
                            Gy(i,k,z) = vy(i,k,z)*phiy*(alpha*(Sw(i,k,z,j)-2*Sw(i,k,z,j)+Sw(i,k-1,z,j))-f1y(i,k,z)+f2y(i,k,z))*0.5/porosidade(i,k,z);
                        end
                    elseif Sw(i,k,z,j)<Sw(i,k+1,z,j)
                            Gy(i,k,z) = vy(i,k,z)*phiy*(alpha*(Sw(i,k-1,z,j)-2*Sw(i,k,z,j)+Sw(i,k+1,z,j))+f1y(i,k,z)-f2y(i,k,z))*0.5/porosidade(i,k,z);
                    elseif Sw(i,k,j)<Sw(i,k-1,j)
                            Gy(i,k,z) = vy(i,k,z)*phiy*(alpha*(Sw(i,k+1,z,j)-2*Sw(i,k,z,j)+Sw(i,k-1,z,j))-f1y(i,k,z)+f2y(i,k,z))*0.5/porosidade(i,k,z);
                    end
                    %Gz
                    if z == N1
                        if Sw(i,k,z,j)<Sw(i,k,z+1,j)
                            Gy(i,k,z) = vz(i,k,z)*phiz*(alpha*(Sw(i,k,z-1,j)-2*Sw(i,k,z,j)+Sw(i,k,z,j))+f1z(i,k,z)-f2z(i,k,z))*0.5/porosidade(i,k,z);
                        else
                            Gy(i,k,z) = vz(i,k,z)*phiz*(alpha*(Sw(i,k,z,j)-2*Sw(i,k,z,j)+Sw(i,k,z-1,j))-f1z(i,k,z)+f2z(i,k,z))*0.5/porosidade(i,k,z);
                        end
                    elseif Sw(i,k,z,j)<Sw(i,k,z+1,j)
                            Gz(i,k,z) = vz(i,k,z)*phiz*(alpha*(Sw(i,k,z-1,j)-2*Sw(i,k,z,j)+Sw(i,k,z+1,j))+f1z(i,k,z)-f2z(i,k,z))*0.5/porosidade(i,k,z);
                    elseif Sw(i,k,j)<Sw(i,k-1,j)
                            Gz(i,k,z) = vz(i,k,z)*phiz*(alpha*(Sw(i,k,z+1,j)-2*Sw(i,k,z,j)+Sw(i,k,z-1,j))-f1z(i,k,z)+f2z(i,k,z))*0.5/porosidade(i,k,z);
                    end
                    %Gx
                    if  Sw(i,k,z,j)<Sw(i+1,k,z,j)
                        Gx(i,k,z) = vx(i,k,z)*phix*(alpha*(Sw(i-1,k,z,j)-2*Sw(i,k,z,j)+Sw(i,k,z,j))+f1x(i,k,z)-f2x(i,k,z))*0.5/porosidade(i,k,z);
                    else
                        Gx(i,k,z) = vx(i,k,z)*phix*(alpha*(Sw(i,k,z,j)-2*Sw(i,k,z,j)+Sw(i-1,k,z,j))-f1x(i,k,z)+f2x(i,k,z))*0.5/porosidade(i,k,z);
                    end
                elseif k == N1
                    %Gx
                    if i == N1
                        if  Sw(i,k,z,j)<Sw(i+1,k,z,j)
                            Gx(i,k,z) = vx(i,k,z)*phix*(alpha*(Sw(i-1,k,z,j)-2*Sw(i,k,z,j)+Sw(i,k,z,j))+f1x(i,k,z)-f2x(i,k,z))*0.5/porosidade(i,k,z);
                        else
                            Gx(i,k,z) = vx(i,k,z)*phix*(alpha*(Sw(i,k,z,j)-2*Sw(i,k,z,j)+Sw(i-1,k,z,j))-f1x(i,k,z)+f2x(i,k,z))*0.5/porosidade(i,k,z);
                        end
                    elseif  Sw(i,k,z,j)<Sw(i+1,k,z,j)
                            Gx(i,k,z) = vx(i,k,z)*phix*(alpha*(Sw(i-1,k,z,j)-2*Sw(i,k,z,j)+Sw(i+1,k,z,j))+f1x(i,k,z)-f2x(i,k,z))*0.5/porosidade(i,k,z);
                    else
                            Gx(i,k,z) = vx(i,k,z)*phix*(alpha*(Sw(i+1,k,z,j)-2*Sw(i,k,z,j)+Sw(i-1,k,z,j))-f1x(i,k,z)+f2x(i,k,z))*0.5/porosidade(i,k,z);
                    end
                    %Gz
                    if z == N1
                        if  Sw(i,k,z,j)<Sw(i,k,z+1,j)
                            Gz(i,k,z) = vz(i,k,z)*phiz*(alpha*(Sw(i,k,z-1,j)-2*Sw(i,k,z,j)+Sw(i,k,z,j))+f1z(i,k,z)-f2z(i,k,z))*0.5/porosidade(i,k,z);
                        else
                            Gz(i,k,z) = vz(i,k,z)*phiz*(alpha*(Sw(i,k,z,j)-2*Sw(i,k,z,j)+Sw(i,k,z-1,j))-f1z(i,k,z)+f2z(i,k,z))*0.5/porosidade(i,k,z);
                        end
                    elseif  Sw(i,k,z,j)<Sw(i,k,z+1,j)
                            Gz(i,k,z) = vz(i,k,z)*phiz*(alpha*(Sw(i,k,z-1,j)-2*Sw(i,k,z,j)+Sw(i,k,z+1,j))+f1z(i,k,z)-f2z(i,k,z))*0.5/porosidade(i,k,z);
                    else
                            Gz(i,k,z) = vz(i,k,z)*phiz*(alpha*(Sw(i,k,z+1,j)-2*Sw(i,k,z,j)+Sw(i,k,z-1,j))-f1z(i,k,z)+f2z(i,k,z))*0.5/porosidade(i,k,z);
                    end
                    %Gy
                    if Sw(i,k,z,j)<Sw(i,k+1,z,j)
                        Gy(i,k,z) = vy(i,k,z)*phiy*(alpha*(Sw(i,k-1,z,j)-2*Sw(i,k,z,j)+Sw(i,k,z,j))+f1y(i,k,z)-f2y(i,k,z))*0.5/porosidade(i,k,z);
                    else
                        Gy(i,k,z) = vy(i,k,z)*phiy*(alpha*(Sw(i,k,z,j)-2*Sw(i,k,z,j)+Sw(i,k-1,z,j))-f1y(i,k,z)+f2y(i,k,z))*0.5/porosidade(i,k,z);
                    end

                elseif z == N1
                    %Gx
                    if i == N1
                        if  Sw(i,k,z,j)<Sw(i+1,k,z,j)
                            Gx(i,k,z) = vx(i,k,z)*phix*(alpha*(Sw(i-1,k,z,j)-2*Sw(i,k,z,j)+Sw(i,k,z,j))+f1x(i,k,z)-f2x(i,k,z))*0.5/porosidade(i,k,z);
                        else
                            Gx(i,k,z) = vx(i,k,z)*phix*(alpha*(Sw(i,k,z,j)-2*Sw(i,k,z,j)+Sw(i-1,k,z,j))-f1x(i,k,z)+f2x(i,k,z))*0.5/porosidade(i,k,z);
                        end
                    elseif  Sw(i,k,z,j)<Sw(i+1,k,z,j)
                            Gx(i,k,z) = vx(i,k,z)*phix*(alpha*(Sw(i-1,k,z,j)-2*Sw(i,k,z,j)+Sw(i+1,k,z,j))+f1x(i,k,z)-f2x(i,k,z))*0.5/porosidade(i,k,z);
                    else
                            Gx(i,k,z) = vx(i,k,z)*phix*(alpha*(Sw(i+1,k,z,j)-2*Sw(i,k,z,j)+Sw(i-1,k,z,j))-f1x(i,k,z)+f2x(i,k,z))*0.5/porosidade(i,k,z);
                    end
                    %Gy
                    if k == N1
                        if  Sw(i,k,j)<Sw(i,k+1,j)
                            Gy(i,k,z) = vy(i,k,z)*phiy*(alpha*(Sw(i,k-1,z,j)-2*Sw(i,k,z,j)+Sw(i,k,z,j))+f1y(i,k,z)-f2y(i,k,z))*0.5/porosidade(i,k,z);
                        else
                            Gy(i,k,z) = vy(i,k,z)*phix*(alpha*(Sw(i,k,z,j)-2*Sw(i,k,z,j)+Sw(i,k-1,z,j))-f1y(i,k,z)+f2y(i,k,z))*0.5/porosidade(i,k,z);
                        end
                    elseif  Sw(i,k,z,j)<Sw(i,k+1,z,j)
                            Gy(i,k,z) = vy(i,k,z)*phiy*(alpha*(Sw(i,k-1,z,j)-2*Sw(i,k,z,j)+Sw(i,k+1,z,j))+f1y(i,k,z)-f2y(i,k,z))*0.5/porosidade(i,k,z);
                    else
                            Gy(i,k,z) = vy(i,k,z)*phiy*(alpha*(Sw(i,k+1,z,j)-2*Sw(i,k,z,j)+Sw(i,k-1,z,j))-f1y(i,k,z)+f2y(i,k,z))*0.5/porosidade(i,k,z);
                    end
                    %Gz
                    if Sw(i,k,z,j)<Sw(i,k,z+1,j)
                        Gz(i,k,z) = vz(i,k,z)*phiz*(alpha*(Sw(i,k,z-1,j)-2*Sw(i,k,z,j)+Sw(i,k,z,j))+f1z(i,k,z)-f2z(i,k,z))*0.5/porosidade(i,k,z);
                    else
                        Gz(i,k,z) = vz(i,k,z)*phiz*(alpha*(Sw(i,k,z,j)-2*Sw(i,k,z,j)+Sw(i,k,z-1,j))-f1z(i,k,z)+f2z(i,k,z))*0.5/porosidade(i,k,z);
                    end


                else
                    %Gx
                    if Sw(i,k,z,j)<Sw(i-1,k,z,j)
                        Gx(i,k,z) = vx(i,k,z)*phix*(alpha*(Sw(i+1,k,z,j)-2*Sw(i,k,z,j)+Sw(i-1,k,z,j))-f1x(i,k,z)+f2x(i,k,z))*0.5/porosidade(i,k,z);
                    elseif Sw(i,k,z,j)<Sw(i+1,k,z,j)
                        Gx(i,k,z) = vx(i,k,z)*phix*(alpha*(Sw(i-1,k,z,j)-2*Sw(i,k,z,j)+Sw(i+1,k,z,j))+f1x(i,k,z)-f2x(i,k,z))*0.5/porosidade(i,k,z);
                    end
                    %Gy
                    if Sw(i,k,z,j)<Sw(i,k-1,z,j)
                        Gy(i,k,z) = vy(i,k,z)*phiy*(alpha*(Sw(i,k+1,z,j)-2*Sw(i,k,z,j)+Sw(i,k-1,z,j))-f1y(i,k,z)+f2y(i,k,z))*0.5/porosidade(i,k,z);  
                    elseif Sw(i,k,z,j)<Sw(i,k+1,z,j)
                        Gy(i,k,z) = vy(i,k,z)*phiy*(alpha*(Sw(i,k-1,z,j)-2*Sw(i,k,z,j)+Sw(i,k+1,z,j))+f1y(i,k,z)-f2y(i,k,z))*0.5/porosidade(i,k,z); 
                    end
                    %Gz
                    if Sw(i,k,z,j)<Sw(i,k,z-1,j)
                        Gz(i,k,z) = vz(i,k,z)*phiz*(alpha*(Sw(i,k,z+1,j)-2*Sw(i,k,z,j)+Sw(i,k,z-1,j))-f1z(i,k,z)+f2z(i,k,z))*0.5/porosidade(i,k,z);  
                    elseif Sw(i,k,z,j)<Sw(i,k,z+1,j)
                        Gz(i,k,z) = vz(i,k,z)*phiz*(alpha*(Sw(i,k,z-1,j)-2*Sw(i,k,z,j)+Sw(i,k,z+1,j))+f1z(i,k,z)-f2z(i,k,z))*0.5/porosidade(i,k,z); 
                    end
                end
            end
        end
     end
    
    for k=1:1:N1
        for i=1:1:N1
            for z=1:1:N1z
                Sw(i,k,z,j+1)= Sw(i,k,z,j)+Gx(i,k,z)+Gy(i,k,z)+Gz(i,k,z);            
                %if j==T1
                %    B(i,k)=Sw(i,k,20,T1);
                %end
            end
        end
    end
 
end
hold on
for i = 1:1:N1
    for k = 1:1:N1
        for z = 1:1:N1z
            if Sw(i,k,z,T1) > 0.5
                xaa = [i];
                yaa = [k];
                zaa = [z];
                figure(1)
                plot3(xaa,yaa,zaa,'*');
                xlabel('X')                                              %|
                ylabel('Y')                                              %|
                zlabel('Z')                                              %|
            end
        end
    end
end
hold off

yu = 1;
if yu == 2
%---------------------------------Animação---------------------------------
for j=1:1:T1                                                             %|
    hold on
    for k=1:1:N1                                                         %|
        for i=1:1:N1  
            for z=1:1:N1z
                if Sw(i,k,z,j) > 0.5
                    xaa = [i];
                    yaa = [k];
                    zaa = [z];
                    figure (3);
                    plot3(xaa,yaa,zaa,'.');
                    xlabel('X');                                              %|
                    ylabel('Y');                                              %|
                    zlabel('Z');                                              %|
                end                                      %|
            end                                                              %|
        end                                                                  %|
    end
    hold off
    anima(j) = getframe;
end
movie(anima,3,10)                                                        %|
%--------------------------------------------------------------------------
end

ka = 1;
if ka == 2
for z = [1, 5, 10, 15, 20]
    for k=1:1:N1
        for i=1:1:N1
            if j==T1
                    B(i,k)=Sw(i,k,z,T1);
            end
        end
    end
    %-------------------------------Gráfico Final--------------------------
    figure (z)                                                           %|
    R1=linspace(0,1,N1);                                                 %|
    %R2=linspace(0,1,N1);                                                %|
    surf(R1,R1,B(:,:))                                                   %|
    az = 0;                                                              %|
    el = 90;                                                             %|
    view(az, el);                                                        %|
    xlabel('x')                                                          %|
    ylabel('y')                                                          %|
    zlabel('saturation')                                                 %|
    colorbar                                                             %|
    %----------------------------------------------------------------------
end

ui = 1;
if ui == 2
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
end

ua = 2
if ua == 1
%---------------------------------Animação---------------------------------
for j=1:1:T1                                                             %|
    for k=1:1:N1                                                         %|
        for i=1:1:N1                                                     %|
            B(i,k) = Sw(i,k,20,j);                                       %|
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
end
end
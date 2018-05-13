%UNIVERSIDADE ESTADUAL DO NORTE FLUMINENSE
%LABORATÓRIO DE CIÊNCIAS MATEMÁTICAS
%PROF NELSON BARBOSA e Nicholas de A. Pinto
%1.2.1
clear all;
clc;

%Introduzir as variaveis - 22
%Introduzir as variaveis - 61
%Loading - 93
%Poço de injeção - 102 
%Valores para Limitador de Fluxo - 109
%Limitadores de Fluxo - 137
%Sm_ - 214
%Lamb_ - 233
%Fluxo - 247
%Conta final - 258
%Gráfico final - 275
%Animacao - 319

%-------------------------Definir os Parametros-----------------------------
disp('               Esquema TVD BIDIMENSIONAL')
disp('************************************************************')
N1 = 100;
deltx = 0.0005;
deltt = 0.0005;
mio = 2;
miw = 0.875;
mig = 0.03;
betag = 0.9550660;
limitador = 5;
ux = 1;
fprintf('*N1 = %f        mio = %f  \n', N1, mio)
fprintf('*miw = %f         mig = %f  \n', miw, mig)
fprintf('*betag = %f       deltt = %f\n', betag, deltt)
disp('*Minmod');
colocarvalores = input('"1" para mudar valores acima: ');
if colocarvalores == 1
    N1 = input('    Numero de células: ');
    mio = input('   Viscosidade óleo: ');
    miw = input('   Viscosidade agua: ');
    mig = input('   Viscosidade gás: ');
    betag = input('     betag: ');
    deltx=input('   deltx: ');
    deltt=input('   deltt: ');
    disp('  Limitadores de fluxo')
    disp('  1-Superbee    2-Koren*')
    disp('  3-Muscl*      4-Osher')
    disp('  5-Minmod      6-Van Leer*')
    disp('  7-Leonar*     8-Fromm*')
    disp('  9-Quick*')
    limitador=input('   Limitador: ');
end
T1 = input('Tempo: ');
grafico = input('Gráfico--> 1-separado, 2-junto: ');
escolhaporosidade = input('Porosidade (>1 rand): ');
if escolhaporosidade >1
    minp = 0.45;
    maxp = 1;
    fprintf('    min = %f | max = %f\n', minp, maxp);
    escolhamin = input('    Mudar valores (1): ');
    if escolhamin == 1
        minp = input('       Min: ');
        maxp = input('       Max: ');
    end
end
cw=miw/mio;
cg=mig/mio;
%**************************************************************************
 
%---------------------Introduzir as variaveis------------------------------
Sw(1:T1,1:N1+1)=0.05;
Sg(1:T1,1:N1+1)=0.4;
rmwe(1:N1)=0;
rmwa(1:N1)=0;
rmge(1:N1)=0;
rmga(1:N1)=0;
fimwa(1:N1)=0;
fimwe(1:N1)=0;
fimga(1:N1)=0;
fimge(1:N1)=0;
Smwe(1:N1)=0;
Smwa(1:N1)=0;
Smge(1:N1)=0;
Smga(1:N1)=0;
lambwa(1:N1)=0;
lambwe(1:N1)=0;
lambga(1:N1)=0;
lambge(1:N1)=0;
lamboa(1:N1)=0;
lamboe(1:N1)=0;
lambta(1:N1)=0;
lambte(1:N1)=0;
fmwa(1:N1)=0;
fmwe(1:N1)=0;
fmga(1:N1)=0;
fmge(1:N1)=0;
AwX(1:N1)=0;
AgX(1:N1)=0;
porosidade(1:N1) = 0;

%**************************************************************************
for i = 1:1:N1
    if escolhaporosidade >1
        porosidade(i) = rand(1);
        while porosidade(i)<minp || porosidade(i) > maxp
            porosidade(i) = rand(1);
        end
    else
        porosidade(i) = escolhaporosidade;
    end
end
%------------------------------Loading...----------------------------------
      disp('Loading...')
for j=1:1:T1
    if rem(j,50) == 0
        ja = 100*j/T1;
        fprintf('%f', ja); disp('%');
    end
%**************************************************************************

%---------------------------Poço de Injeção--------------------------------

        Sw(j,1)=0.85;
        Sg(j,1)=0.15;

%**************************************************************************

%-----------------Valores para Limitador de Fluxo--------------------------
    for i = 1:1:N1

        Sw(j,N1+1) = Sw(j,N1);

        rmwe(1) = 0;
        rmwe(2) = 0;
        
        rmge(1) = 0;
        rmge(2) = 0;
        if i == 1
        rmwa(1) = (Sw(j,1) - Sw(j,1))/(Sw(j,1+1)-Sw(j,1));
        
        rmga(1) = (Sw(j,1) - Sw(j,1))/(Sw(j,1+1)-Sw(j,1));

        elseif i>1
            rmwa(i) = (Sw(j,i) - Sw(j,i-1))/(Sw(j,i+1)-Sw(j,i));
            
            rmga(i) = (Sg(j,i) - Sg(j,i-1))/(Sg(j,i+1)-Sg(j,i));
        

        elseif i>2
            rmwe(i) = (Sw(j,i-1) - Sw(j,i-2))/(Sw(j,i)-Sw(j,i-1));

            rmge(i) = (Sg(j,i-1) - Sg(j,i-2))/(Sg(j,i)-Sg(j,i-1));
        end
%**************************************************************************

%-------------------------- Limitadores de Fluxo---------------------------

        %Limitador Superbee
        if limitador == 1
            fimwa(j,i)=max(0,max(min(1,2*rmwa(j,i)),min(rmwa(j,i),2)));
            fimwe(j,i)=max(0,max(min(1,2*rmwe(j,i)),min(rmwe(j,i),2)));

            fimga(j,i)=max(0,max(min(1,2*rmga(j,i)),min(rmga(j,i),2)));
            fimge(j,i)=max(0,max(min(1,2*rmge(j,i)),min(rmge(j,i),2)));
            
        %Limitador Koren
        elseif limitador == 2 
            fimwa(j,i)=max(max(0,min(2*rmwa(j,i),(2*rmwa(j,i)+1)/3)),max(0,min((2*rmwa(j,i)+1)/3,2)));
            fimwe(j,i)=max(max(0,min(2*rmwe(j,i),(2*rmwe(j,i)+1)/3)),max(0,min((2*rmwe(j,i)+1)/3,2)));

            fimga(j,i)=max(max(0,min(2*rmga(j,i),(2*rmga(j,i)+1)/3)),max(0,min((2*rmga(j,i)+1)/3,2)));
            fimge(j,i)=max(max(0,min(2*rmge(j,i),(2*rmge(j,i)+1)/3)),max(0,min((2*rmge(j,i)+1)/3,2)));
            
        %Limitador Muscl
        elseif limitador == 3 
            fimwa(j,i)=max(max(0,min(2*rmwa(j,i),(rmwa(j,i)+1)/2)),max(0,min((rmwa(j,i)+1)/2,2)));
            fimwe(j,i)=max(max(0,min(2*rmwe(j,i),(rmwe(j,i)+1)/2)),max(0,min((rmwe(j,i)+1)/2,2)));

            fimga(j,i)=max(max(0,min(2*rmga(j,i),(rmga(j,i)+1)/2)),max(0,min((rmga(j,i)+1)/2,2)));
            fimge(j,i)=max(max(0,min(2*rmge(j,i),(rmge(j,i)+1)/2)),max(0,min((rmge(j,i)+1)/2,2)));
            
        %Limitador Osher
        elseif limitador == 4 
            fimwa(j,i)=max(0,min(2,rmwa(j,i)));
            fimwe(j,i)=max(0,min(2,rmwe(j,i)));

            fimga(j,i)=max(0,min(2,rmga(j,i)));
            fimge(j,i)=max(0,min(2,rmge(j,i)));
            
        %Limitador Minmod
        elseif limitador == 5 
            fimwa(i)=max(0,min(1,rmwa(i)));
            fimwe(i)=max(0,min(1,rmwe(i)));

            fimga(i)=max(0,min(1,rmga(i)));
            fimge(i)=max(0,min(1,rmge(i)));
            
        %Limitador Van Leer
        elseif limitador == 6 
            fimwa(j,i)=max(0,(2*rmwa(j,i))/(1+rmwa(j,i)));
            fimwe(j,i)=max(0,(2*rmwe(j,i))/(1+rmwe(j,i)));

            fimga(j,i)=max(0,(2*rmga(j,i))/(1+rmga(j,i)));
            fimge(j,i)=max(0,(2*rmge(j,i))/(1+rmge(j,i)));
            
        %Limitador Leonar
        elseif limitador == 7 
            fimwa(j,i)=max(0,(2+rmwa(j,i))/3);
            fimwe(j,i)=max(0,(2+rmwe(j,i))/3);

            fimga(j,i)=max(0,(2+rmga(j,i))/3);
            fimge(j,i)=max(0,(2+rmge(j,i))/3);
            
        %Limitador Fromm
        elseif limitador == 8 
            fimwa(j,i)=max(0,(1+rmwa(j,i))/2);
            fimwe(j,i)=max(0,(1+rmwe(j,i))/2);

            fimga(j,i)=max(0,(1+rmga(j,i))/2);
            fimge(j,i)=max(0,(1+rmge(j,i))/2);
            
        %Limitador Quick
        elseif limitador == 9 
            fimwa(j,i)=max(0,(3+rmwa(j,i))/4);
            fimwe(j,i)=max(0,(3+rmwe(j,i))/4);
            
            fimga(j,i)=max(0,(3+rmga(j,i))/4);
            fimge(j,i)=max(0,(3+rmge(j,i))/4);
        end
    end
%**************************************************************************

%----------------------------Sm__------------------------------------------
    for i=1:1:N1      
        if i==1    
            Smwe(i)=Sw(j,1) + (0.5*fimwe(i)*(Sw(j,i)-Sw(j,1)));  
            Smge(i)=Sg(j,1) + (0.5*fimge(i)*(Sg(j,i)-Sg(j,1)));
        elseif i==N1
            Smwe(i)=Sw(j,i-1) + (0.5*fimwe(i)*(Sw(j,i)-Sw(j,i-1)));
            Smge(i)=Sg(j,i-1) + (0.5*fimge(i)*(Sg(j,i)-Sg(j,i-1)));
        else    
            Smwe(i)=Sw(j,i-1) + (0.5*fimwe(i)*(Sw(j,i)-Sw(j,i-1)));
            Smge(i)=Sg(j,i-1) + (0.5*fimge(i)*(Sg(j,i)-Sg(j,i-1)));
        end    

        Smwa(i)=Sw(j,i)+ (0.5*fimwa(i)*(Sw(j,i+1)-Sw(j,i)));
        Smga(i)=Sg(j,i)+ (0.5*fimga(i)*(Sg(j,i+1)-Sg(j,i)));

    end
%**************************************************************************

%-------------------------------Lamb__-------------------------------------
    for i=1:1:N1
        lambwa(i) = (Smwa(i)^2)/(miw);
        lambga(i) = (betag*Smga(i)+(1-betag)*(Smwa(i)^2))/mig;
        lamboa(i) = (1-Smwa(i)-Smga(i))*(1-Smwa(i))*(1-Smga(i))/mio; 
        lambta(i) = lambwa(i)+lambga(i)+lamboa(i);

        lambwe(i) = (Smwe(i)^2)/(miw);
        lambge(i) = (betag*Smge(i)+(1-betag)*(Smwe(i)^2))/mig;
        lamboe(i) = (1-Smwe(i)-Smge(i))*(1-Smwe(i))*(1-Smge(i))/mio;
        lambte(i) = lambwe(i)+lambge(i)+lamboe(i);
    end
%**************************************************************************

%------------------------------Fluxo---------------------------------------
    for i=1:1:N1
       fmwa(i) = lambwa(i)/lambta(i); 
       fmga(i) = lambga(i)/lambta(i);

       fmwe(i) = lambwe(i)/lambte(i);
       fmge(i) = lambge(i)/lambte(i);

    end
%**************************************************************************

%-------------------------------Conta Final--------------------------------
    for i= 1:1:N1

    AwX(i) = ((fmwa(i)*ux) - (fmwe(i)*ux))/deltx ;
    AgX(i) = ((fmga(i)*ux) - (fmge(i)*ux))/deltx ;

    end

    for i= 1:1:N1

        Sw(j+1,i) = Sw(j,i)-(0.5)*(deltt)*AwX(i)/porosidade(i); 
        Sg(j+1,i) = Sg(j,i)-(0.5)*(deltt)*AgX(i)/porosidade(i);

    end
end
%**************************************************************************

%-----------------------------Gráfico Final--------------------------------
for i = 1:1:N1                                                           %|
    Bw(i) = Sw(T1,i);                                                    %|
    Bg(i) = Sg(T1,i);                                                    %|
    So(i) = 1-Sw(T1,i)-Sg(T1,i);                                         %|
    So2(i) = Bw(i) + So(i);                                              %|
    Sg2(i) = So2(i) + Bg(i);                                             %|
end                                                                      %|
R1=linspace(0,1,N1);                                                     %|
if grafico == 1                                                          %|
                                                                         %|
    figure (1)                                                           %|
    plot(R1,Bw(:));                                                      %|
    title('Water')                                                       %|
    xlabel('X')                                                          %|
    ylabel('Saturation')                                                 %|
    %colorbar                                                            %|
                                                                         %|
    figure (2)                                                           %|
    plot(R1,Bg(:));                                                      %|
    title('Gas')                                                         %|
    xlabel('X')                                                          %|
    ylabel('Saturation')                                                 %|
    %colorbar                                                            %|
                                                                         %|
    figure (3)                                                           %|
    plot(R1,So(:));                                                      %|
    title('Oil')                                                         %|
    xlabel('X')                                                          %|
    ylabel('Saturation')                                                 %|
    %colorbar                                                            %|
                                                                         %|
elseif grafico == 2                                                      %|
    figure(4)                                                            %|
    hold on                                                              %|
    plot(R1,Bw(:), 'blue')                                               %|
    hold on                                                              %|
    plot(R1,So2(:), 'black')                                             %|
    hold on                                                              %|
    plot(R1,Sg2(:), 'red')                                               %|
    hold off                                                             %|
    xlabel('X')                                                          %|
    ylabel('Saturation')                                                 %|
end                                                                      %|
%**************************************************************************
asdfg = 2;
if asdfg == 1
figure (5)
plot(R1, porosidade(:), 'black');
xlabel('Position(x)')                                                    %|
ylabel('Porosity')
end%|
g = 2;
if g ==1
%-----------------------------Animacao-------------------------------------
for j = 1:1:T1                                                           %|
    for i=1:1:N1                                                         %|
        Bw(i) = Sw(j,i);                                                 %|
        Bg(i) = Sg(j,i);                                                 %|
        So(i) = 1-Sw(j,i)-Sg(j,i);                                       %|
        Bo(i) = Bw(i) + So(i);                                           %|
    end                                                                  %|
    figure(5)                                                            %|
    hold on                                                              %|
    plot(R1,Bw(:), 'blue')                                               %|
    hold on                                                              %|
    plot(R1,Bo(:), 'black')                                              %|
    hold off                                                             %|
    anima(j) = getframe;                                                 %|
end                                                                      %|
movie(anima,3,20);                                                       %|
%**************************************************************************
end
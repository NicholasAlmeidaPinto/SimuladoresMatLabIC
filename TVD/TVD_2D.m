%UNIVERSIDADE ESTADUAL DO NORTE FLUMINENSE
%LABORATÓRIO DE CIÊNCIAS MATEMÁTICAS
%PROF NELSON BARBOSA
%Aluno: Nicholas de Almeida Pinto
%1.9.3 
%-----------------------Definir os parâmtros-------------------------------
y = 0;
while y == 0
% clear all;
% close all;
clc;
disp('               Esquema TVD BIDIMENSIONAL')
disp('************************************************************')
N1 = 100;
deltx = 0.003;
delty = 0.003;
deltt = 0.0005;
miw = 1;
mio = 1;
T3 = 3;
escolha = 5;
volumecelula = 1;
disp('*N1 = 100                 deltx = 0.003                    *');
disp('*deltt = 0.0005           delty = 0.003                    *');
disp('*Viscosidade agua = 1     Viscosidade oleo = 1             *');
disp('*Animação                 Minmod                           *');
disp('*Volume de cada célula: 1                                  *');
disp('************************************************************');
mudarvalores = input('"1" para mudar algum valor acima: ');
if mudarvalores == 1
    N1 = input('Entre com a quantidade de células para o eixo x (N1): ');
    deltx = input('Entre com o valor de deltx: ');
    delty = input('Entre com o valor de delty: ');
    deltt = input('Entre com o valor de deltt: ');
    miw = input('Entre com a viscosidade da água: ');
    mio = input('Entre com a viscosidade do óleo: ');
    T3 = input('"1" para normal -- "3" para animação: ');
    disp('Limitadores de fluxo')
    disp('1-Superbee   2-Koren')
    disp('3-Muscl      4-Osher')
    disp('5-Minmod     6-Van Leer')
    disp('7-Leonar     8-Fromm')
    disp('9-Quick')
    escolha=input('limitador de fluxo: ');
    volumecelula = input('Volume de cada célula: ');
    
end
escolhaux = input('Entre com o valor de ux ("10" para aleatorio): ');
escolhauy = input('Entre com o valor de uy ("10" para aleatorio): ');
T1 = input('Entre com o valor para o tempo: ');
c=miw/mio;
escolhaporosidade = input('Porosidade - "2" figuras - ">2" aleatorio: ');
minimo = 0.4;
maximo = 1;
    if escolhaporosidade == 2
        escolhafigura = input(' "1" Circulos - "2" Labirinto - "3" Espiral - "4" Retangulos: ');
    elseif escolhaporosidade > 2
        disp('   Mín = 0.3          Máx = 1')
        esc = input('   1 para mudar min ou máx: ');
        if esc == 1
            minimo = input('    min: ');
            maximo = input('    max: ');
        end
    end
N2 = input('"1" Poço --  "2" Five Spot -- "3" Line: ');
if N2 == 3
                   disp('   "1" baixo    - "2" cima');
    escolhaline = input('   "3" esquerda - "4" direita: ');    
end
escolhadifusiva = input('"1" para simulação com parte difusiva: ');
    if escolhadifusiva==1
        K = 0.0001;
        Ko = 0.001;
        Pc = 0.1;
        difusivodecrescente = 2;
        disp('   K = 1     Ko = 1');
        disp('   Pc = 0.0001         Decrescente');
        colocarvaloresdifusivo = input('   "1" para mudar valores: ');
        if colocarvaloresdifusivo == 1
            K = input('      Permeabilidade total: ');
            Ko = input('      Permeabilidade do oleo: ');
            Pc = input('      Pressao capilar: ');
            difusivodecrescente = input('"1" para normal, "2" para decrescente: ');
        end
        Lao = Ko/mio;
    end
y = input('"0" para colocar novos valores: ');
end
disp('************************************************************')
%**************************************************************************

 %definir as variaveis para poupar tempo
porosidade(1:N1,1:N1) = 0;
uy(1:N1,1:N1) = 0;
ux(1:N1,1:N1) = 0;
Sw(1:T1+1,1:N1+1,1:N1+1) = 0;
rma(1:N1,1:N1) = 0;
rme(1:N1,1:N1) = 0;
rmi(1:N1,1:N1) = 0;
rmo(1:N1,1:N1) = 0;
rmay(1:N1,1:N1) = 0;
rmey(1:N1,1:N1) = 0;
rmiy(1:N1,1:N1) = 0;
rmoy(1:N1,1:N1) = 0;
fima(1:N1,1:N1) = 0;
fime(1:N1,1:N1) = 0;
fimi(1:N1,1:N1) = 0;
fimo(1:N1,1:N1) = 0;
fimay(1:N1,1:N1) = 0;
fimey(1:N1,1:N1) = 0;
fimiy(1:N1,1:N1) = 0;
fimoy(1:N1,1:N1) = 0;
fma(1:N1,1:N1) = 0;
fme(1:N1,1:N1) = 0;
fmi(1:N1,1:N1) = 0;
fmo(1:N1,1:N1) = 0;
fmay(1:N1,1:N1) = 0;
fmey(1:N1,1:N1) = 0;
fmiy(1:N1,1:N1) = 0;
fmoy(1:N1,1:N1) = 0;
Sma(1:N1,1:N1) = 0;
Sme(1:N1,1:N1) = 0;
Smi(1:N1,1:N1) = 0;
Smo(1:N1,1:N1) = 0;
Smay(1:N1,1:N1) = 0;
Smey(1:N1,1:N1) = 0;
Smiy(1:N1,1:N1) = 0;
Smoy(1:N1,1:N1) = 0;
Ax(1:N1,1:N1) = 0;
Ay(1:N1,1:N1) = 0;
B(1:N1,1:N1) = 0;
if escolhadifusiva == 1
    Dxs(1:N1+1,1:N1+1) = 0;
    Dys(1:N1+1,1:N1+1) = 0;
    Dxn(1:N1,1:N1) = 0;
    Dxp(1:N1,1:N1) = 0;
    Dyn(1:N1,1:N1) = 0;
    Dyp(1:N1,1:N1) = 0;
    difusivax(1:N1,1:N1) = 0;
    difusivay(1:N1,1:N1) = 0;
    difusivafinal(1:N1,1:N1) = 0;
end
%**************************************

uaws = 1;
if uaws == 2 %agua no reservatorio circulo
for i = 1:1:N1
    for k = 1:1:N1
        xa = -1+2*i/N1;
        ya = -1+2*k/N1;
        if xa^2+ya^2 < 0.49
            Sw(1,i,k) = 0.5;
        else
            Sw(1,i,k) = 0;
        end
    end
end
end


%**************************

%porosidade e uy aleatorio
for i = 1:1:N1
for k = 1:1:N1
if escolhaporosidade == 2 %figura
    if escolhafigura == 1
        xa = -1+2*i/N1;
        ya = -1+2*k/N1;
        if xa^2+ya^2 > 0.49 && xa^2+ya^2 < 0.64 || xa^2+ya^2 > 0.25 && xa^2+ya^2 < 0.36 || xa^2+ya^2 > 0.04 && xa^2+ya^2 < 0.09
            porosidade(i,k) = 0.6;
        else
            porosidade(i,k) = 0.3;
        end

    
    elseif escolhafigura == 2
        xa = -1+2*i/N1;
        ya = -1+2*k/N1;
        if xa^2+ya^2 > 0.49 && xa^2+ya^2 < 0.64
            if xa > (-0.05) && xa <(0.05)
                porosidade(i,k) = 0.3;
            else
                porosidade(i,k) = 0.99;
            end
        elseif  xa^2+ya^2 > 0.25 && xa^2+ya^2 < 0.36
            if ya > (-0.05) && ya <(0.05)
                porosidade(i,k) = 0.3;
            else
                porosidade(i,k) = 0.99;
            end
        elseif  xa^2+ya^2 > 0.04 && xa^2+ya^2 < 0.09
            if xa > (-0.05) && xa <(0.05)
                porosidade(i,k) = 0.3;
            else
                porosidade(i,k) = 0.99;
            end
        else
            porosidade(i,k) = 0.3;
        end

    
    elseif escolhafigura == 3
        porosidade(1:N1,1:N1) = 0.3;
        za = 1;
        ra = 1;
        ia = N1/2;
        ka = N1/2;
        for r = 1:2:N1/2
            if za == 1
                for p = 1:1:r
                    ia = ia+1;
                    porosidade(ia,ka) = 0.99;
                end
                za = za + 1;
            elseif za == 2
                for p = 1:1:r
                    ka = ka+1;
                    porosidade(ia,ka) = 0.99;
                end
                za = za + 1;
            elseif za == 3
                for p = 1:1:r
                    ia = ia-1;
                    porosidade(ia,ka) = 0.99;
                end
                za = za + 1;
            elseif za == 4
                for p = 1:1:r
                    ka = ka-1;
                    porosidade(ia,ka) = 0.99;
                end
                za = za-3;
            end
        end
    elseif escolhafigura == 4 %retangulos


        if ((k > 15 && k < 35) || (k > 65 && k < 85)) && (i > 20 && i < 40)
            porosidade(i,k) = 0.99;
        elseif (k > 20 && k < 80) && (i > 65 && i < 80)
            porosidade(i,k) = 0.99;
        elseif (k > 47 && k < 53) && (i > 5 && i < 55)
            porosidade(i,k) = 0.99;
        else
            porosidade(i,k) = 0.3;
        end

        
        
        
        
        
        
        
    end
elseif escolhaporosidade > 2 %aleatorio
        porosidade(i,k) = rand(1);%(i,k) e nao (j,i,k) para a porosidade nao variar com o tempo
    while porosidade(i,k) < minimo || porosidade(i,k) > maximo
        porosidade(i,k) = rand(1);
    end

else % constante
        porosidade(i,k) = escolhaporosidade;
end

  if escolhauy == 10
    uy(i,k) = 1-porosidade(i,k);
    %while uy(i,k) < minimo || uy(i,k) > maximo
    %    uy(i,k) = rand(1);
    %end
  else 
    uy(i,k) = escolhauy;
  end
  
  if escolhaux == 10
    ux(i,k) = 1-porosidade(i,k);
    %while ux(i,k) < minimo || ux(i,k) > maximo
    %    ux(i,k) = rand(1);
    %end
  else 
    ux(i,k) = escolhaux;
  end
end
end
%**************************


%--------Injeção-------------|
if N2 == 1 %Poço            %|
    Sw(1:T1,N1/2,N1/2) = 1; %|
elseif N2 == 2 %Five Spot   %|
    Sw(1:T1,1,1) = 1;       %|
    Sw(1:T1,N1,1) = 1;      %|
    Sw(1:T1,1,N1) = 1;      %|
    Sw(1:T1,N1,N1) = 1;     %|
else %Line                  %|
    if escolhaline == 1
        Sw(1:T1,1,1:N1) = 1;
    elseif escolhaline == 2
        Sw(1:T1,N1,N1/2) = 1;
    elseif escolhaline == 3
        Sw(1:T1,1:N1,1) = 1;
    elseif escolhaline == 4
        Sw(1:T1,1:N1,N1) = 1;
    end
end                         %| 
%****************************|
   
  disp('Loading...')
for j=1:1:T1
    if rem(j,10) == 0
        ja = 100*j/T1;
        fprintf('%f', ja); disp('%');
    end
    
%----------Dados e primeiros valores para limitador de fluxo---------------
for i = 1:1:N1
for k = 1:1:N1

rme(1,k) = 0;% cond ini i = 1
rme(2,k) = 0;%cond ini i = 2
rmi(N1,N1+1-k) = 0;%cond inicial decrescen i = 1
rmi(N1-1,N1+1-k) = 0;%cond ini dec i = 2

rmey(i,1)=0;%
rmey(i,2)=0;%
rmiy(N1+1-i,N1) = 0;%
rmiy(N1+1-i,N1-1) = 0;%
%**************************************************************************

 
%****************************    rm__    **********************************
if i == 1
    rma(1,k) = (Sw(j,1,k) - Sw(j,1,k))/(Sw(j,1+1,k)-Sw(j,1,k));% cond ini i = 1 ja tinha nas contas anteriores
    rmo(N1,N1+1-k) = (Sw(j,N1,N1+1-k) - Sw(j,N1,N1+1-k))/(Sw(j,N1-1,N1+1-k)-Sw(j,N1,N1+1-k));
elseif i == N1
    rma(N1,k) = (Sw(j,N1,k) - Sw(j,N1-1,k))/(Sw(j,N1,k)-Sw(j,N1,k));% cond ini i = 1 ja tinha nas contas anteriores
    rmo(1,N1+1-k) = (Sw(j,1,N1+1-k) - Sw(j,2,N1+1-k))/(Sw(j,1,N1+1-k)-Sw(j,1,N1+1-k));    
elseif i>1
    rma(i,k) = (Sw(j,i,k) - Sw(j,i-1,k))/(Sw(j,i+1,k)-Sw(j,i,k));
    rmo(N1+1-i,N1+1-k) = (Sw(j,N1+1-i,N1+1-k) - Sw(j,N1+1-i+1,N1+1-k))/(Sw(j,N1+1-i-1,N1+1-k)-Sw(j,N1+1-i,N1+1-k));
end

if k == 1
    rmay(i,k) = (Sw(j,i,k) - Sw(j,i,1))/(Sw(j,i,k+1)-Sw(j,i,k));
    rmoy(N1+1-i,N1+1-k) = (Sw(j,N1+1-i,N1) - Sw(j,N1+1-i,N1))/(Sw(j,N1+1-i,N1-1)-Sw(j,N1+1-i,N1));
elseif k == N1
    rmay(i,k) = (Sw(j,i,k) - Sw(j,i,k-1))/(Sw(j,i,k)-Sw(j,i,k));
    rmoy(N1+1-i,1) = (Sw(j,N1+1-i,1) - Sw(j,N1+1-i,2))/(Sw(j,N1+1-i,1)-Sw(j,N1+1-i,1));
elseif k>1
    rmay(i,k) = (Sw(j,i,k) - Sw(j,i,k-1))/(Sw(j,i,k+1)-Sw(j,i,k));
    rmoy(N1+1-i,N1+1-k) = (Sw(j,N1+1-i,N1+1-k) - Sw(j,N1+1-i,N1+1-k+1))/(Sw(j,N1+1-i,N1+1-k-1)-Sw(j,N1+1-i,N1+1-k));
end

 

if i>2
    rme(i,k) = (Sw(j,i-1,k) - Sw(j,i-2,k))/(Sw(j,i,k)-Sw(j,i-1,k));
end

if i>2   
    rmi(N1+1-i,N1+1-k) = (Sw(j,N1+1-i+1,N1+1-k) - Sw(j,N1+1-i+2,N1+1-k))/(Sw(j,N1+1-i,N1+1-k)-Sw(j,N1+1-i+1,N1+1-k));
end
 

if k>2  
    rmey(i,k)= (Sw(j,i,k-1) - Sw(j,i,k-2))/(Sw(j,i,k)-Sw(j,i,k-1));
end
if k>2 
    rmiy(N1+1-i,N1+1-k)= (Sw(j,N1+1-i,N1+1-k+1) - Sw(j,N1+1-i,N1+1-k+2))/(Sw(j,N1+1-i,N1+1-k)-Sw(j,N1+1-i,N1+1-k+1));    
end
%************************    Fim dos rm__    ******************************

%******    Fim dos Primeiros valores para limitador de fluxo    ***********
    
    
    
%------------------- Alguns Limitadores de Fluxo---------------------------
 
%Limitador Superbee
if escolha==1 
    fima(i,k)=max(0,max(min(1,2*rma(i,k)),min(rma(i,k),2)));
    fime(i,k)=max(0,max(min(1,2*rme(i,k)),min(rme(i,k),2)));
    fimiy(N1+1-i,N1+1-k)=max(0,max(min(1,2*rmi(N1+1-i,N1+1-k)),min(rmi(N1+1-i,N1+1-k),2)));
    fimoy(N1+1-i,N1+1-k)=max(0,max(min(1,2*rmo(N1+1-i,N1+1-k)),min(rmo(N1+1-i,N1+1-k),2)));
    
    fimay(i,k)=max(0,max(min(1,2*rmay(i,k)),min(rmay(i,k),2)));
    fimey(i,k)=max(0,max(min(1,2*rmey(i,k)),min(rmey(i,k),2)));
    fimiy(N1+1-i,N1+1-k)=max(0,max(min(1,2*rmiy(N1+1-i,N1+1-k)),min(rmiy(N1+1-i,N1+1-k),2)));
    fimoy(N1+1-i,N1+1-k)=max(0,max(min(1,2*rmoy(N1+1-i,N1+1-k)),min(rmoy(N1+1-i,N1+1-k),2)));   

%Limitador Koren
elseif escolha==2
    fima(i,k)=max(max(0,min(2*rma(i,k),(2*rma(i,k)+1)/3)),max(0,min((2*rma(i,k)+1)/3,2)));
    fime(i,k)=max(max(0,min(2*rme(i,k),(2*rme(i,k)+1)/3)),max(0,min((2*rme(i,k)+1)/3,2)));
    fimi(N1+1-i,N1+1-k)=max(max(0,min(2*rmi(N1+1-i,N1+1-k),(2*rmi(N1+1-i,N1+1-k)+1)/3)),max(0,min((2*rmi(N1+1-i,N1+1-k)+1)/3,2)));
    fimo(N1+1-i,N1+1-k)=max(max(0,min(2*rmo(N1+1-i,N1+1-k),(2*rmo(N1+1-i,N1+1-k)+1)/3)),max(0,min((2*rmo(N1+1-i,N1+1-k)+1)/3,2)));

    fimay(i,k)=max(max(0,min(2*rmay(i,k),(2*rmay(i,k)+1)/3)),max(0,min((2*rmay(i,k)+1)/3,2)));
    fimey(i,k)=max(max(0,min(2*rmey(i,k),(2*rmey(i,k)+1)/3)),max(0,min((2*rmey(i,k)+1)/3,2)));
    fimiy(N1+1-i,N1+1-k)=max(max(0,min(2*rmiy(N1+1-i,N1+1-k),(2*rmiy(N1+1-i,N1+1-k)+1)/3)),max(0,min((2*rmiy(N1+1-i,N1+1-k)+1)/3,2)));
    fimoy(N1+1-i,N1+1-k)=max(max(0,min(2*rmoy(N1+1-i,N1+1-k),(2*rmoy(N1+1-i,N1+1-k)+1)/3)),max(0,min((2*rmoy(N1+1-i,N1+1-k)+1)/3,2)));

%Limitador Muscl
elseif escolha==3
    fima(i,k)=max(max(0,min(2*rma(i,k),(rma(i,k)+1)/2)),max(0,min((rma(i,k)+1)/2,2)));
    fime(i,k)=max(max(0,min(2*rme(i,k),(rme(i,k)+1)/2)),max(0,min((rme(i,k)+1)/2,2)));
    fimi(N1+1-i,N1+1-k)=max(max(0,min(2*rmi(N1+1-i,N1+1-k),(rmi(N1+1-i,N1+1-k)+1)/2)),max(0,min((rmi(N1+1-i,N1+1-k)+1)/2,2)));
    fimo(N1+1-i,N1+1-k)=max(max(0,min(2*rmo(N1+1-i,N1+1-k),(rmo(N1+1-i,N1+1-k)+1)/2)),max(0,min((rmo(N1+1-i,N1+1-k)+1)/2,2)));

    fimay(i,k)=max(max(0,min(2*rmay(i,k),(rmay(i,k)+1)/2)),max(0,min((rmay(i,k)+1)/2,2)));
    fimey(i,k)=max(max(0,min(2*rmey(i,k),(rmey(i,k)+1)/2)),max(0,min((rmey(i,k)+1)/2,2)));
    fimiy(N1+1-i,N1+1-k)=max(max(0,min(2*rmiy(N1+1-i,N1+1-k),(rmiy(N1+1-i,N1+1-k)+1)/2)),max(0,min((rmiy(N1+1-i,N1+1-k)+1)/2,2)));
    fimoy(N1+1-i,N1+1-k)=max(max(0,min(2*rmoy(N1+1-i,N1+1-k),(rmoy(N1+1-i,N1+1-k)+1)/2)),max(0,min((rmoy(N1+1-i,N1+1-k)+1)/2,2)));
    
%Limitador Osher
elseif escolha==4
    fima(i,k)=max(0,min(2,rma(i,k)));
    fime(i,k)=max(0,min(2,rme(i,k)));
    fimi(N1+1-i,N1+1-k)=max(0,min(2,rmi(N1+1-i,N1+1-k)));
    fimo(N1+1-i,N1+1-k)=max(0,min(2,rmo(N1+1-i,N1+1-k)));
    
    fimay(i,k)=max(0,min(2,rmay(i,k)));
    fimey(i,k)=max(0,min(2,rmey(i,k)));
    fimiy(N1+1-i,N1+1-k)=max(0,min(2,rmiy(N1+1-i,N1+1-k)));
    fimoy(N1+1-i,N1+1-k)=max(0,min(2,rmoy(N1+1-i,N1+1-k)));
 
%Limitador Minmod
elseif escolha==5
    fima(i,k)=max(0,min(1,rma(i,k)));
    fime(i,k)=max(0,min(1,rme(i,k)));
    fimi(N1+1-i,N1+1-k)=max(0,min(1,rmi(N1+1-i,N1+1-k)));
    fimo(N1+1-i,N1+1-k)=max(0,min(1,rmo(N1+1-i,N1+1-k)));
    
    fimay(i,k)=max(0,min(1,rmay(i,k)));
    fimey(i,k)=max(0,min(1,rmey(i,k)));
    fimiy(N1+1-i,N1+1-k)=max(0,min(1,rmiy(N1+1-i,N1+1-k)));
    fimoy(N1+1-i,N1+1-k)=max(0,min(1,rmoy(N1+1-i,N1+1-k)));
 
 
%Limitador Van Leer
elseif escolha==6
    fima(i,k)=max(0,(2*rma(i,k))/(1+rma(i,k)));
    fime(i,k)=max(0,(2*rme(i,k))/(1+rme(i,k)));
    fimi(N1+1-i,N1+1-k)=max(0,(2*rmi(N1+1-i,N1+1-k))/(1+rmi(N1+1-i,N1+1-k)));
    fimo(N1+1-i,N1+1-k)=max(0,(2*rmo(N1+1-i,N1+1-k))/(1+rmo(N1+1-i,N1+1-k)));
    
    fimay(i,k)=max(0,(2*rmay(i,k))/(1+rmay(i,k)));
    fimey(i,k)=max(0,(2*rmey(i,k))/(1+rmey(i,k)));
    fimiy(N1+1-i,N1+1-k)=max(0,(2*rmiy(N1+1-i,N1+1-k))/(1+rmiy(N1+1-i,N1+1-k)));
    fimoy(N1+1-i,N1+1-k)=max(0,(2*rmoy(N1+1-i,N1+1-k))/(1+rmoy(N1+1-i,N1+1-k)));
 
%Limitador Leonar
elseif escolha==7
    fima(i,k)=max(0,(2+rma(i,k))/3);
    fime(i,k)=max(0,(2+rme(i,k))/3);
    fimi(N1+1-i,N1+1-k)=max(0,(2+rmi(N1+1-i,N1+1-k))/3);
    fimo(N1+1-i,N1+1-k)=max(0,(2+rmo(N1+1-i,N1+1-k))/3);

    fimay(i,k)=max(0,(2+rmay(i,k))/3);
    fimey(i,k)=max(0,(2+rmey(i,k))/3);
    fimiy(N1+1-i,N1+1-k)=max(0,(2+rmiy(N1+1-i,N1+1-k))/3);
    fimoy(N1+1-i,N1+1-k)=max(0,(2+rmoy(N1+1-i,N1+1-k))/3);
 
 
%Limitador Fromm
elseif escolha==8
    fima(i,k)=max(0,(1+rma(i,k))/2);
    fime(i,k)=max(0,(1+rme(i,k))/2);
    fimi(N1+1-i,N1+1-k)=max(0,(1+rmi(N1+1-i,N1+1-k))/2);
    fimo(N1+1-i,N1+1-k)=max(0,(1+rmo(N1+1-i,N1+1-k))/2);

    fimay(i,k)=max(0,(1+rmay(i,k))/2);
    fimey(i,k)=max(0,(1+rmey(i,k))/2);
    fimiy(N1+1-i,N1+1-k)=max(0,(1+rmiy(N1+1-i,N1+1-k))/2);
    fimoy(N1+1-i,N1+1-k)=max(0,(1+rmoy(N1+1-i,N1+1-k))/2);
 
%Limitador Quick
elseif escolha==9
    fima(i,k)=max(0,(3+rma(i,k))/4);
    fime(i,k)=max(0,(3+rme(i,k))/4);
    fimi(N1+1-i,N1+1-k)=max(0,(3+rmi(N1+1-i,N1+1-k))/4);
    fimo(N1+1-i,N1+1-k)=max(0,(3+rmo(N1+1-i,N1+1-k))/4);

    fimay(i,k)=max(0,(3+rmay(i,k))/4);
    fimey(i,k)=max(0,(3+rmey(i,k))/4);
    fimiy(N1+1-i,N1+1-k)=max(0,(3+rmiy(N1+1-i,N1+1-k))/4);
    fimoy(N1+1-i,N1+1-k)=max(0,(3+rmoy(N1+1-i,N1+1-k))/4);
end
end
end
%****************    Fim do Limitador de fluxo     ************************



%****************************    Sm    ************************************
for i = 1:1:N1
for k = 1:1:N1    
    
if i==1
    
    Sme(i,k)=Sw(j,1,k) + (0.5*fime(i,k)*(Sw(j,i,k)-Sw(j,1,k)));    
else
    
    Sme(i,k)=Sw(j,i-1,k) + (0.5*fime(i,k)*(Sw(j,i,k)-Sw(j,i-1,k)));
end

if i==N1
    Smi(i,k)=Sw(j,N1,k) + (0.5*fimi(i,k)*(Sw(j,i,k)-Sw(j,N1,k))); 
else    
    Smi(i,k)=Sw(j,i+1,k) + (0.5*fimi(i,k)*(Sw(j,i,k)-Sw(j,i+1,k)));
end


 
if k==1 
    Smey(i,k)=Sw(j,i,1) + (0.5*fimey(i,k)*(Sw(j,i,k)-Sw(j,i,1)));
else
    Smey(i,k)=Sw(j,i,k-1) + (0.5*fimey(i,k)*(Sw(j,i,k)-Sw(j,i,k-1)));
end


if k==N1
    Smiy(i,k)=Sw(j,i,N1) + (0.5*fimiy(i,k)*(Sw(j,i,k)-Sw(j,i,N1)));
else
    Smiy(i,k)=Sw(j,i,k+1) + (0.5*fimiy(i,k)*(Sw(j,i,k)-Sw(j,i,k+1)));
end

    
if i == N1
    Sma(i,k) = Sw(j,i,k);
else
    Sma(i,k)=Sw(j,i,k)+ (0.5*fima(i,k)*(Sw(j,i+1,k)-Sw(j,i,k)));
end
 
 
if k == N1
    Smay(i,k) = Sw(j,i,k);
else
    Smay(i,k)=Sw(j,i,k)+(0.5*fimay(i,k)*(Sw(j,i,k+1)-Sw(j,i,k)));
end

 
if i == 1
    Smo(i,k)=Sw(j,i,k);
else
    Smo(i,k)=Sw(j,i,k)+ (0.5*fimo(i,k)*(Sw(j,i-1,k)-Sw(j,i,k)));
end


if k==1
    Smoy(i,k)=Sw(j,i,k);
else
    Smoy(i,k)=Sw(j,i,k)+(0.5*fimoy(i,k)*(Sw(j,i,k-1)-Sw(j,i,k)));
end

%*****************************fm***********************


if i == 1
    fma(i,k)= Sma(i,k)*Sma(i,k)/((Sma(i,k)*Sma(i,k))+(c*(1-Sma(i,k))^2));
elseif Sw(j,i,k)<Sw(j,i-1,k)
    fma(i,k)= Sma(i,k)*Sma(i,k)/((Sma(i,k)*Sma(i,k))+(c*(1-Sma(i,k))^2));
else
    fma(i,k)= 0;
end


if k == 1
    fmay(i,k)= Smay(i,k)*Smay(i,k)/((Smay(i,k)*Smay(i,k))+(c*(1-Smay(i,k))^2));
elseif Sw(j,i,k)<Sw(j,i,k-1)
    fmay(i,k)= Smay(i,k)*Smay(i,k)/((Smay(i,k)*Smay(i,k))+(c*(1-Smay(i,k))^2));
else
    fmay(i,k)= 0;
end
 
%***************

if i == N1
    fmo(i,k)= Smo(i,k)*Smo(i,k)/((Smo(i,k)*Smo(i,k))+(c*(1-Smo(i,k))^2));
elseif Sw(j,i,k)<Sw(j,i+1,k)
    fmo(i,k)= Smo(i,k)*Smo(i,k)/((Smo(i,k)*Smo(i,k))+(c*(1-Smo(i,k))^2));
else
    fmo(i,k)= 0;
end
 
if k==N1
    fmoy(i,k)= Smoy(i,k)*Smoy(i,k)/((Smoy(i,k)*Smoy(i,k))+(c*(1-Smoy(i,k))^2));
elseif Sw(j,i,k)<Sw(j,i,k+1)
    fmoy(i,k)= Smoy(i,k)*Smoy(i,k)/((Smoy(i,k)*Smoy(i,k))+(c*(1-Smoy(i,k))^2));
else
    fmoy(i,k)= 0;
end
 
%***************

if i == 1
    fme(i,k)= Sme(i,k)*Sme(i,k)/((Sme(i,k)*Sme(i,k))+(c*(1-Sme(i,k))^2));
elseif Sw(j,i,k)<Sw(j,i-1,k)
    fme(i,k)= Sme(i,k)*Sme(i,k)/((Sme(i,k)*Sme(i,k))+(c*(1-Sme(i,k))^2));
else
    fme(i,k) = 0;
end

if k == 1
    fmey(i,k)= Smey(i,k)*Smey(i,k)/((Smey(i,k)*Smey(i,k))+(c*(1-Smey(i,k))^2));
elseif Sw(j,i,k)<Sw(j,i,k-1)
    fmey(i,k)= Smey(i,k)*Smey(i,k)/((Smey(i,k)*Smey(i,k))+(c*(1-Smey(i,k))^2));
else
    fmey(i,k) = 0;
end

%***************

if i == N1
    fmi(i,k)= Smi(i,k)*Smi(i,k)/((Smi(i,k)*Smi(i,k))+(c*(1-Smi(i,k))^2));
elseif Sw(j,i,k)<Sw(j,i+1,k)
    fmi(i,k)= Smi(i,k)*Smi(i,k)/((Smi(i,k)*Smi(i,k))+(c*(1-Smi(i,k))^2));
else
    fmi(i,k) = 0;
end

if k == N1
    fmiy(i,k)= Smiy(i,k)*Smiy(i,k)/((Smiy(i,k)*Smiy(i,k))+(c*(1-Smiy(i,k))^2));
elseif Sw(j,i,k)<Sw(j,i,k+1)
    fmiy(i,k)= Smiy(i,k)*Smiy(i,k)/((Smiy(i,k)*Smiy(i,k))+(c*(1-Smiy(i,k))^2));
else
    fmiy(i,k) = 0;
end

%**************************************************************************


end
end
 
for i = 1:1:N1
for k = 1:1:N1
 
Ax(i,k) = ((fma(i,k)*ux(i,k)+fmo(i,k)*ux(i,k)) - (fme(i,k)*ux(i,k)+fmi(i,k)*ux(i,k)))/deltx ;
Ay(i,k) = ((fmay(i,k)*uy(i,k)+fmoy(i,k)*uy(i,k)) - (fmey(i,k)*uy(i,k)+fmiy(i,k)*uy(i,k)))/delty;

end
end
 
%---------------------------Parte difusiva---------------------------------
    %parte 1/3-----
if escolhadifusiva == 1
    for i = 1:1:N1
        for k = 1:1:N1
            if i == N1
                Dxs(i,k) = K*fma(i,k)*Lao*Pc;
                Dxs(i+1,k) = Dxs(i,k);
            elseif k == N1
                Dys(i,k) = K*fmay(i,k)*Lao*Pc;
                Dys(i,k+1) = Dys(i,k);
            else
                Dxs(i,k) = K*fma(i,k)*Lao*Pc;
                Dys(i,k) = K*fmay(i,k)*Lao*Pc;
            end
        end
    end
    %fim parte 1/3*****

    %parte 2/3-----
    for i = 1:1:N1
    for k = 1:1:N1
        Dxp(i,k) = ((Dxs(i+1,k))+(Dxs(i,k)))/2;%Ds(i+1/2) 
        Dxn(i,k) = ((Dxs(i+1,k))-(Dxs(i,k)))/2;%Ds(i-1/2)
        Dyp(i,k) = ((Dys(i,k+1))+(Dys(i,k)))/2;%Ds(k+1/2)
        Dyn(i,k) = ((Dys(i,k+1))-(Dys(i,k)))/2;%Ds(k-1/2)
    end
    end
    %fim parte 2/3*****

    %parte 3/3-----
    if difusivodecrescente == 1
        for i = 1:1:N1
            for k = 1:1:N1
                if i == 1
                    difusivax(i,k) = (Dxp(i,k)*(((Sw(j,i+1,k))-(Sw(j,i,k)))/deltx))/deltx;
                elseif i == N1
                    difusivax(i,k) = -Dxn(i,k)*(((Sw(j,i,k))-(Sw(j,i-1,k)))/deltx)/deltx;
                elseif k == 1
                    difusivay(i,k) = (Dyp(i,k)*(((Sw(j,i,k+1))-(Sw(j,i,k)))/delty))/delty;
                elseif k == N1
                    difusivay(i,k) = -Dyn(i,k)*(((Sw(j,i,k))-(Sw(j,i,k-1)))/delty)/delty;
                else
                    difusivax(i,k) = (Dxp(i,k)*(((Sw(j,i+1,k))-(Sw(j,i,k)))/deltx)- Dxn(i,k)*(((Sw(j,i,k))-(Sw(j,i-1,k)))/deltx))/deltx;
                    difusivay(i,k) = (Dyp(i,k)*(((Sw(j,i,k+1))-(Sw(j,i,k)))/delty)- Dyn(i,k)*(((Sw(j,i,k))-(Sw(j,i,k-1)))/delty))/delty;
                end
                difusivafinal(i,k) = difusivax(i,k)+difusivay(i,k);
            end
        end
        
        
    elseif difusivodecrescente == 2
        for i = 1:1:N1
            for k = 1:1:N1
                if i == 1
                    if Sw(j,i+1,k) > Sw(j,i,k)
                        difusivax(i,k) = (Dxn(i,k)*(((-Sw(j,i+1,k))+(Sw(j,i,k)))/deltx));
                    else
                        difusivax(i,k) = (Dxp(i,k)*(((Sw(j,i+1,k))-(Sw(j,i,k)))/deltx));
                    end
                elseif k == 1
                    if Sw(j,i,k+1) > Sw(j,i,k)
                        difusivay(i,k) = (Dyn(i,k)*(((-Sw(j,i,k+1))+(Sw(j,i,k)))/delty));
                    else
                        difusivay(i,k) = (Dyp(i,k)*(((Sw(j,i,k+1))-(Sw(j,i,k)))/delty));
                    end
                else
                    if Sw(j,i+1,k) > Sw(j,i,k)
                        difusivax(i,k) = (-Dxp(i,k)*(((-Sw(j,i+1,k))+(Sw(j,i,k)))/deltx)+ Dxn(i,k)*(((-Sw(j,i,k))+(Sw(j,i-1,k)))/deltx))/deltx;
                    else
                        difusivax(i,k) = (Dxp(i,k)*(((Sw(j,i+1,k))-(Sw(j,i,k)))/deltx)- Dxn(i,k)*(((Sw(j,i,k))-(Sw(j,i-1,k)))/deltx))/deltx;
                    end
                    
                    if Sw(j,i,k+1) > Sw(j,i,k)
                        difusivay(i,k) = (-Dyp(i,k)*(((-Sw(j,i,k+1))+(Sw(j,i,k)))/delty)+ Dyn(i,k)*(((-Sw(j,i,k))+(Sw(j,i,k-1)))/delty))/delty;
                    else
                        difusivay(i,k) = (Dyp(i,k)*(((Sw(j,i,k+1))-(Sw(j,i,k)))/delty)- Dyn(i,k)*(((Sw(j,i,k))-(Sw(j,i,k-1)))/delty))/delty;
                    end
                    
                    difusivafinal(i,k) = difusivax(i,k)+difusivay(i,k);
                end
            end
        end
    end
    %fim parte 3/3*****

end
%************************Fim da Parte Difusiva*****************************
 
for i = 1:1:N1
for k = 1:1:N1
    if escolhadifusiva == 1 %difusivo
            if escolhaporosidade > 1    %porosidade randomica
        
                Sw(j+1,i,k) = Sw(j,i,k)-0.5*(deltt)*Ax(i,k)/porosidade(i,k) - 0.5*(deltt)*Ay(i,k)/porosidade(i,k)-difusivafinal(i,k)*deltt/porosidade(i,k);
            else %porosidade constante
                Sw(j+1,i,k) = Sw(j,i,k)-0.5*(deltt)*Ax(i,k)/(escolhaporosidade) - 0.5*(deltt)*Ay(i,k)/(escolhaporosidade)-difusivafinal(i,k)*deltt/escolhaporosidade;
            end
    else %não difusivo
            if escolhaporosidade > 1    %porosidade randomica        
                Sw(j+1,i,k) = Sw(j,i,k)-0.5*(deltt)*Ax(i,k)/porosidade(i,k) - 0.5*(deltt)*Ay(i,k)/porosidade(i,k);
            else %porosidade constante
                Sw(j+1,i,k) = Sw(j,i,k)-0.5*(deltt)*Ax(i,k)/(escolhaporosidade) - 0.5*(deltt)*Ay(i,k)/(escolhaporosidade);
            end
    end
    
    %Mudança para plotar grafico
         if j==T1
             B(i,k)=Sw(T1,i,k);
         end
    %**************
end
end

end
%--------------------------Volume de óleo retirado-------------------------
volumefinal = 0;
for i = 1:1:N1
    for k = 1:1:N1
        volumefinal = volumefinal + volumecelula*(1-Sw(T1,i,k));
    end
end
volumetotal = N1*N1*volumecelula;
volumeainda = volumetotal-volumefinal;
fprintf('Volume de óleo obtido: %f\n', volumefinal);
fprintf('Volume de óleo no reservatorio: %f', volumeainda);
%--------------------------------------------------------------------------

    %grafico da saturação e normal
    figure (1)
    R1=linspace(0,1,N1);
    R2=linspace(0,1,N1);
    surf(R1,R2,B(:,:))
    colorbar
    xlabel('x')
    ylabel('y')
    zlabel('saturation')
    %********************
    

    %grafico porosidade
if escolhaporosidade > 1
    figure (3)
    surf(R1,R2,porosidade(:,:))
    az = 0;
    el = 90;
    view(az, el);
    xlabel('x')
    ylabel('y')
    zlabel('porosity')
    colorbar
    colormap(gray)
end
    %*******************

    %animação
 if T3 == 3
    for j = 1:1:T1
        for i = 1:1:N1
            for k = 1:1:100
                B(i,k) = Sw(j,i,k);
            end
        end
        figure (2)
        R1=linspace(0,1,N1);
        R2=linspace(0,1,N1);
        surf(R1,R2,B(:,:));
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
end
    %**************
clear;

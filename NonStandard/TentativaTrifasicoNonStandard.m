%NonStandard Trifasico
%UENF
%Nicholas e Nelson
clear all;
%close all;
clc;
%------------------------Inserir os parametros-----------------------------
N1 = 100;
mio = 2;
miw = 0.875;
mig = 0.03;
betag = 0.91;
deltt = 1;
deltx = 1;
disp('----------NonStandard Trifasico----------')
fprintf('*N1 = %f        mio = %f  *\n', N1, mio)
fprintf('*miw = %f         mig = %f  *\n', miw, mig)
fprintf('*betag = %f       deltt = %f*\n', betag, deltt)
disp('*****************************************')
colocarvalores = input('"1" para mudar valores acima: ');
if colocarvalores == 1
    N1 = input('Numero de celulas: ');
    mio = input('Viscosidade oleo: ');
    miw = input('Viscosidade agua: ');
    mig = input('Viscosidade gas: ');
    betag = input('betag: ');
    deltt = input('deltt: ');
    escolhaanimacao = input('"1" para animação, outro para normal: ');
end
cw=miw/mio;
cg=mig/mio;
tempo = input('Tempo: ');
escolhaux = input('Entre com o valor de ux ("10" para aleatorio): ');
escolhaporosidade = input('Porosidade (Maior que 1 -> aleatorio): ');
if escolhaporosidade >1
    min = 0.2;
    max = 1;
    disp('   Min = 0.2          Max = 1')
    esc = input('   1 para mudar min ou max: ');
    if esc == 1
        min = input('      min: ');
        max = input('      max: ');
    end
end
%--------------------------------------------------------------------------



    
%---------------------------Definir variaveis------------------------------
Sw(1:tempo, 1:N1+1) = 0.05;
Sg(1:tempo, 1:N1+1) = 0.40;
Sw(1:tempo,1) = 0.85;
Sg(1:tempo,1) = 0.15;
%difffluxow(1:tempo,1:N1) = 0;
%difffluxog(1:tempo,1:N1) = 0;
f1w(1:tempo,1:N1) = 0;
f1g(1:tempo,1:N1) = 0;
f2w(1:tempo,1:N1) = 0;
f2g(1:tempo,1:N1) = 0;
alfaw(1:tempo,1:N1) = 0;
alfag(1:tempo,1:N1) = 0;
lambo(1:tempo,1:N1) = 0;
lambw(1:tempo,1:N1) = 0;
lambg(1:tempo,1:N1) = 0;
Bw(1:N1) = 0;
Bg(1:N1) = 0;
So(1:N1) = 0;
porosidade(1:N1) = 0;
vx(1:N1) = 0;
%--------------------------------------------------------------------------



%-----------------------------Porosidade-----------------------------------
for i = 1:1:N1

    if escolhaporosidade > 1

        porosidade(i) = rand(1);

        while porosidade(i) < min || porosidade(i) > max
            porosidade(i) = rand(1);
        end

    else

        porosidade(i) = escolhaporosidade;

    end

    if escolhaux == 10
        vx(i) = 1-porosidade(i);
    else
        vx(i) = escolhaux;
    end

end
%--------------------------------------------------------------------------

disp('Loading...')
for j=1:1:tempo
    if rem(j,50) == 0
        ja = 100*j/tempo;
        fprintf('%f', ja); disp('%');
    end
%---------------------------Achar o alfaw e alfag--------------------------
    %t = j;
    %for i = 1:1:1
    %    difffluxow(t,i) = (2*Sw(t,i))/(miw*((Sg(t,i)*betag - Sw(t,i)^2*(betag - 1))/mig + Sw(t,i)^2/miw - ((Sg(t,i) - 1)*(Sw(t,i) - 1)*(Sg(t,i) + Sw(t,i) - 1))/mio)) + (Sw(t,i)^2*((2*Sw(t,i)*(betag - 1))/mig - (2*Sw(t,i))/miw + ((Sg(t,i) - 1)*(Sw(t,i) - 1))/mio + ((Sg(t,i) - 1)*(Sg(t,i) + Sw(t,i) - 1))/mio))/(miw*((Sg(t,i)*betag - Sw(t,i)^2*(betag - 1))/mig + Sw(t,i)^2/miw - ((Sg(t,i) - 1)*(Sw(t,i) - 1)*(Sg(t,i) + Sw(t,i) - 1))/mio)^2);
    %    difffluxog(t,i) = betag/(mig*((Sg(t,i)*betag - Sw(t,i)^2*(betag - 1))/mig + Sw(t,i)^2/miw - ((Sg(t,i) - 1)*(Sw(t,i) - 1)*(Sg(t,i) + Sw(t,i) - 1))/mio)) + ((Sg(t,i)*betag - Sw(t,i)^2*(betag - 1))*(((Sg(t,i) - 1)*(Sw(t,i) - 1))/mio - betag/mig + ((Sw(t,i) - 1)*(Sg(t,i) + Sw(t,i) - 1))/mio))/(mig*((Sg(t,i)*betag - Sw(t,i)^2*(betag - 1))/mig + Sw(t,i)^2/miw - ((Sg(t,i) - 1)*(Sw(t,i) - 1)*(Sg(t,i) + Sw(t,i) - 1))/mio)^2);
    %end
    for i = 1:1:1 
        alfaw = 0.1;%rand(1)*100;%0.92;%max(difffluxow(t,i));
        alfag = 0.7;%rand(1)*100;%max(difffluxog(t,i));
    end
    
    psig=(1/(2*alfag))*((1-exp(-alfag*deltt/deltx)));
    psiw=(1/(2*alfaw))*((1-exp(-alfaw*deltt/deltx)));
%--------------------------------------------------------------------------
    
    for i=1:1:N1+1
       lambw(j,i) = (Sw(j,i)^2)/(miw);
       lambg(j,i) = (betag*Sg(j,i) + (1-betag)*(Sw(j,i)^2))/mig;
       lambo(j,i) = (1-Sw(j,i)-Sg(j,i))*(1-Sw(j,i))*(1-Sg(j,i))/mio; 
    end

%---------------------------Contas de fluxo--------------------------------
    for i=1:1:N1
        if i == 1
            f2w(j,i) = lambw(j,i)/(lambw(j,i)+lambg(j,i)+lambo(j,i));       
            f2g(j,i) = lambg(j,i)/(lambw(j,i)+lambg(j,i)+lambo(j,i)); 
        else
            f2w(j,i) = lambw(j,i-1)/(lambw(j,i-1)+lambg(j,i-1)+lambo(j,i-1));       
            f2g(j,i) = lambg(j,i-1)/(lambw(j,i-1)+lambg(j,i-1)+lambo(j,i-1));
        end
    end
    for i=N1:-1:1
        if 1 == N1
            f1w(j,i) = lambw(j,i)/(lambw(j,i)+lambg(j,i)+lambo(j,i));       
            f1g(j,i) = lambg(j,i)/(lambw(j,i)+lambg(j,i)+lambo(j,i)); 
        else 
            f1w(j,i) = lambw(j,i+1)/(lambw(j,i+1)+lambg(j,i+1)+lambo(j,i+1));       
            f1g(j,i) = lambg(j,i+1)/(lambw(j,i+1)+lambg(j,i+1)+lambo(j,i+1)); 
        end
    end
%--------------------------------------------------------------------------

%-----------------------------Equacao Principal----------------------------
    for i = 1:1:N1
        if i<=1
            Sg(j+1,i)= 0.15;%Sg(j,i)+(psig)*(alfag*(Sg(j,i+1)-2*Sg(j,i)+Sg(j,i))-f1g(j,i)+f2g(j,i));
            Sw(j+1,i)= 0.85;%Sw(j,i)+(psiw)*(alfaw*(Sw(j,i+1)-2*Sw(j,i)+Sw(j,i))-f1w(j,i)+f2w(j,i));
        else
            Sg(j+1,i)= Sg(j,i)+vx(i)*(psig)*(alfag*(Sg(j,i+1)-2*Sg(j,i)+Sg(j,i-1))-f1g(j,i)+f2g(j,i))/porosidade(i);
            Sw(j+1,i)= Sw(j,i)+vx(i)*(psiw)*(alfaw*(Sw(j,i+1)-2*Sw(j,i)+Sw(j,i-1))-f1w(j,i)+f2w(j,i))/porosidade(i);
        end
    end
end
%--------------------------------------------------------------------------



%-----------------------------Grafico Final--------------------------------
for i = 1:1:N1                                                           %|
    Bw(i) = Sw(tempo,i);                                                 %|
    Bg(i) = Sg(tempo,i);                                                 %|
    So(i) = 1-Sw(tempo,i)-Sg(tempo,i);                                   %|
    So2(i) = Bw(i)+So(i);
end
ga = 2;
if ga == 1%|
figure (1+10*palfa)                                                               %|
R1=linspace(0,1,N1);                                                     %|
plot(R1,Bw(:));                                                          %|
title('Water')                                                           %|
xlabel('X')                                                              %|
ylabel('Saturation')                                                     %|
%colorbar                                                                %|
                                                                         %|
figure (2+10*palfa)                                                               %|
R1=linspace(0,1,N1);                                                     %|
plot(R1,Bg(:));                                                          %|
title('Gas')                                                             %|
xlabel('X')                                                              %|
ylabel('Saturation')                                                     %|
%colorbar                                                                %|
                                                                         %|
figure (3)                                                               %|
R1=linspace(0,1,N1);                                                     %|
plot(R1,So(:));                                                          %|
title('Oil')                                                             %|
xlabel('X')                                                              %|
ylabel('Saturation')                                                     %|
%colorbar                                                                %|
end

R1=linspace(0,1,N1);                                                     %|
figure(4+10)%*palfa)
hold on
plot(R1,Bw(:), 'blue')
hold on
plot(R1,So2(:), 'green')
hold off
xlabel('X')                                                              %|
ylabel('Saturation')

za = 21;
if za == 2%|
figure (4+10*palfa)                                                               %|
R1=linspace(0,1,N1);                                                     %|
plot(R1,porosidade(:));                                                  %|
title('Porosity')                                                        %|
xlabel('X')                                                              %|
ylabel('Porosity')                                                       %|
%colorbar                                                                %|
%--------------------------------------------------------------------------
end


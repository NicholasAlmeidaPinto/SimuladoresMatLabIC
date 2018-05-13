clear;
close;
clc;
%Nicholas de Almeida Pinto
%Simulador com nova tecnica para simular o avanço bilateral
disp('Simulador TVD 2D com nova tecnica')
%------------------------VALORES INICIAIS----------------------------------
N = 100;
delty = 0.003;
deltx = 0.003;
deltt = 0.0005;
mio = 1;
miw = 1;
porosidade = 1;
tempo = 100;
Sw(1:N,1:N,1:tempo) = 0;
%--------------------------------------------------------------------------

%--------------------------------INJECAO-----------------------------------
Sw(46:55,46:55,1) = 1;
%--------------------------------------------------------------------------

%-------------------------------CONTA--------------------------------------
for t = 1:1:tempo-1
    for x = 1:1:N
        for y = 1:1:N
%             Sw(1:N,1,t) = 1;
            Fax = 0;
            Fbx = 0;
            Faxn = 0;
            Fbxn = 0;
            Fay = 0;
            Fby = 0;
            Fayn = 0;
            Fbyn = 0;
            
            if x == 1
                if Sw(x,y,t)>Sw(x+1,y,t)
                    Fbx=Sw(x,y,t);
                elseif Sw(x,y,t)<Sw(x+1,y,t)
                    Fax=Sw(x+1,y,t)+.5*(Sw(x,y,t)-Sw(x+1,y,t))*max(0,min(1,(Sw(x+1,y,t)-Sw(x+2,y,t))/(Sw(x,y,t)-Sw(x+1,y,t))));
                end
            elseif x == 2
                if Sw(x,y,t)>Sw(x+1,y,t)
                    Fbx=Sw(x,y,t)+.5*(Sw(x+1,y,t)-Sw(x,y,t))*max(0,min(1,(Sw(x,y,t)-Sw(x-1,y,t))/(Sw(x+1,y,t)-Sw(x,y,t))));   
                elseif Sw(x,y,t)<Sw(x+1,y,t)
                    Fax=Sw(x+1,y,t)+.5*(Sw(x,y,t)-Sw(x+1,y,t))*max(0,min(1,(Sw(x+1,y,t)-Sw(x+2,y,t))/(Sw(x,y,t)-Sw(x+1,y,t))));
                end
                if Sw(x-1,y,t)>Sw(x,y,t)
                    Faxn=Sw(x-1,y,t);
                elseif Sw(x-1,y,t)<Sw(x,y,t)
                    Fbxn=Sw(x,y,t)+.5*(Sw(x-1,y,t)-Sw(x,y,t))*max(0,min(1,(Sw(x,y,t)-Sw(x+1,y,t))/(Sw(x-1,y,t)-Sw(x,y,t))));
                end
            elseif x == N
                if Sw(x-1,y,t)>Sw(x,y,t)
                    Faxn=Sw(x-1,y,t)+.5*(Sw(x,y,t)-Sw(x-1,y,t))*max(0,min(1,(Sw(x-1,y,t)-Sw(x-2,y,t))/(Sw(x,y,t)-Sw(x-1,y,t)))); 
                elseif Sw(x-1,y,t)<Sw(x,y,t)
                    Fbxn=Sw(x,y,t);
                end
            elseif x == N-1
                if Sw(x,y,t)>Sw(x+1,y,t)
                    Fbx=Sw(x,y,t)+.5*(Sw(x+1,y,t)-Sw(x,y,t))*max(0,min(1,(Sw(x,y,t)-Sw(x-1,y,t))/(Sw(x+1,y,t)-Sw(x,y,t))));   
                elseif Sw(x,y,t)<Sw(x+1,y,t)
                    Fax=Sw(x+1,y,t);
                end
                if Sw(x-1,y,t)>Sw(x,y,t)
                    Faxn=Sw(x-1,y,t)+.5*(Sw(x,y,t)-Sw(x-1,y,t))*max(0,min(1,(Sw(x-1,y,t)-Sw(x-2,y,t))/(Sw(x,y,t)-Sw(x-1,y,t)))); 
                elseif Sw(x-1,y,t)<Sw(x,y,t)
                    Fbxn=Sw(x,y,t)+.5*(Sw(x-1,y,t)-Sw(x,y,t))*max(0,min(1,(Sw(x,y,t)-Sw(x+1,y,t))/(Sw(x-1,y,t)-Sw(x,y,t))));
                end
            else
                if Sw(x,y,t)>Sw(x+1,y,t)
                    Fbx=Sw(x,y,t)+.5*(Sw(x+1,y,t)-Sw(x,y,t))*max(0,min(1,(Sw(x,y,t)-Sw(x-1,y,t))/(Sw(x+1,y,t)-Sw(x,y,t))));   
                elseif Sw(x,y,t)<Sw(x+1,y,t)
                    Fax=Sw(x+1,y,t)+.5*(Sw(x,y,t)-Sw(x+1,y,t))*max(0,min(1,(Sw(x+1,y,t)-Sw(x+2,y,t))/(Sw(x,y,t)-Sw(x+1,y,t))));
                end
                if Sw(x-1,y,t)>Sw(x,y,t)
                    Faxn=Sw(x-1,y,t)+.5*(Sw(x,y,t)-Sw(x-1,y,t))*max(0,min(1,(Sw(x-1,y,t)-Sw(x-2,y,t))/(Sw(x,y,t)-Sw(x-1,y,t)))); 
                elseif Sw(x-1,y,t)<Sw(x,y,t)
                    Fbxn=Sw(x,y,t)+.5*(Sw(x-1,y,t)-Sw(x,y,t))*max(0,min(1,(Sw(x,y,t)-Sw(x+1,y,t))/(Sw(x-1,y,t)-Sw(x,y,t))));
                end
            end
            if y == 1
                if Sw(x,y,t)>Sw(x,y+1,t)
                    Fby=Sw(x,y,t); 
                elseif Sw(x,y,t)<Sw(x,y+1,t)
                    Fay=Sw(x,y+1,t)+.5*(Sw(x,y,t)-Sw(x,y+1,t))*max(0,min(1,(Sw(x,y+1,t)-Sw(x,y+2,t))/(Sw(x,y,t)-Sw(x,y+1,t))));
                end
            elseif y == 2
                if Sw(x,y,t)>Sw(x,y+1,t)
                    Fby=Sw(x,y,t)+.5*(Sw(x,y+1,t)-Sw(x,y,t))*max(0,min(1,(Sw(x,y,t)-Sw(x,y-1,t))/(Sw(x,y+1,t)-Sw(x,y,t))));   
                elseif Sw(x,y,t)<Sw(x,y+1,t)
                    Fay=Sw(x,y+1,t)+.5*(Sw(x,y,t)-Sw(x,y+1,t))*max(0,min(1,(Sw(x,y+1,t)-Sw(x,y+2,t))/(Sw(x,y,t)-Sw(x,y+1,t))));
                end
                if Sw(x,y-1,t)>Sw(x,y,t)
                    Fayn=Sw(x,y-1,t);
                elseif Sw(x,y-1,t)<Sw(x,y,t)
                    Fbyn=Sw(x,y,t)+.5*(Sw(x,y-1,t)-Sw(x,y,t))*max(0,min(1,(Sw(x,y,t)-Sw(x,y+1,t))/(Sw(x,y-1,t)-Sw(x,y,t))));
                end
            elseif y == N
                if Sw(x,y-1,t)>Sw(x,y,t)
                    Fayn=Sw(x,y-1,t)+.5*(Sw(x,y,t)-Sw(x,y-1,t))*max(0,min(1,(Sw(x,y-1,t)-Sw(x,y-2,t))/(Sw(x,y,t)-Sw(x,y-1,t))));
                elseif Sw(x,y-1,t)<Sw(x,y,t)
                    Fbyn=Sw(x,y,t);
                end
            elseif y == N-1
                if Sw(x,y,t)>Sw(x,y+1,t)
                    Fby=Sw(x,y,t)+.5*(Sw(x,y+1,t)-Sw(x,y,t))*max(0,min(1,(Sw(x,y,t)-Sw(x,y-1,t))/(Sw(x,y+1,t)-Sw(x,y,t))));  
                elseif Sw(x,y,t)<Sw(x,y+1,t)
                    Fay=Sw(x,y+1,t);
                end
                if Sw(x,y-1,t)>Sw(x,y,t)
                    Fayn=Sw(x,y-1,t)+.5*(Sw(x,y,t)-Sw(x,y-1,t))*max(0,min(1,(Sw(x,y-1,t)-Sw(x,y-2,t))/(Sw(x,y,t)-Sw(x,y-1,t))));
                elseif Sw(x,y-1,t)<Sw(x,y,t)
                    Fbyn=Sw(x,y,t)+.5*(Sw(x,y-1,t)-Sw(x,y,t))*max(0,min(1,(Sw(x,y,t)-Sw(x,y+1,t))/(Sw(x,y-1,t)-Sw(x,y,t))));
                end
            else
                if Sw(x,y,t)>Sw(x,y+1,t)
                    Fby=Sw(x,y,t)+.5*(Sw(x,y+1,t)-Sw(x,y,t))*max(0,min(1,(Sw(x,y,t)-Sw(x,y-1,t))/(Sw(x,y+1,t)-Sw(x,y,t))));  
                elseif Sw(x,y,t)<Sw(x,y+1,t)
                    Fay=Sw(x,y+1,t)+.5*(Sw(x,y,t)-Sw(x,y+1,t))*max(0,min(1,(Sw(x,y+1,t)-Sw(x,y+2,t))/(Sw(x,y,t)-Sw(x,y+1,t))));
                end
                if Sw(x,y-1,t)>Sw(x,y,t)
                    Fayn=Sw(x,y-1,t)+.5*(Sw(x,y,t)-Sw(x,y-1,t))*max(0,min(1,(Sw(x,y-1,t)-Sw(x,y-2,t))/(Sw(x,y,t)-Sw(x,y-1,t))));
                elseif Sw(x,y-1,t)<Sw(x,y,t)
                    Fbyn=Sw(x,y,t)+.5*(Sw(x,y-1,t)-Sw(x,y,t))*max(0,min(1,(Sw(x,y,t)-Sw(x,y+1,t))/(Sw(x,y-1,t)-Sw(x,y,t))));
                end
            end
            
            Fx = (Fax^2)/(Fax^2 + (miw/mio)*((1-Fax)^2)) - (Fbx^2)/(Fbx^2 + (miw/mio)*((1-Fbx)^2)) + (Faxn^2)/(Faxn^2 + (miw/mio)*((1-Faxn)^2)) - (Fbxn^2)/(Fbxn^2 + (miw/mio)*((1-Fbxn)^2));
            Fy = (Fay^2)/(Fay^2 + (miw/mio)*((1-Fay)^2)) - (Fby^2)/(Fby^2 + (miw/mio)*((1-Fby)^2)) + (Fayn^2)/(Fayn^2 + (miw/mio)*((1-Fayn)^2)) - (Fbyn^2)/(Fbyn^2 + (miw/mio)*((1-Fbyn)^2));

            Sw(x,y,t+1) =  Sw(x,y,t) + ((Fx/deltx) + (Fy/delty))*deltt/porosidade;
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
disp(volume);
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

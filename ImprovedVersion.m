function [Apogee,TSep,TSepA,TA,Al,Ll] = ImprovedVersion(T,A,vY,vX,Mr,sTr)

% Apogee=num2str(aA);       apogee
% TSep=num2str(T);          Seconds to separate
% TSepA=num2str(aT-T);      seconds after seperation to apogee
% TA=num2str(aT);           seconds after launch to apogee b 
% Al=num2str(i*n-aT);       seconds after apogee to land
% Ll=num2str(i*n+T);        seconds after launch to land

%TO DO
%
%VARIABLES
%   n = step time (s)
%   i = counter
%   g = acceleration due to gravity (ms^-2)
%   rdV = reference drag table - velocity (m/s) // rdF = reference drag table - force (N)
%   rmT = reference mass table - time (s) // rmM = reference mass table - mass(kg)
%   T =  time (s) // sT = time after seperation for smoke start (s) 
%   A = altitude (m) // M = mass (kg)
%   vY = vertical velocity // vX = lateral velocity
%   fd = drag // fdY = vertical drag // fdX = horizontal drag force
%   fY = total vertical force // fX = total lateral force


%initialize simulation parameters
n =         .01; %step size
i =         0;   %iteration
g =         9.80665;%gravity

%copy reference tables
%stage 2
rdV =       xlsread('Ref.xlsx','Drag','A3:A503'); %Velocity
rdF =       xlsread('Ref.xlsx','Drag','B3:B503'); %Drag
rmT =       xlsread('Ref.xlsx','Mass','A3:A33'); %Time for smoke system
rmM =       xlsread('Ref.xlsx','Mass','B3:B33'); %Mass of smoke + rocket

%initialize variables
%T time at separation
%A Altitude at separation
%vY Initial Vertical Velocity
%vX Initial Lateral velocity

M =         Mr;       %Initial mass of smoke
sT =        sTr;       %Time for smoke to start
fY =        0;          %Total vertical force
fX =        0;           %Total horizontal force
ap =        0;


kT =        zeros(2000,1); %Time
kA =        zeros(2000,1); %Altitude
kvY =       zeros(2000,1); %Vertical velocity
kvX =       zeros(2000,1); %Lateral velocty
kv =        zeros(2000,1); %Total velocity
kfd =       zeros(2000,1); %Drag Force
Mrt=zeros(2000,1);
%calculations
while A >= 0
    
    %smoke mass burnoff
    if i*n >= sT
        M =        interp1(rmT,rmM,i*n - sT,'linear',12.203);
    end
    
    %drag force and drag force components
    fd =        interp1(rdV,rdF,sqrt(vY^2+vX^2),'linear','extrap'); %Velocity,Drag
                                                                    %Total Initial
                                                                    %Velocity
    fdY =       fd*sin(atan(vY/vX)); %Vertical drag force
    fdX =       fd*cos(atan(vY/vX)); %Horizontal drag force
    
    %force totals
    fY =        -fdY - M*g; %Vertical Drag and gravity
    fX =        -fdX;       %Horizontal Drag and gravity
    
    %acceleration
    aY =        fY/M;
    aX =        fX/M;
    
    %velocity
    vY =        vY + aY*n;
    vX =        vX + aX*n;
    
    %altitude
    A =         A + vY*n;
    
    %save data
    kT (i+1,1) =    i*n + T;
    kA (i+1,1) =    A;
    kvY (i+1,1) =   vY;
    kvX (i+1,1) =   vX;
    kv (i+1,1) =    sqrt(vY^2 + vX^2);
    kfd (i+1,1) =   fd;
    Mrt(i+1,1)=M;
    if vY > 0
        aA =        A;
        aT =        i*n + T;
    end
     
    %incremate simulation
    i =         i + 1;
end

Apogee=aA; %apogee
TSep=T;     %Seconds to separate
TSepA=aT-T;  %seconds after seperation to apogee
TA=aT; %seconds after launch to apogee
Al=i*n-aT; %seconds after apogee to land
Ll=i*n+T;   %seconds after launch to land
Mrt;
end



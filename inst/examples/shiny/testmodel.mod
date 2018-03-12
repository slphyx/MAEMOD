!MAEMOD_Begin
STARTTIME <- 0
STOPTIME <- 5
DT <- 1/12

!Parameters
mui=0,
muo=0,
R0= 0,
ps = 0.9,
pr = 0.1,
wait_treat = 5,
omega=1/2,
nuC=365/10,
nuA=365/60,
nuU=365/120,
t_treat = 2,
c1max=0.99,
c2max=0.99,
c3max=0.99,
cpmax=0.99,
rho = 365/20,
nu1 = 365/1,
nu2 = 365/1,
nu3 = 365/1,
prec = 0.05,
thetamax = 0.9,
nuDmin=365/27,
q=1,
amp=1,
phi=0,
sensC=0.95,
sensA=0.50,
sensU=0.00,
f=1

!Inits
S = 0.9*1000, T1 = 0, T2 = 0, T3 = 0, Tp = 0, Tr = 0,
IC1 = 0, IA1 = 0.05*1000, IU1 = 0, P = 0, R = 1000-0.9*1000-0.05*1000

!Equations
# define variables
N <- (S+T1+T2+T3+Tp+Tr+IC1+IA1+IU1+P+R)
seas<-1+amp*cos(2*pi*(t-phi))
nu <- 1/((1/nuC)+(1/nuA)+(1/nuU))
I <- T1+T2+T3+Tp+Tr+IC1+IA1+IU1
beta<-R0*(muo+nu)*seas
lam <- beta*seas*I/N

nuD <- nuDmin/(q+(0.001/365))

c1 <- q*c1max
c2 <- q*c2max
c3 <- q*c3max
cp <- q*cpmax

theta <- thetamax*(1-q)


treat <- (t>=t_treat)*365/(wait_treat)


tf<-7/365 # 7 days after treatment
rf <- 52 # weekly follow up
fw <- ((t>tf)*rf)*f

# rate of change
dS <- mui*N-muo*S+omega*R -lam*S

# dIC0 <- -muo*IC0 +lam*ps*S+lam*pr*R -nuC*IC0-treat*IC0
# dIA0 <- -muo*IA0 +lam*(1-ps)*S+lam*(1-pr)*R+nuC*IC0 -nuA*IA0
# dIU0 <- -muo*IU0 +nuA*IA0 -nuU*IU0

dT1 <- -muo*T1+treat*IC1-nu1*T1
dT2 <- -muo*T2+(1-c1)*nu1*T1-nu2*T2
dT3 <- -muo*T3+(1-c2)*nu2*T2-nu3*T3
dTp <- -muo*Tp+(1-c3)*nu3*T3-nuD*Tp-fw*Tp

dTr <- -muo*Tr+prec*c1*nu1*T1+prec*c1*nu2*T2+prec*c3*nu3*T3+prec*cp*nuD*Tp-rho*Tr

dIC1 <- -muo*IC1 +lam*ps*S+lam*pr*R   +nuD*theta*(1-cp)*Tp -treat*IC1-nuC*IC1 -sensC*fw*IC1 +rho*Tr
dIA1 <- -muo*IA1 +lam*(1-ps)*S+lam*(1-pr)*R   +nuD*(1-theta)*(1-cp)*Tp+nuC*IC1 -nuA*IA1-sensA*fw*IA1
dIU1 <- -muo*IU1 +nuA*IA1 -nuU*IU1 -sensU*fw*IU1

dP <- -muo*P -nuD*P +(1-prec)*c1*nu1*T1+(1-prec)*c2*nu2*T2+(1-prec)*c3*nu3*T3+(1-prec)*cp*nuD*Tp
dR <- -muo*R +nuU*IU1+nuD*P -omega*R-lam*R

INC <- treat*IC1
Fail <- fw*Tp+sensC*fw*IC1+sensA*fw*IA1+sensU*fw*IU1


!Outputs
INC=INC, Fail=Fail

!Plots

!MAEMOD_End

myeq2 <-"
!Inits
X=120, Y=0, S=0

!Outputs
c(dX,dY,dS),U=U,L=L

!Parameters
bonemarrow = 1,
deathuninfected = 0.00833,
infectionrate = 0.1,
deathinfected = 0.2,
nmerozoites = 16,
deathmerozoite = 72

!ExtraFunctions


!Equations
dX <- bonemarrow - deathuninfected*X - infectionrate*X*S
dY <- infectionrate*X*S - deathinfected*Y
dS <- deathinfected*Y*nmerozoites - deathmerozoite*S - infectionrate*X*S
U <- X+Y
L <- sin(t)*U

!Plots
c('X','L','U')
!MAEMOD_End
"

out2<-maemod.ode(input.text = myeq2,timegrid = seq(0,400,0.1))


"
METHOD RK4

STARTTIME = 0
STOPTIME = 20
DT = 0.02

d/dt (A[1]) = -k[1]*A[1]
d/dt (A[2..n-1]) = k[i-1]*A[i-1]-k[i]*A[i]
d/dt (A[n]) = k[n-1]*A[n-1]

init A[1] = 100
init A[2..n]=0

k[1..n] =1
n = 14

"

arrayEx <-'
!Equations
dA[1] <- -k[1]*A[1]
"dA[i.indx] <- k[i.indx-1] * A[i.indx-1]-k[i.indx]*A[i.indx]"%@@%list("i.indx"%=>%2:(n-1))
dA[n] <- k[n-1]*A[n-1]


!Parameters
"k[i]<-1"%@%("i"%=>%1:n)

!Inits
A[1]<-100,
A[2]<-0,
A[3]<-0,
A[4]<-0,
A[5]<-0,
A[6]<-0,
A[7]<-0,
A[8]<-0,
A[9]<-0,
A[10]<-0,
A[11]<-0,
A[12]<-0,
A[13]<-0,
A[14]<-0

!ExtraFunctions
k<-c()
dA<-c()
A<-c()
n<-14
k[1:n]<-1

!Outputs
c(dA[1:n])

!Plots

!MAEMOD_End
'
out<-maemod.ode(input.text = arrayEx ,timegrid = seq(0,20,0.02))


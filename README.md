#maemod
A user friendly compartmental modelling environment in R

###Install maemod
```{r install_devtools, eval=FALSE}
library("devtools")
install_github("slphyx/maemod")
```

###Using maemod

####Ex1
```{r example}
#define the system
mysystem <- "
!MAEMOD_Begin
STARTTIME <- 0
STOPTIME <- 600
DT <- 0.1

!Equations
dX <- bonemarrow - deathuninfected*X - infectionrate*X*S
dY <- infectionrate*X*S - deathinfected*Y
dS <- deathinfected*Y*nmerozoites - deathmerozoite*S - infectionrate*X*S
U <- X+Y

!Parameters   
bonemarrow = 1,
deathuninfected = 0.00833,
infectionrate = 0.1,
deathinfected = 0.2,
nmerozoites = 16,
deathmerozoite = 72

!Inits      #initial value of each compartment
X=120, Y=0, S=0

!Outputs    #additional outputs
U=U


!Plots

!MAEMOD_End
"
```
```{r solving the system numerically}
#use maemod.ode to solve the system
out <- maemod.ode(input.text = mysystem)

head(out)
     time        X Y S        U
[1,]  0.0 120.0000 0 0 120.0000
[2,]  0.1 120.0000 0 0 120.0000
[3,]  0.2 120.0001 0 0 120.0001
[4,]  0.3 120.0001 0 0 120.0001
[5,]  0.4 120.0002 0 0 120.0002
[6,]  0.5 120.0002 0 0 120.0002
```

####Ex2

```{r example}
#define the system in a text file (test.txt)
#
##### test.txt
!MAEMOD_Begin
STARTTIME <- 0
STOPTIME <- 20*pi
DT <- 0.1
!Equations
 dY1<-Y2
 dY2<-a*sin(Y1)+sin(t)
 
!Parameters
 a= -1.0
 
!Inits
 Y1=0,Y2=0
 
!Outputs
 
!Plots

!MAEMOD_End

###
```

```{r solve the system and plot the results}
out<-maemod.ode(input.filename = "test.txt")
plot(out[,c(2,3)],col="red")
```
![](http://www.sakngoi.com/wp-content/uploads/2016/10/heart.png)


###Ex3
```{r example }

lorenz<-"
 ! MAEMOD_Begin
 STARTTIME <- 0
 STOPTIME <- 30
 DT <- 0.01
 
 !Equations
 dx<-sigma*(y-x)
 dy<-x*(rho-z)-y
 dz<-x*y-beta*z
 
 !Parameters
 sigma=10, beta=2.66666, rho=28
 
 !Inits
 x=-10, y=-12, z=30.05
 
 !Outputs
 
 !Plots
 
 !MAEMOD_End
 "

lorenzout<-maemod.ode(input.text = lorenz)

library(scatterplot3d)
scatterplot3d(lorenzout[,c(2,3,4)],type = 'l')
```
![](http://www.sakngoi.com/wp-content/uploads/2016/10/lorenz.png)

###Ex4 
using maemod with manipulate

```{r example}

#####
# mysystem1.txt
#####
!MAEMOD_Begin
STARTTIME <- 0
STOPTIME <- 500
DT <- 1/30

!Equations
mr<-1*(t>startmig)*(t<(startmig+durmig))
    
    Nh <- Sh+Es+Ia+Ic+Tr+Tnr+R+Er
    Nm <- Sm+Em+Im
    inc <- (1-Ka)*Es*(pr*pt)*p
    prev <- {(pr*pt)*Ic*p+(1-pr)*pt*Ic*p}*Es
    miSh<- 1-miIa-miIc
    moSh<- 1-moIa-moIc

    
dSh<- -b*Im*Sh/Nh   + w*R + a*Nh+ mr*miSh*Nh - mr*moSh*Nh    -a*Sh 
dEs<- b*Im*Sh/Nh - v*Ka*Es  -(1-Ka)*v*Es  -a*Es
dIa <- -  p1*Ia  + mr*miIa*Nh-mr*moIa*Nh     + v*Ka*Es    +p3*(1-pt)*Ic+ Ke*v*Er  - a*Ia
dIc <- + mr*miIc*Nh-mr*moIc*Nh   + (1-Ka)*v*Es  - p3*(1-pt)*Ic  - (pr*pt)*Ic*p -(1-pr)*pt*Ic*p  + v*(1-Ke)*Er - a*Ic 
dTr <-  -Tr*p2  +  (pr*pt)*Ic*p -Tr*a
dTnr <- -Tnr*p2+(1-pr)*pt*Ic*p   -Tnr*a
dR <-   + p1*Ia  -w*R     +Tr*p2       +Tnr*p2  - b*(Ia+Ic)*R/Nh   -a*R 
dEr <- b*(Ia+Ic)*R/Nh -Ke*v*Er- v*(1-Ke)*Er     - a*Er

 
dSm <- -b*(Ia+Ic)*Sm/Nm + am*Nm - am*Sm
dEm <- b*(Ia+Ic)*Sm/Nm-vm*Em - am*Em
dIm <- vm*Em  - am*Im


!Parameters   
a = 21.5/1000/365,
           v = 1/10, 
           p = 1/4, 
           p1 =  1/60, 
           p2 = 1/10,
           p3 = 1/14, 
           Ka = .2, 
           Ke = .2,
           pr =.9, 
           pt =.8, 
           w= 1/30, 
           b= .6, 
           startmig = 10,
           durmig=20,
           miIa = 0.03, 
           miIc = 0.05, 
           moIa = 0.03, 
           moIc = 0.05,
           am= 1/10,
           vm=30
           
!Inits      #initial value of each compartment
Sh=98900, 
Es=0,
Ia=100, 
Ic=10, 
Tr=0, 
Tnr=0, 
R=0, 
Er=0,
Sm=100000000,
Em=0,
Im=1000

!Outputs    #additional outputs
Nh=Nh,Nm=Nm,Inc=inc, prev=prev

!Plots

!MAEMOD_End


#####

library(deSolve)
library(maemod)
library(manipulate)

#where is your system file
path<-"D:\\works\\abiodun"
setwd(path)

#create the function from the system file
maemod.gensysfunction(input.filename = "mysystem1.txt")

#write a wrapper function for plotting the results
plotresults<-function(a,v,p,p1,p2,p3,Ka,Ke,pr,pt,w,b,startmig,durmig,
                      miIa,miIc,moIa,moIc,am,vm){
  parameters<-c(
    a = a,
    v = v, 
    p = p, 
    p1 =  p1, 
    p2 = p2,
    p3 = p3, 
    Ka = Ka, 
    Ke = Ke,
    pr = pr, 
    pt = pt, 
    w= w, 
    b= b, 
    startmig = startmig,
    durmig=durmig,
    miIa = miIa, 
    miIc = miIc, 
    moIa = moIa, 
    moIc = moIc,
    am= am,
    vm= vm
  )
  
  init<-initstate  #initstate is already generated from maemod.gensysfunction
  #solve the equations
  output<-ode(y=init,times = timegrid, func = MaemodSYS,parms=parameters)
  
  #plot the results
  plot(output,select=c("Nh","Nm","Inc","prev"))
  
}


manipulate(
  
  plotresults(a=21.5/1000/365,v=1/10,p=1/4,p1=1/60,p2=1/10,
              p3=1/14,Ka=0.2,Ke=0.2,pr=0.9,pt=0.8,
              w=1/30,b=0.6,startmig=10,durmig=20,
              miIa,miIc,moIa,moIc,am=1/10,vm=30)
  ,

  miIa = slider(0,1,initial = 0.03,step=0.001), 
  miIc = slider(0,1,initial = 0.05,step=0.001), 
  moIa = slider(0,1,initial = 0.03,step=0.001), 
  moIc = slider(0,1,initial = 0.05,step=0.001)

)


```

using maemod with the array equations
the state variable has to be named 'A' and the array parameter has to be 'k' in this version.

```{r example}
# Example from Berkeley Madonna
# for using Array
# METHOD RK4
#
# STARTTIME = 0
# STOPTIME = 20
# DT = 0.02
#
# d/dt (A[1]) = -k[1]*A[1]
# d/dt (A[2..n-1]) = k[i-1]*A[i-1]-k[i]*A[i]
# d/dt (A[n]) = k[n-1]*A[n-1]
#
# init A[1] = 100
# init A[2..n]=0
#
# k[1..n] =1
# n = 14
#
#

arrayEx <-'
!MAEMOD_Begin
STARTTIME <- 0
STOPTIME <- 20
DT <- 0.02
n<-14

!Equations
dA <-rep(0,n)
dA[1] <- -k[1]*A[1]
#ArrayB
"dA[i.indx] <- k[i.indx-1] *
       A[i.indx-1]-k[i.indx]*A[i.indx]"%@@%list("i.indx"%=>%2:(n-1))
#ArrayE
dA[n] <- k[n-1]*A[n-1]

!Parameters
1,1,1,1,1,1,1,1,1,1,1

!Inits
100,0,0,0,0,0,0,0,0,0,0,0,0,0

!Outputs

!Plots

!MAEMOD_End
'
out<-maemod.ode(input.text = arrayEx ,sys.template = Maemod_Array)
plot(out[,c(1,2)],type = 'l')
cols<-rainbow(14)
for(i in 3:n) lines(out[,c(1,i)],col=cols[i])
```



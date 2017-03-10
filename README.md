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
!Equations
dX <- bonemarrow - deathuninfected*X - infectionrate*X*S
dY <- infectionrate*X*S - deathinfected*Y
dS <- deathinfected*Y*nmerozoites - deathmerozoite*S - infectionrate*X*S
U <- X+Y

!Parameters   
bonemarrow = 1,
deathuninfected = 0.00833,
infectionrate = 0.1,
]deathinfected = 0.2,
nmerozoites = 16,
deathmerozoite = 72

!Inits      #initial value of each compartment
X=120, Y=0, S=0

!Outputs    #list of the outputs
c(dX,dY,dS),U=U

!ExtraFunctions   

!Plots

!MAEMOD_End
"
```
```{r solving the system numerically}
#use maemod.ode to solve the system
out <- maemod.ode(input.text = mysystem,timegrid = seq(0,600,0.1))

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
!Equations
 dY1<-Y2
 dY2<-a*sin(Y1)+sin(t)
 
!Parameters
 a= -1.0
 
!Inits
 Y1=0,Y2=0
 
!Outputs
 c(dY1,dY2)
 
!ExtraFunctions

!Plots

!MAEMOD_End

###
```

```{r solve the system and plot the results}
out<-maemod.ode(input.filename = "test.txt",timegrid = seq(0,20*pi,0.1))
plot(out[,c(2,3)],col="red")
```
![](http://www.sakngoi.com/wp-content/uploads/2016/10/heart.png)


###Ex3
```{r example }

lorenz<-"
 !Equations
 dx<-sigma*(y-x)
 dy<-x*(rho-z)-y
 dz<-x*y-beta*z
 
 !Parameters
 sigma=10, beta=2.66666, rho=28
 
 !Inits
 x=-10, y=-12, z=30.05
 
 !Outputs
 c(dx,dy,dz)
 
 !ExtraFunctions
 
 !Plots
 
 !MAEMOD_End
 "

lorenzout<-maemod.ode(input.text = lorenz, timegrid = seq(0,30,0.01))

library(scatterplot3d)
scatterplot3d(lorenzout[,c(2,3,4)],type = 'l')
```
![](http://www.sakngoi.com/wp-content/uploads/2016/10/lorenz.png)





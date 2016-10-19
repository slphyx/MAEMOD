#maemod
A user friendly compartmental modelling environment in R

##Problem
With a feature rich graphics user interface (GUI) such as RStudio and numerous packages, R is becoming a popular choice as a problem solving environment. R is used as the main programming language in many mathematical modelling of infectious diseases courses around the world, for example, an infectious disease modelling course organised by Wellcome Trust UK, an introductory course for epidemiology and control of infectious diseases by the department of infectious disease epidemiology, Imperial college London and a mathematical and economics modelling workshop organised by the Tropical Modelling Network at Bangkok Thailand. This is leading to a new generation of mathematical modellers choosing R as their main language. However, R has a steep learning curve especially for individuals who lack a strong background  in statistics, data analysis or programming. This can result in other, less flexible, software being chosen to numerically solve and fit models to data such as the Berkeley Madonna (BM; [http://www.berkeleymadonna.com/](http://www.berkeleymadonna.com/)) package. BM is easier to use than R in the sense that users have to input only the differential equations. The equations will then be solved and its output will be visualised in BM by only a few clicks. Its users have to focus on their equations rather than to worry about how to write the code to solve them. There is also a user friendly option for importing data and fitting the model to those data. We propose to develop a new R package called maemod which will include many of the user friendly features of this package, but with the advantage of including the latest methods for parameter estimation and also of course access to all the other advantages of the R environment. 

##Plan
R has many packages that could mimic the features presented in BM. For example, _deSolve_ can be used as the main engine for solving the differential equations. _ggplot2_ can be used for visualising the output and _rJava_ [http://rforge.net/rJava/](http://rforge.net/rJava/) or _rClr_ [https://rclr.codeplex.com/](https://rclr.codeplex.com/) can help in building GUI. _stats_ includes some functions, i.e., _optim_, _lm_ and _nlm_, which can be used in the parameter estimations. We will use these packages to build some wrapper functions whose inputs are about the same as BM and can output similar results to BM. 

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
deathinfected = 0.2,
nmerozoites = 16,
deathmerozoite = 72

!Inits      #initial value of each compartment
X=120, Y=0, S=0

!Outputs    #list of the outputs
c(dX,dY,dS),U=U

!ExtraFunctions   

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







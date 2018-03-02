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
DT <- 0.2
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
c(dA)

!Plots

!MAEMOD_End
'
out<-maemod.ode(input.text = arrayEx , sys.template = Maemod_Array)
plot(out[,c(1,2)],type = 'l')
cols<-rainbow(14)
for(i in 3:n) lines(out[,c(1,i)],col=cols[i])

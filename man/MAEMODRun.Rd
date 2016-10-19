\name{maemod.ode}
\alias{maemod.ode}
\title{Run, MAEMOD, Run!}
\usage{
maemod.ode(input.filename, input.txt=NULL, timegrid, ...)
}
\description{
hmm....
}
\examples{
out<-maemod.ode(input.filename = "R/ex1.txt",timegrid = seq(0,20*pi,by=0.01))
plot(out[,2:3],type='l',col='red')
}

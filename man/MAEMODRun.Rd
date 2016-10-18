\name{MAEMODRun}
\alias{MAEMODRun}
\title{Run, MAEMOD, Run!}
\usage{
MAEMODRun(input.filename, input.txt, timegrid)
}
\description{
hmm....
}
\examples{
out<-MAEMODRun(input.filename = "R/ex1.txt",timegrid = seq(0,20*pi,by=0.01))
plot(out[,2:3],type='l',col='red')
}

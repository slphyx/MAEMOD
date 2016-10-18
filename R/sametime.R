
checkifchanged<-function(intimes){
  init<-intimes[1]
  outvec<-c()
  len<-length(intimes)

  for (i in 1:(len-1)) {
    if(intimes[i]-intimes[i+1] < 0){
        outvec<-c(outvec,1)
    }
    else{
        outvec<-c(outvec,0)
      }
  }
  outvec<-c(outvec,1)
  return(outvec)
}


## timepara = {t, para1, para2,...} from solver
## it needs to be a matrix
maemod.sametimes <- function(parms.matrix, timegrid){
  inNcol<-ncol(parms.matrix)
  times<-parms.matrix[,1]

  cleantimes<-cleanEventTimes(times,timegrid)
  cleantime.para<-parms.matrix[parms.matrix[,1]%in%cleantimes,]

  nearesttimes<-nearestEvent(cleantimes,timegrid)
  outtimes<-checkifchanged(nearesttimes)
  outwant<-cbind(nearesttimes,cleantime.para[,c(2:inNcol)],outtimes)
  selected<-outwant[outwant[,(inNcol+1)]==1,]
  return(selected[,c(1:inNcol)])
}





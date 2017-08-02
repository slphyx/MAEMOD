## for using array in the !Equations section
#

# replace the pattern with the index
genArray1D<-function(expr,index,pattern='i.idx'){
  bigstr<-c()
  for(indx in index){
    bigstr<-c(bigstr,gsub(pattern,indx,expr))
  }
  paste(bigstr,collapse = '\n')
}

RemoveDuplication <- function(outstr){
  paste(unique(strsplit(outstr,split = '\n')[[1]]),collapse = '\n')
}

# for generating the list of equations
genArray <- function(expr,dim,pattern){
  #dim is the list of the indexes for each i,j or k
  #dim <- list(i=c(3,4,5),j=0,k=0)
  #pattern <- c('i.idx'.'j.idx','k.idx')

  if(length(dim$i) > 0 & (length(dim$j==0) & length(dim$k==0))){
    out.array <- genArray1D(expr,dim$i,pattern[1])
  }
  if((length(dim$i) > 0 & length(dim$j > 0)) & length(dim$k)==0){
    out.array <- genArray1D(genArray1D(expr,dim$j,pattern[2]), dim$i, pattern[1])
  }
  if((length(dim$i) > 0 & length(dim$j > 0)) & length(dim$k) > 0){
    out.array <- genArray1D(genArray1D(genArray1D(expr,dim$k,pattern[3]), dim$j, pattern[2]), dim$i, pattern[1])
  }
  RemoveDuplication(out.array)
}

'%=>%'<-function(symbol,index){
  list(symbol=symbol,index=index)
}

'%@@%' <- function(expr,pattern.indx){
  if(!is.list(pattern.indx))
    stop('please check your input!')

  if(is.list(pattern.indx) &length(pattern.indx)==1){
    index <- pattern.indx$index
    pattern <- pattern.indx$symbol
    out.array <- genArray1D(expr,index,pattern)
  }

  if(is.list(pattern.indx) & length(pattern.indx)==2){
    out.array <- genArray1D(genArray1D(expr,pattern.indx[[2]]$index,pattern.indx[[2]]$symbol),
                            pattern.indx[[1]]$index,pattern.indx[[1]]$symbol)
  }

  RemoveDuplication(out.array)
}
### testing 'dy[i.indx] <- a * i.indx '%@@%list('i.indx'%=>%1:4,'j.indx'%=>%1:3)


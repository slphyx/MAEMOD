## for using array in the !Equations section


# replace the pattern with the index
genArray1D<-function(expr,index,pattern='i.idx',sep='\n'){
  bigstr<-c()
  for(indx in index){
    bigstr<-c(bigstr,gsub(pattern,indx,expr))
  }
  paste(bigstr,collapse = sep)
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
  evalstr<-RemoveDuplication(out.array)
  eval(parse(text=evalstr))
}

'%=>%'<-function(symbol,index){
  if(!is.character(symbol)){
    stop("please check your input. %=>%(symbol_string,index_vector)")
  }
  if(!is.vector(index)){
    stop("please check your input. %=>%(symbol_string,index_vector)")
  }
  list(symbol=symbol,index=index)
}


### use with equations
### testing 'dy[i.indx] <- a * i.indx '%@@%list('i.indx'%=>%1:4,'j.indx'%=>%1:3)
'%@@%' <- function(expr,pattern.indx){
  if(!is.list(pattern.indx))
    stop('please check your input!')

  if(is.list(pattern.indx) &length(pattern.indx)==1){
    index <- pattern.indx[[1]]$index
    pattern <- pattern.indx[[1]]$symbol
    out.array <- genArray1D(expr,index,pattern)
  }

  if(is.list(pattern.indx) & length(pattern.indx)==2){
    out.array <- genArray1D(genArray1D(expr,pattern.indx[[2]]$index,pattern.indx[[2]]$symbol),
                            pattern.indx[[1]]$index,pattern.indx[[1]]$symbol)
  }
  RemoveDuplication(out.array)
}


ArrayNames <- function(expr,nm = TRUE){
  splittxt <- strsplit(expr,split = ',')[[1]]
  inputlen <- length(splittxt)
  dropped <- strsplit(splittxt,split = '<-')
  outnames <- c()
  outvals <- c()
  for(i in 1:inputlen){
    outnames <- c(outnames,paste0('"',dropped[[i]][1],'"'))
    outvals <- c(outvals,dropped[[i]][2])
  }
  if(nm == TRUE){
    paste0(outnames,collapse = ',')
  }else{
    paste0(outvals,collapse = ',')
  }
}

##
'%@%' <- function(expr,pattern.indx){
  if(!is.list(pattern.indx))
    stop('please check your input. %@%(expr,pattern.indx)')

  if(is.list(pattern.indx)&length(pattern.indx)==2){
    index <- pattern.indx$index
    pattern <- pattern.indx$symbol
    out.array <- genArray1D(expr,index,pattern,sep = ',')
  }

  genarray <- paste0('c(',ArrayNames(out.array,nm = FALSE),')')
  vecnames <- paste0('c(',ArrayNames(out.array, nm = TRUE),')')

  eval(parse(text = paste0('maemod.parameters <- setNames(',genarray,',', vecnames, ')')) , envir = .GlobalEnv)

}


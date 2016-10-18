# wrapper function for ode of deSolve
maemod.ode<-function(input.filename, input.text=NULL, timegrid, export.par=NULL,sys.template=Maemod_ODETEMPLATE1,envir=.GlobalEnv,...){

  if(!is.null(input.text)){
    GenEQFN(text=input.text,template=sys.template)
    out<-ode(y=initstate,times=timegrid,func=MaemodSYS,parms=parameters, ...)
  }
  else{
    GenEQFN(input.filename,template=sys.template)
    out<-ode(y=initstate,times=timegrid,func=MaemodSYS,parms=parameters, ...)
  }


  if(!is.null(export.par)){
    if(exists(export.par, envir = .GlobalEnv)){
      tmp.export.par<-eval(parse(text=export.par))
      assign(export.par, maemod.sametimes(tmp.export.par,timegrid),envir)
    }else{
      stop("Please check export.par parameter.")
    }
  }
  return(out)
}

maemod.gensysfunction<-function(input.filename, input.text=NULL, export.par=NULL,sys.template=Maemod_ODETEMPLATE1){
  if(!is.null(input.text)){
    GenEQFN(text=input.text,template=sys.template)
    #ode(y=initstate,times=timegrid,func=MaemodSYS,parms=parameters, ...)
  }
  else{
    GenEQFN(input.filename,template=sys.template)
    #ode(y=initstate,times=timegrid,func=MaemodSYS,parms=parameters, ...)
  }
}


##
maemod.collect<-function(input,parname,envir=.GlobalEnv){
  if(is.vector(input)){
    input.len<-length(input)
    input.str<-toString(input)
  }else{
    stop("please check maemod.collect() function.")
  }

  if(!exists(parname, envir = envir)){
    #fortime<-paste0(parname,"[1,1]")
    #forpar<-paste0(parname,"[1,2]")
    assign(parname,matrix(,nrow=0,ncol=input.len),envir = envir)
    #assign(parname,rbind(input))
    streval<-paste0(parname,"<<-","rbind(",parname,",c(",toString(input),"))")
    #assign(parname,rbind(input),envir = .GlobalEnv)
    eval(parse(text = streval),envir=envir)

  }else{
    streval<-paste0(parname,"<<-","rbind(",parname,",c(",toString(input),"))")
    #assign(parname,rbind(input),envir = .GlobalEnv)
    eval(parse(text = streval),envir=envir)
  }

}

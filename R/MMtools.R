# wrapper function for deSolve::ode
maemod.ode<-function(input.filename, input.text=NULL, export.par=NULL,sys.template=Maemod_ODETEMPLATE,envir=.GlobalEnv,...){

  vars4plot<-NULL

  if(!is.null(input.text)){
    ## read input from text
    vars4plot <- PlotVars(input.text)
    GenEQFN(text=input.text,template=sys.template)
    # check if timegrid exists
    if(!exists("timegrid")){
      stop('timegrid cannot be created. Please check STARTTIME, STOPTIME and DT.')
    }
    out<-ode(y=maemod.initstate,times=timegrid,func=MaemodSYS,parms=maemod.parameters, ...)
    if(!is.null(vars4plot)){
      plot(out, select = vars4plot, type='l')
    }
  }
  else{
    ##read input from file
    vars4plot <- PlotVarsFile(input.filename)
    GenEQFN(input.filename,template=sys.template)
    # check if timegrid exists
    if(!exists("timegrid")){
      stop('timegrid cannot be created. Please check STARTTIME, STOPTIME and DT.')
    }
    out<-ode(y=maemod.initstate,times=timegrid,func=MaemodSYS,parms=maemod.parameters, ...)
    if(!is.null(vars4plot)){
      plot(out, select = vars4plot, type='l')
    }
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

maemod.gensysfunction<-function(input.filename, input.text=NULL, export.par=NULL,sys.template=Maemod_ODETEMPLATE){
  if(!is.null(input.text)){
    GenEQFN(text=input.text,template=sys.template)
  }
  else{
    GenEQFN(input.filename,template=sys.template)
  }
}

maemod.collect<-function(input,parname,envir=.GlobalEnv){
  if(is.vector(input)){
    input.len<-length(input)
    input.str<-toString(input)
  }else{
    stop("please check maemod.collect() function.")
  }

  if(!exists(parname, envir = envir)){
    assign(parname,matrix( ,nrow=0,ncol=input.len),envir = envir)
    streval<-paste0(parname,"<<-","rbind(",parname,",c(",toString(input),"))")
    eval(parse(text = streval),envir=envir)

  }else{
    streval<-paste0(parname,"<<-","rbind(",parname,",c(",toString(input),"))")
    eval(parse(text = streval),envir=envir)
  }

}

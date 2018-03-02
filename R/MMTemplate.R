###
#   MMTemplate for generating the system function using the input equations
#
#   Build and Reload Package:  'Ctrl + Shift + B'
#   Check Package:             'Ctrl + Shift + E'
#   Test Package:              'Ctrl + Shift + T'


Maemod_ODETEMPLATE <- "
MAEModBegin

timegrid <- seq(STARTTIME,STOPTIME,DT)
MaemodSYS<-function(t, state, parameters) {
  with(as.list(c(state, parameters)),{

    MAEModYOUREQ

    list( MAEModOUTPUTCOL )
  })
}


maemod.parameters<-c( MAEModPARAMETERS )

maemod.initstate<-c( MAEModSTATE )

";

Maemod_Array <- "
MAEModBegin

maemod.parameters<-c( MAEModPARAMETERS )

maemod.initstate<-c( MAEModSTATE )
timegrid <- seq(STARTTIME,STOPTIME,DT)
MaemodSYS<-function(t, state, parameters) {

  k<-parameters
  A<-state

  with(as.list(c(state, parameters)),{

    MAEModYOUREQ

    list( MAEModOUTPUTCOL )
  })
}

";

PasteFunc<-function(inputfunctions, Template){
  gsub("MAEModBegin", inputfunctions, Template)
}

PasteEQ<-function(inputSys,Template){
  gsub("MAEModYOUREQ",inputSys,Template)
}

#input is the text from PasteEQ
PasteEQArray <- function(input){
  pattern <- "#ArrayB(.*?)#ArrayE"
  matched <- regmatches(input,regexec(pattern,input))[[1]]
  arraystrwithkeys <- matched[1]
  arraystr <- eval(parse(text = matched[2]))

  gsub(arraystrwithkeys,arraystr,input,fixed = TRUE)
}

#check if !ArrayB exists
ArrayQ <- function(inputstr){
  chk <- str_match(inputstr,'#ArrayB')
  if(is.na(chk))
    return(FALSE)
  else
    return(TRUE)
}

PasteOutputcol<-function(listoutput,Template){
  gsub("MAEModOUTPUTCOL",listoutput,Template)
}

PasteParms<-function(inputparms,Template){
  gsub("MAEModPARAMETERS",inputparms,Template)
}

PasteInit<-function(initstate,Template){
  gsub("MAEModSTATE",initstate,Template)
}

#generate the equation function
#extractedstring is the output from ExtractInputs or ExtractInputsFromFile
GenEQFN<-function(filename, text=NULL, template=Maemod_ODETEMPLATE1, envir=.GlobalEnv){

  if(is.null(text)){
    ## read from input file

    extractedstring<-ExtractInputsFromFile(filename)
    exfnstr<-as.character(extractedstring[extractedstring$keys=='!MAEMOD_Begin',2])
    strExFn<-PasteFunc(exfnstr,Template = template)

    eqstr<-as.character(extractedstring[extractedstring$keys=='!Equations',2])
    strEQ<-PasteEQ(eqstr,strExFn)
    if(ArrayQ(strEQ)){
      #require some parameters from ExtraFunction block
      eval(parse(text = exfnstr),envir=envir)
      strEQ <- PasteEQArray(strEQ)
    }

    parstr<-as.character(extractedstring[extractedstring$keys=='!Parameters',2])
    strEQOutPar<-PasteParms(parstr,strEQ)

    initstr<-as.character(extractedstring[extractedstring$keys=='!Inits',2])
    strEQOutParInit<-PasteInit(initstr,strEQOutPar)

    compartments <- RemoveRN(Compartment.Names(initstr))
    outputstr<-RemoveRN(as.character(extractedstring[extractedstring$keys=='!Outputs',2]))
    if(!is.null(eval(parse(text = outputstr))))
      all.outputstr <- paste0(compartments,",",outputstr)
    else
      all.outputstr <- compartments
    strEQOut<-PasteOutputcol(all.outputstr,strEQOutParInit)


    write(strEQOut,file = "MAEMODSys.inp")
    eval(parse(file = "MAEMODSys.inp"),envir=envir)
  }
  else{
    ## read from input text

    KW<-KeyWordsPosition(text)
    extractedstring<-ExtractInputs(KW,text)

    exfnstr<-as.character(extractedstring[extractedstring$keys=='!MAEMOD_Begin',2])
    strExFn<-PasteFunc(exfnstr,Template = template)

    eqstr<-as.character(extractedstring[extractedstring$keys=='!Equations',2])
    strEQ<-PasteEQ(eqstr,strExFn)
    if(ArrayQ(strEQ)){
      #require some parameters from ExtraFunction block
      eval(parse(text = exfnstr),envir=envir)
      strEQ <- PasteEQArray(strEQ)
    }

    parstr<-as.character(extractedstring[extractedstring$keys=='!Parameters',2])
    strEQOutPar<-PasteParms(parstr,strEQ)

    initstr<-as.character(extractedstring[extractedstring$keys=='!Inits',2])
    strEQOutParInit<-PasteInit(initstr,strEQOutPar)


    compartments <- RemoveRN(Compartment.Names(initstr))
    outputstr<- RemoveRN(as.character(extractedstring[extractedstring$keys=='!Outputs',2]))
    if(!is.null(eval(parse(text = outputstr))))
      all.outputstr <- paste0(compartments,",",outputstr)
    else
      all.outputstr <- compartments
    strEQOut<-PasteOutputcol(all.outputstr,strEQOutParInit)


    write(strEQOut,file = "MAEMODSys.inp")
    eval(parse(file = "MAEMODSys.inp"),envir=envir)

  }
}



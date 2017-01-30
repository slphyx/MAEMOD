###
#   MMTemplate for generating the system function using the input equations
#
#   Build and Reload Package:  'Ctrl + Shift + B'
#   Check Package:             'Ctrl + Shift + E'
#   Test Package:              'Ctrl + Shift + T'

Maemod_ODETEMPLATE2 <- "
MAEModExtraFunctions

MaemodSYS<-function(t, state, parameters) {
  with(as.list(c(state, parameters)),{

    MAEModYOUREQ

    list(c( MAEModOUTPUTCOL ))
  })
}


parameters<-c( MAEModPARAMETERS )

initstate<-c( MAEModSTATE )

";

Maemod_ODETEMPLATE1 <- "
MAEModExtraFunctions

MaemodSYS<-function(t, state, parameters) {
  with(as.list(c(state, parameters)),{

    MAEModYOUREQ

    list( MAEModOUTPUTCOL )
  })
}


parameters<-c( MAEModPARAMETERS )

initstate<-c( MAEModSTATE )

";


PasteFunc<-function(inputfunctions, Template){
  gsub("MAEModExtraFunctions", inputfunctions, Template)
}

PasteEQ<-function(inputSys,Template){
  gsub("MAEModYOUREQ",inputSys,Template)
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
    exfnstr<-as.character(extractedstring[extractedstring$keys=='!ExtraFunctions',2])
    strExFn<-PasteFunc(exfnstr,Template = template)

    eqstr<-as.character(extractedstring[extractedstring$keys=='!Equations',2])
    strEQ<-PasteEQ(eqstr,strExFn)

    outputstr<-as.character(extractedstring[extractedstring$keys=='!Outputs',2])
    strEQOut<-PasteOutputcol(outputstr,strEQ)

    parstr<-as.character(extractedstring[extractedstring$keys=='!Parameters',2])
    strEQOutPar<-PasteParms(parstr,strEQOut)

    initstr<-as.character(extractedstring[extractedstring$keys=='!Inits',2])
    strEQOutParInit<-PasteInit(initstr,strEQOutPar)


    write(strEQOutParInit,file = "MAEMODSys.inp")
    eval(parse(file = "MAEMODSys.inp"),envir=envir)
  }
  else{
    ## read from input text

    KW<-KeyWordsPosition(text)
    extractedstring<-ExtractInputs(KW,text)

    exfnstr<-as.character(extractedstring[extractedstring$keys=='!ExtraFunctions',2])
    strExFn<-PasteFunc(exfnstr,Template = template)

    eqstr<-as.character(extractedstring[extractedstring$keys=='!Equations',2])
    strEQ<-PasteEQ(eqstr,strExFn)

    outputstr<-as.character(extractedstring[extractedstring$keys=='!Outputs',2])
    strEQOut<-PasteOutputcol(outputstr,strEQ)

    parstr<-as.character(extractedstring[extractedstring$keys=='!Parameters',2])
    strEQOutPar<-PasteParms(parstr,strEQOut)

    initstr<-as.character(extractedstring[extractedstring$keys=='!Inits',2])
    strEQOutParInit<-PasteInit(initstr,strEQOutPar)


    write(strEQOutParInit,file = "MAEMODSys.inp")
    eval(parse(file = "MAEMODSys.inp"),envir=envir)

  }
}



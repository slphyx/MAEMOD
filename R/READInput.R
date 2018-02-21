
# read from input string

MAEMOD_Keys<-c("!Equations","!Parameters", "!Outputs", "!Inits", "!ExtraFunctions", "!Plots", "!MAEMOD_End")

# number of keys
No_Keys <- length(MAEMOD_Keys)

##  read the input from a text file
ReadInputString<-function(filename){
  readChar(filename,file.info(filename)$size)
}

KeyLength<-function(key){
  if(key %in% MAEMOD_Keys){
    return(nchar(key))
  }
  else
  {
    stop("The input key does not exist.")
  }
}


# give the position of each keyword
KeyWordsPosition<-function(inputstring){
  rawpos<-gregexpr(pattern = '!',inputstring)
  len<-length(rawpos[[1]])

  if(len != No_Keys){
    stop("PLEASE CHECK YOUR INPUT KEYS!")
  }

  keyspos<-1:No_Keys
  #pos<-unlist(rawpos)
  for(i in 1:No_Keys){
    keyspos[i]<-unlist(gregexpr(MAEMOD_Keys[i],inputstring))
  }

  KW<-data.frame(keys=MAEMOD_Keys,positions=keyspos)
  #sorting based on the positions
  return(KW[sort.list(KW$positions),])
}

#extracting the inputs using the keywords
ExtractInputs<-function(keypositions, inputstring){
  keys<-as.vector(keypositions$keys)
  pos<-keypositions$pos
  extractstring<-vector(mode = "character",length = length(pos))
  for(i in 1:(No_Keys-1)){
    extractstring[i]<-substr(inputstring,pos[i]+KeyLength(keys[i]),pos[i+1]-1)
  }
  return(data.frame(keys=keys,inputs=extractstring, stringsAsFactors=FALSE))
}

#extrating from a file
ExtractInputsFromFile<-function(filename){
  if(file.exists(filename)){
    inputstring<-ReadInputString(filename)
    KW<-KeyWordsPosition(inputstring)
    extracted<-ExtractInputs(KW,inputstring)
  }else
  {
    stop("Where is your input file!? It is not in your working directory.")
  }
  return(extracted)
}

# list of the parameters for plotting the results
PlotVars<-function(intext){
  KW<-KeyWordsPosition(inputstring = intext)
  extractedstring<-ExtractInputs(keypositions = KW, inputstring = intext)

  explotvarstr<-as.character(extractedstring[extractedstring$keys=='!Plots',2])
  eval(parse(text=explotvarstr))
}

# list of the parameters for plotting from the input file
PlotVarsFile<-function(filename){
  if(file.exists(filename)){
    intext <- ReadInputString(filename)
  }
  PlotVars(intext)
}

Parameter.Names <- function(...){
  if(exists("maemod.parameters"))
    names(maemod.parameters)
  else
    stop('maemod.parameters does not exist!')
}

#vector of the compartments
# their names must be began with 'd', i.e., dX,dS, dInfected, etc..
Compartment.Names <- function(...){
  if(exists("maemod.initstate"))
    names(maemod.initstate)
  else
    stop('maemod.initstate does not exist!')
}

#list of the compartments and the variables shown in deSolve object
Compartment.Names.Output <- function(obj,...){
  colnames(obj)
}

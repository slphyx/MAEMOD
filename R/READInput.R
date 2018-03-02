
# read from input string

MAEMOD_Keys<-c("!MAEMOD_Begin","!Equations", "!Parameters", "!Outputs", "!Inits", "!Plots", "!MAEMOD_End")

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

#retunrn the input text for each section key
ExtractInputFromKey <- function(intext, key){

  KW<-KeyWordsPosition(inputstring = intext)
  extractedstring<-ExtractInputs(keypositions = KW, inputstring = intext)

  outstr<-as.character(extractedstring[extractedstring$keys==key,2])
  return(outstr)

}


# remove '\n' and ' ' from string input
RemoveSpace <- function(input){
  #remove '\n'
  tmp <- str_replace_all(string = input, pattern = "\n", replacement = "")
  #remove white space ' '
  tmp <- str_replace_all(string = tmp, pattern = " ", replacement = "")
  return(tmp)
}

#for solving the '\r\n' problem
# remove \r
RemoveRN <- function(input){
  str_replace_all(string = input, pattern = "\r", replacement = "")
}

# list of the parameters for plotting the results
PlotVars<-function(intext){
  explotvarstr <- ExtractInputFromKey(intext, key="!Plots")
  #print(explotvarstr)
  tmp<- eval(parse(text = RemoveRN(explotvarstr)))
  return(tmp)
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

addD <- function(cpnm.vector){
  dc <- paste(paste0("d",cpnm.vector),collapse = ",")
  paste0("c(",dc,")")
}

# get the namges of the compartments from !Inits
Compartment.Names <- function(inputinits, addD = T,...){
  # if(exists("maemod.initstate"))
  #   if(addD==F){
  #     return(names(maemod.initstate))
  #   }else{
  #     return(addD(names(maemod.initstate)))
  #   }
  # else
  #   stop('maemod.initstate does not exist!')

  #inputinits <- ExtractInputFromKey(inputtxt, key= "!Inits")
  tmp <- RemoveSpace(input = inputinits)
  tmp <- unlist(str_split(string = tmp, pattern = ","))
  n.compartments <- length(tmp)
  tmp <- unlist(str_split(string = tmp, pattern = "="))
  if(addD==T)
    return(addD(tmp[2*(0:(n.compartments-1))+1]))
  else
    return(tmp[2*(0:(n.compartments-1))+1])
}




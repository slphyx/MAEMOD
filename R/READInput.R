###
#   MMTemplate for generating the system function using the input equations
#
#   Build and Reload Package:  'Ctrl + Shift + B'
#   Check Package:             'Ctrl + Shift + E'
#   Test Package:              'Ctrl + Shift + T'


# read from input string

MAEMOD_Keys<-c("!Equations","!Parameters", "!Outputs", "!Inits", "!ExtraFunctions", "!MAEMOD_End")

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
    stop("PLEASE CHECK YOUR INPUT KEYS.")
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


ExtractInputs<-function(keypositions, inputstring){
  keys<-as.vector(keypositions$keys)
  pos<-keypositions$pos
  extractstring<-vector(mode = "character",length = length(pos))
  for(i in 1:(No_Keys-1)){
    extractstring[i]<-substr(inputstring,pos[i]+KeyLength(keys[i]),pos[i+1]-1)
  }
  return(data.frame(keys=keys,inputs=extractstring))
}

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





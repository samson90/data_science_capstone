library(data.table)
library(stringi)
source("preprocessing.R")

create_one_tdm <- function(file_name, tdm, curse_words){
  file <- file(file_name, open="rb")
  while(length(content <- readLines(file, n=50000, encoding="UTF8", skipNul=TRUE)) > 0){
    # clean the text.
    content <- preprocessing(content, curse_words)
    
    words <- unlist(stri_split_boundaries(content))
    words <- gsub(" ", "", words)
    remove(content)
    gc()
    
    n0 = character(length(words))
    for (i in 1:(length(words))){
      n0[i] = words[i]
    }
    n_grams = data.table(n0=n0, freq=rep(1, length(n0)))
    remove(n0)
    remove(words)
    gc()
    setkey(n_grams, n0)
    tdm <- rbindlist(list(tdm, n_grams[,sum(freq),by=c("n0")]))
    remove(n_grams)
    gc()
    setkey(tdm, n0)
    tdm <- tdm[,sum(freq),by=c("n0")]
    setnames(tdm, c("n0", "V1"), c("n0", "freq"))
  }
  close(file)
  tdm
}

create_two_tdm <- function(file_name, tdm, curse_words){
  file <- file(file_name, open="rb")
  while(length(content <- readLines(file, n=50000, encoding="UTF8", skipNul=TRUE)) > 0){
    # clean the text.
    content <- preprocessing(content, curse_words)
    
    words <- unlist(stri_split_boundaries(content))
    remove(content)
    gc()
    
    n1 = character(length(words)-1)
    n0 = character(length(words)-1)
    for (i in 1:(length(words)-1)){
      n1[i] = words[i]
      n0[i] = words[i+1]
    }
    n_grams = data.table(n1=n1, n0=n0, freq=rep(1, length(n0)))
    remove(n0, n1)
    remove(words)
    gc()
    setkey(n_grams, n1, n0)
    tdm <- rbindlist(list(tdm, n_grams[,sum(freq),by=c("n1", "n0")]))
    gc()
    setkey(tdm, n1, n0)
    tdm <- tdm[,sum(freq),by=c("n1", "n0")]
    setnames(tdm, c("n1", "n0", "V1"), c("n1", "n0", "freq"))
  }
  close(file)
  tdm
}

create_three_tdm <- function(file_name, tdm, curse_words){
  file <- file(file_name, open="rb")
  while(length(content <- readLines(file, n=50000, encoding="UTF8", skipNul=TRUE)) > 0){
    # clean the text.
    content <- preprocessing(content, curse_words)
    
    words <- unlist(stri_split_boundaries(content))
    words <- gsub(" ", "", words)
    remove(content)
    gc()
    
    n2 = character(length(words)-2)
    n1 = character(length(words)-2)
    n0 = character(length(words)-2)
    for (i in 1:(length(words)-2)){
      n2[i] = words[i]
      n1[i] = words[i+1]
      n0[i] = words[i+2]
    }
    n_grams = data.table(n2=n2, n1=n1, n0=n0, freq=rep(1, length(n0)))
    remove(n2, n1, n0)
    remove(words)
    gc()
    setkey(n_grams, n2, n1, n0)
    tdm <- rbindlist(list(tdm, n_grams[,sum(freq),by=c("n2", "n1", "n0")]))
    remove(n_grams)
    gc()
    setkey(tdm, n2, n1, n0)
    tdm <- tdm[,sum(freq),by=c("n2", "n1", "n0")]
    setnames(tdm, c("n2", "n1", "n0", "V1"), c("n2", "n1", "n0", "freq"))
  }
  close(file)
  tdm
}

create_four_tdm <- function(file_name, tdm, curse_words){
  file <- file(paste("final/training", file_name, sep="/"), open="rb")
  # read files
  while(length(content <- readLines(file, n=50000, encoding="UTF8", skipNul=TRUE)) > 0){
    # clean the text.
    content <- preprocessing(content, curse_words)
    
    words <- unlist(stri_split_boundaries(content))
    words <- gsub(" ", "", words)
    remove(content)
    gc()
    
    n0 = character(length(words))
    n1 = character(length(words))
    n2 = character(length(words))
    n3 = character(length(words))
    for (i in 1:(length(words)-3)){
      n0[i] = words[i]
      n1[i] = words[i+1]
      n2[i] = words[i+2]
      n3[i] = words[i+3]
    }
    n_grams = data.table(n0=n0, n1=n1, n2=n2, n3=n3, freq=rep(1, length(n0)))
    remove(n0, n1, n2, n3)
    remove(words)
    gc()
    setkey(n_grams, n0, n1, n2, n3)
    tdm <- rbindlist(list(tdm, n_grams[,sum(freq),by=c("n0", "n1", "n2", "n3")]))
    remove(n_grams)
    gc()
    setkey(tdm, n0, n1, n2, n3)
    tdm <- tdm[,sum(freq),by=c("n0", "n1", "n2", "n3")]
    setnames(tdm, c("n0", "n1", "n2", "n3", "V1"), c("n0", "n1", "n2", "n3", "freq"))
  }
  close(file)
  tdm
}
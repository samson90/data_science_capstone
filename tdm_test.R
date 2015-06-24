#### Data Table impelementation ####

library(data.table)
library(stringi)

create_tdm <- function(file_name, tdm, curse_words){
  file <- file(paste("final/en_US", file_name, sep="/"), open="rb")
  # read files
  while(length(content <- readLines(file, n=50000, encoding="UTF8", skipNul=TRUE)) > 0){
    ptm <- proc.time()
    
    # remove any character that is not an alpha-numeric or space
    print("Remove non alpha-numerics")
    content <- gsub("[^a-zA-Z0-9 ]", "", content)
    
    # convert to all lowercase
    print("Converting to all lowercase")
    content <- tolower(content)
    
    # remove any extra whitespace and trailing or ending whitespace.
    print("Remove extra whitespace")
    content <- gsub(" +( )", "\\1", content)
    content <- gsub("^ *| *$", "", content)
    
    print("Remove swear words")
    # remove the curse words from the content
    content <- gsub(curse_words, "", content)
    
    print(proc.time() - ptm)
    
    ptm <- proc.time()
    
    print("Creating term document matrix")
    
    print("splitting strings")
    words <- unlist(stri_split_boundaries(content))
    remove(content)
    gc()

    print("allocating memory for data table")
    n0 = character(length(words))
    ix = 1
    print("storing grams")
    for (i in 1:length(words)){
      n0[ix] = words[i]
      ix = ix + 1
    }
    n_grams = data.table(n0=n0, freq=rep(1, length(n0)))
    remove(n0)
    remove(words)
    gc()
    print("creating keys")
    setkey(n_grams, n0)
    print("summing n_grams")
    tdm <- rbindlist(list(tdm, n_grams[,sum(freq),by="n0"]))
    remove(n_grams)
    gc()
    print("summing tdm")
    setkey(tdm, n0)
    tdm <- tdm[,sum(freq),by="n0"]
    setnames(tdm, c("n0","V1"), c("n0","freq"))

    print(proc.time() - ptm)
  }
  close(file)
  tdm
}

# read in list of curse words.
curse_words = readLines("final/swearWords.txt")

# add the word boundaries
curse_words = paste(curse_words, collapse = "\\b|\\b")
curse_words = paste(paste("\\b", curse_words, sep=""), "\\b", sep="")

# create empty term-document matrix
one_tdm <- data.table(n0=character(0), freq=numeric(0))

# reading blogs file
one_tdm <- create_tdm("en_US.blogs.txt", one_tdm, curse_words)
print(object.size(one_tdm))

#reading twitter file
one_tdm <- create_tdm("en_US.twitter.txt", one_tdm, curse_words)
print(object.size(one_tdm))

# reading news file
one_tdm <- create_tdm("en_US.news.txt", one_tdm, curse_words)
print(object.size(one_tdm))

print("Final size after removing sparse terms (1, 2, and 4):")
print(object.size(one_tdm[freq>1,]))
print(object.size(one_tdm[freq>2,]))
print(object.size(one_tdm[freq>4,]))

save(one_tdm, file="one_tdm.RData")
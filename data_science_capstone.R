library(tm)

ptm <- proc.time()
print("Loading corpus")
n <- commandArgs(TRUE)
corpus <- Corpus(DirSource(paste("final/en_US_", n, sep="/"))

proc.time() - ptm

ptm <- proc.time()

# remove any character that is not an alpha-numeric or space
print("Remove non alpha-numerics")
gsub_remove <- content_transformer(function(x, pattern) gsub(pattern, "", x))
corpus <- tm_map(corpus, gsub_remove, "[^a-zA-Z0-9 ]")

# convert to all lowercase
print("Converting to all lowercase")
corpus <- tm_map(corpus, content_transformer(tolower))

# remove any extra whitespace and trailing or ending whitespace.
print("Remove extra whitespace")
gsub_remove2 <- content_transformer(function(x, pattern) gsub(pattern, "\\1", x))
corpus <- tm_map(corpus, gsub_remove2, " +( )")
corpus <- tm_map(corpus, gsub_remove, "^ *| *$")

# read in list of curse words.
print("Remove swear words")
curse_words = readLines("final/swearWords.txt")

# add the word boundaries
curse_words = paste(curse_words, collapse = "\\b|\\b")
curse_words = paste(paste("\\b", curse_words, sep=""), "\\b", sep="")

# remove the curse words from the corpus and replace them with '*explicit'
corpus <- tm_map(corpus, gsub_remove, curse_words)

proc.time() - ptm

library(RWeka)
ptm <- proc.time()
print("Create one-gram tdm")
one_gram_tokenizer <- function(x) NGramTokenizer(x, Weka_control(min = 1, max = 4))
one_tdm <- TermDocumentMatrix(corpus, control=list(tokenizer=one_gram_tokenizer))
proc.time() - ptm
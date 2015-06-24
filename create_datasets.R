# read in list of curse words.
curse_words = readLines("final/swearWords.txt")

# add the word boundaries
curse_words = paste(curse_words, collapse = "\\b|\\b")
curse_words = paste(paste("\\b", curse_words, sep=""), "\\b", sep="")

source("tdm.R")

# create the training term doc matrices.
three_tdm <- data.table(n0=character(0), n1=character(0), n2=character(0), freq=numeric(0))
three_tdm <- create_three_tdm("final/training/blogs.txt", three_tdm, curse_words)
three_tdm <- create_three_tdm("final/training/twitter.txt", three_tdm, curse_words)
three_tdm <- create_three_tdm("final/training/news.txt", three_tdm, curse_words)
three_tdm <- three_tdm[freq>1,] # remove sparse n-grams.
three_tdm <- three_tdm[three_tdm$n0 != "" & three_tdm$n1 != "" & three_tdm$n2 != "",]
write.table(three_tdm, file="final/training/three_tdm.csv", row.names=FALSE)

two_tdm <- data.table(n0=character(0), n1=character(0), freq=numeric(0))
two_tdm <- create_two_tdm("final/training/blogs.txt", two_tdm, curse_words)
two_tdm <- create_two_tdm("final/training/twitter.txt", two_tdm, curse_words)
two_tdm <- create_two_tdm("final/training/news.txt", two_tdm, curse_words)
two_tdm <- two_tdm[freq>1,] # remove sparse n-grams.
write.table(two_tdm, file="final/training/two_tdm.csv", row.names=FALSE)

one_tdm <- data.table(n0=character(0), freq=numeric(0))
one_tdm <- create_one_tdm("final/training/blogs.txt", one_tdm, curse_words)
one_tdm <- create_one_tdm("final/training/twitter.txt", one_tdm, curse_words)
one_tdm <- create_one_tdm("final/training/news.txt", one_tdm, curse_words)
one_tdm <- one_tdm[freq>1,] # remove sparse n-grams.
write.table(one_tdm, file="final/training/one_tdm.csv", row.names=FALSE)

# # create the cross-validation term doc matrix.
# three_tdm <- data.table(n0=character(0), n1=character(0), n2=character(0), freq=numeric(0))
# three_tdm <- create_three_tdm("final/cv/blogs.txt", three_tdm, curse_words)
# three_tdm <- create_three_tdm("final/cv/twitter.txt", three_tdm, curse_words)
# three_tdm <- create_three_tdm("final/cv/news.txt", three_tdm, curse_words)
# three_tdm <- three_tdm[three_tdm$n0 != "" & three_tdm$n1 != "" & three_tdm$n2 != "",]
# write.table(three_tdm, file="final/cv/three_tdm.csv")
# 
# # create the test term doc matrix.
# three_tdm <- data.table(n0=character(0), n1=character(0), n2=character(0), freq=numeric(0))
# three_tdm <- create_three_tdm("final/test/blogs.txt", three_tdm, curse_words)
# three_tdm <- create_three_tdm("final/test/twitter.txt", three_tdm, curse_words)
# three_tdm <- create_three_tdm("final/test/news.txt", three_tdm, curse_words)
# three_tdm <- three_tdm[three_tdm$n0 != "" & three_tdm$n1 != "" & three_tdm$n2 != "",]
# write.table(three_tdm, file="final/test/three_tdm.csv")
library(data.table)

#read in list of curse words.
curse_words = readLines("final/swearWords.txt")
curse_words = paste(curse_words, collapse = "\\b|\\b")
curse_words = paste(paste("\\b", curse_words, sep=""), "\\b", sep="")

# 1 gram term document matrix
final_one_tdm <- fread('final/training/one_tdm.csv', header=TRUE)
final_one_tdm <- final_one_tdm[order(freq, decreasing=TRUE)]
setkey(final_one_tdm, n0)

# 2 gram term document matrix
final_two_tdm <- fread('final/training/two_tdm.csv', header=TRUE)
final_two_tdm <- final_two_tdm[final_two_tdm$n0 != ' ' & final_two_tdm$n1 != ' ']
setkey(final_two_tdm, n0, n1)

# 3 gram term document matrix
final_three_tdm <- fread('final/training/three_tdm.csv', header=TRUE)
final_three_tdm <- final_three_tdm[final_three_tdm$n0 != ' ' & final_three_tdm$n1 != ' ' & final_three_tdm$n2 != ' ']
setkey(final_three_tdm, n0, n1, n2)
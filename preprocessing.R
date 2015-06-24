# takes a character vector and a regular expression with curse_words and 
# performs some cleaning.
library(stringi)
preprocessing <- function(content, curse_words){

  
  # add the start and stop words word.
  content <- gsub("\\!|\\?|\\;|\\:", "\n", content)
  content <- gsub("([^A-Z])\\. ", "\\1\n", content)
  content <- unlist(stri_split_regex(content, "\n"))
  
  # convert to all lowercase
  content <- tolower(content)
  
  # insert starts and stops
  content <- paste(paste("START", content), "STOP")
  
  # remove any character that is not an alpha-numeric or space
  content <- gsub("[^a-zA-Z0-9 ]", "", content)

  # remove any extra whitespace and trailing or ending whitespace.
  content <- gsub(" +( )", "\\1", content)
  content <- gsub("^ *| *$", "", content)
  
  # remove the curse words from the content
  content <- gsub(curse_words, "", content)
}
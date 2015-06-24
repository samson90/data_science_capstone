# takes a previous phrase and returns a vector of predicted terms. Should have 
# the term_documents and  curse words in scope.
conditional_prediction <- function(test){
    # run the test set through the preprocessing
    phrase <- gsub(" +( )", '\\1', phrase)
    phrase <- gsub("^ *| *$", '', phrase)
    phrase = gsub('[^a-zA-Z0-9 ]', '', phrase)
    phrase = gsub(curse_words, '', phrase)
    
    # convert to lowercase
    phrase = tolower(phrase)
    
    prev_terms <- strsplit(phrase, ' ')
    prev_terms <- unlist(prev_terms)
    predicted_terms <- final_one_tdm
    predicted_terms$freq <- predicted_terms$freq / term_sum
    setnames(predicted_terms, c("n0", "freq"), c("term", "probability"))
    if (length(prev_terms) == 2)
    {
        subset <- final_three_tdm[J(prev_terms[1], prev_terms[2])]
        if (!is.na(subset[1]$freq))
        {
            predicted_terms <- data.table(subset$n2, subset$freq)
            predicted_terms$V2 <- predicted_terms$V2 / sum(predicted_terms$V2)
            setnames(predicted_terms, c("V1", "V2"), c("term", "probability"))
        }
        else
            prev_terms <- tail(prev_terms, 1)
    }
    if (length(prev_terms) == 1 && nchar(phrase) > 0)
    {
        subset <- final_two_tdm[J(prev_terms[1])]
        if (!is.na(subset[1]$freq))
        {
            predicted_terms <- data.table(subset$n1, subset$freq)
            predicted_terms$V2 <- predicted_terms$V2 / sum(predicted_terms$V2)
            setnames(predicted_terms, c("V1", "V2"), c("term", "probability"))
        }
    }
    predicted_terms[order(-probability),]
}
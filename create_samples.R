# get percentage from user.
n <- commandArgs(TRUE)
n <- as.integer(n)

# n <- 1

dir <- paste("final/en_US_", n, sep ="")
if (file.exists(dir)){
    print(paste("Directory", dir, "alredy exists"))
} else {
    dir.create(dir)
}

create_sample <- function(file_name){
    # reads in a file and creates a new file with a sample of the text.
    read_file <- file(paste("final/en_US", file_name, sep="/"), open="rb")
    content <- readLines(read_file, encoding="UTF-8", skipNul=TRUE)
    close(read_file)    

    write(content[sample(1:length(content), length(content) / (100/n))], 
          paste(dir, file_name, sep="/"))
}

create_sample("en_US.twitter.txt")
create_sample("en_US.blogs.txt")
create_sample("en_US.news.txt")
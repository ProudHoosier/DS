library(data.table)

getwd()
setwd("/Users/DS/RProjects/code")

weight <- 8

# regularize the data set.
likelihood <- function (dataTab, var, target, weight){
  p=dataTab[,sum(get(target))/.N]
  dataTab[ ,.(prob = (sum(get(target)) + weight*p )/(.N + weight)), by=eval(var)]
}

# Handle the missing values i.e. replacing na by 0
fill_missing <- function(dataTab, replacement=0) {
  for (i in seq_len(ncol(dataTab)))
    set(dataTab, which(is.na(dataTab[[j]])), i, replacement)
}

# Read input file and set key value when key is not null
pre_process <- function(file, key_var=NULL){
  dataTab <- fread(file)
  if(!is.null(key_var)) setkeyv(dataTab,c(key_var))
  return(dataTab)
}

training  <- pre_process( "tarining_data.csv", key_var = "unique_id" )

probability = training[,.(sum(clicked)/.N)]
unique_id_prob <- likelihood(training, "unique_id", "clicked", weight)

#remove training object from env and garbage collect it.
rm(training)
gc()

test <- pre_process("test_data.csv" , key_var = "unique_id" )
test <- merge(test_data, unique_id_prob, all.x = T )

fill_missing(test_data, probability)

setkey(test_data, "probability")

# Concatenate the unique ids separated by single space in reverse order
result <- test_data[,.(unique_id = paste(sort(unique_id, decreasing = TRUE), collapse = " ")), by = display_id]
setkey(result, "display_id")

#write the result without row names in a csv file in working directory
write.csv(result, file = "result.csv", row.names = FALSE)

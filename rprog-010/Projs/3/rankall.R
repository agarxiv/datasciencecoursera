rankall <- function(outcome, num = "best") {

	## Read outcome data
	## Check that state and outcome are valid
	## For each state, find the hospital of the given rank
	## Return a data frame with the hospital names and the
	## (abbreviated) state name

	options(warn=-1)
	orderfunc <- function(x){
		if(outcome=='heart attack'){
			x[with(x, order(as.numeric(x[,11]), as.character(x[,2]), na.last=NA)),]
		} else if(outcome=='heart failure'){
			x[with(x, order(as.numeric(x[,17]), as.character(x[,2]), na.last=NA)),]
		} else if(outcome=='pneumonia'){
			x[with(x, order(as.numeric(x[,23]), as.character(x[,2]), na.last=NA)),]
		} else {
			stop('invalid outcome')
		}
	}

	data <- read.csv("outcome-of-care-measures.csv", colClasses = "character")
	data <- orderfunc(data)
	data.split <- split(data, data$State)

	if(num=='best'){
		res=data.frame(	hospital=sapply(data.split, function(x) as.character(x$Hospital.Name)[1]),
					state=sapply(data.split, function(x) as.character(x$State)[1]))
	} else if(num=='worst'){
		res=data.frame(	hospital=sapply(data.split, function(x) as.character(x$Hospital.Name)[as.numeric((nrow(x)))]),
					state=sapply(data.split, function(x) as.character(x$State)[1]))
	} else {
		res=data.frame(	hospital=sapply(data.split, function(x) as.character(x$Hospital.Name)[as.numeric(num)]),
					state=sapply(data.split, function(x) as.character(x$State)[1]))
	}
	res

}

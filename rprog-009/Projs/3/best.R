best <- function(state, outcome) {
	## Read outcome data
	## Check that state and outcome are valid
	## Return hospital name in that state with lowest 30-day death
	## rate

	data <- read.csv("outcome-of-care-measures.csv", colClasses = "character")
	
	if(state %in% data$State){
		data.state <- data[data$State==state,]
	} else {
		stop('invalid state')
	}
	
	options(warn=-1)
	if(outcome=='heart attack'){
		res=as.character(data.state[with(data.state, order(as.numeric(data.state[,11]),data.state[,2],na.last=NA)),][1,][2])
	} else if(outcome=='heart failure'){
		res=as.character(data.state[with(data.state, order(as.numeric(data.state[,17]),data.state[,2],na.last=NA)),][1,][2])
	} else if(outcome=='pneumonia'){
		res=as.character(data.state[with(data.state, order(as.numeric(data.state[,23]),data.state[,2],na.last=NA)),][1,][2])
	} else {
		stop('invalid outcome')
	}
	res
}
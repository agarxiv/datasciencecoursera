rankhospital <- function(state, outcome, num = 'best') {

	## Read outcome data
	## Check that state and outcome are valid
	## Return hospital name in that state with the given rank
	## 30-day death rate
	
	options(warn=-1)
	data <- read.csv("outcome-of-care-measures.csv", colClasses = "character")
	
	if(state %in% data$State){
		data.state <- data[data$State==state,]
	} else {
		stop('invalid state')
	}
		
	if(outcome=='heart attack'){
		dat=data.state[with(data.state, order(as.numeric(data.state[,11]),data.state[,2],na.last=NA)),]
	} else if(outcome=='heart failure'){
		dat=data.state[with(data.state, order(as.numeric(data.state[,17]),data.state[,2],na.last=NA)),]
	} else if(outcome=='pneumonia'){
		dat=data.state[with(data.state, order(as.numeric(data.state[,23]),data.state[,2],na.last=NA)),]
	} else {
		stop('invalid outcome')
	}

	if(num=='best'){
		res=as.character(dat[1,][2])
	} else if(num=='worst'){
		res=as.character(dat[as.numeric(nrow(dat)),][2])
	} else if(num > length(data.state$Hospital.Name)){
		return(NA)
	} else {
		res=as.character(dat[as.numeric(num),][2])
	}
	res

}
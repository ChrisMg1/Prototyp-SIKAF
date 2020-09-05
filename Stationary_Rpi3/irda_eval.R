# my_path <- 'F:\\temp\\'
my_path <- '/home/pi/myscripts/'

cut_table <- function(starti, stopi, my_in_table) {
		ret_table <- my_in_table[starti:stopi,]
		return(ret_table)
	}

my_in_path <- paste(my_path, "logfiles/irda.log", sep="")
in_table <- read.table(my_in_path)



# Kill 'non-plausible' values (esp. manual breaks)
my_table <- subset(in_table, in_table$V2 < 100000)

# Renumber table
rownames(my_table) <- NULL

pulse_table <- subset(my_table, my_table$V1 == 'pulse')
space_table <- subset(my_table, my_table$V1 == 'space')


# start looking for breaks

# define threshold
break_th <- 1000
start_th <- 1
stop_th <- 1
table_no <- 1

# Generate Target-Vector
my_button_list <- vector("list", 100)


for (i in 1:nrow(my_table)) {

	# look for 'big break' as end
   if (my_table[i,2] > break_th) {
	print(paste('found break @', i, ', creating list no ', table_no, sep=""))
	# set index on stop row
	stop_th <- i
	my_button_list[[table_no]] <- subset(my_table[start_th:stop_th,], my_table[start_th:stop_th,]$V2 < 1000)

	# set new start row on ladder stop row
	start_th <- stop_th
	
	# iterate vector
	table_no <- table_no + 1
	}
}

# clean up
my_button_list <- my_button_list[my_button_list != "NULL"]


# plot whole series
jpeg(paste(my_path, 'plots/plot_time_series.jpg', sep=""))
plot(rownames(my_table), my_table$V2)
dev.off()

jpeg(paste(my_path, 'plots/plot_pulse_hist.jpg', sep=""))
hist(pulse_table$V2, xlim=c(0,100000), ylim=c(0,300), breaks=100)
dev.off()

jpeg(paste(my_path, 'plots/plot_space_hist.jpg', sep=""))
hist(space_table$V2, xlim=c(0,100000), ylim=c(0,300), breaks=100)
dev.off()

# plot each supset (= buttons)

for (k in 1:length(my_button_list)) {
	# create file name
	my_file_name <- paste('plots/ts_button2_', k, '.jpg', sep="")
	jpeg(paste(my_path, my_file_name, sep=""))
	plot(rownames(my_button_list[[k]]), my_button_list[[k]]$V2)
	lines(rownames(my_button_list[[k]])[order(rownames(my_button_list[[k]]))], my_button_list[[k]]$V2[order(rownames(my_button_list[[k]]))], pch=16)

	dev.off()
	
#	print (paste('list No. ', k, ':', sep=""))
#	print(my_button_list[[k]]) 
}


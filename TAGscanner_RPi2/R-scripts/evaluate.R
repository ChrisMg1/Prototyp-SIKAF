library(zoo)
library(ggplot2)

G5 <- read.table('/home/pi/my_scripts/logfiles/20160905_G5-received.log', sep=';')
BT <- read.table('/home/pi/my_scripts/logfiles/20160905_BT-received.log', sep=';')

G5 <- as.data.frame(G5)
colnames(G5) <- c("timestamp", "ping_ok", "distance")
G5$timestamp <- as.POSIXlt(G5$timestamp)

BT <- as.data.frame(BT)
colnames(BT) <- c("timestamp", "ID", "major", "minor", "R_TX", "distance")
BT$timestamp <- as.POSIXlt(BT$timestamp)

##-- cut for test
#G5 <- head(G5, n=20)
#BT <- head(BT, n=10)
print (typeof(G5[4,1]))
print (typeof(G5[4,2]))

##--

# BT$minor <- BT$minor - 19

# add "0" after last beacon-receive
lastBT <- tail(BT,n=1)
lastBT$minor <- 0
lastBT$timestamp <- lastBT$timestamp + 1
#BT=rbind(BT,lastBT)


#plot(G5$timestamp, G5$ping_ok, xaxt='n', type='b', ylim=c(0.0,22.0), xlab=format(G5$timestamp[1], "%c"), ylab='')
#par(new=T)
#plot(BT$timestamp, BT$minor, xaxt='n', type='b', ylim=c(0.0,22.0), xlab='', ylab='')

#axis.POSIXct(1, at=BT$timestamp, labels=format(BT$timestamp, "%S"))

#daterange=c(as.POSIXlt(min(BT$timestamp)), as.POSIXlt(max(BT$timestamp)))
#axis.POSIXct(1, at=seq(daterange[1], daterange[2], by="sec"), format="%S")

#par(new=F)


# replace value with non-scaled alive-measure

BT$minor[BT$minor == 20] <- "BT_packet"
G5$ping_ok[G5$ping_ok == 1] <- "WiFi_packet"

df1<-data.frame(x=BT$timestamp,y=BT$minor)
df2<-data.frame(x=G5$timestamp,y=G5$ping_ok)

df3<-data.frame(x=BT$timestamp,y=BT$distance)


tag_data <- ggplot(df1,aes(x,y))+
	geom_point(aes(color="Bluetooth"))+
	geom_point(data=df2,aes(color="WiFi"))+
	geom_line(data=df3,aes(color="Movement"))+
	scale_color_manual(values=c("#00ff00", "#0000ee", "#e32126"))+
	labs(x="Timestamp",y="Data",color="Device")+
	theme(legend.position="bottom")
#print(tag_data)
ggsave(file='/home/pi/my_scripts/plots/data.png',plot=tag_data)

# write(G5, file="/home/pi/my_scripts/logfiles/test.log", sep=";")


BT_test <- head(BT,n=7)
print(BT_test)

BT_test$minor[BT_test$minor == 20] <- "BT_ok"
print(BT_test)




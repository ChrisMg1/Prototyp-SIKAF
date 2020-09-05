library(ggplot2)
library(randtests)

new_ran=data.frame(c(1,2,3,1,2,3,1,2,3,1,2,3))
# new_ran=data.frame(sample(1:100, 12, replace=T))
# new_ran=data.frame(sample(1:100, 1300000, replace=T))
# new_ran=data.frame(runif(1300000, min=1, max=100))
# new_ran=data.frame(rnorm(1300000))

print(typeof(new_ran))

#print(new_ran[5,])
#print(typeof(new_ran[5,]))

new_ran2 <- as.matrix(new_ran)
print(new_ran2)
print(typeof(new_ran2))


print(is.numeric(new_ran2))

print(runs.test(new_ran2))
#print(rank.test(new_ran2))


#plot=qplot(new_ran, geom="histogram") 
#ggsave(plot,file="graph1.pdf")

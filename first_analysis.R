#!/usr/bin/Rscript

library('ggplot2')

setwd('/Users/johnmyleswhite/Academics/Princeton/Research/Analysis of R Function Usage')

data.set <- read.csv('token_data/function_usage_report.csv', header = TRUE, sep = ',')

top.10.most.used.functions.data.set <- head(data.set[rev(order(data.set$Call.Count)),], n = 10)
top.25.most.used.functions.data.set <- head(data.set[rev(order(data.set$Call.Count)),], n = 25)
top.100.most.used.functions.data.set <- head(data.set[rev(order(data.set$Call.Count)),], n = 100)

png('graphs/r_log_frequencies.png')
print(qplot(log(data.set$Call.Count),
            xlab = 'Log Occurrences of Function',
            main = 'Log Frequency of Function Calls by Function'))
dev.off()

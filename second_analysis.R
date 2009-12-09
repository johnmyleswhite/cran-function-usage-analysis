#!/usr/bin/Rscript

library('ggplot2')

setwd('/Users/johnmyleswhite/Academics/Princeton/Research/Analysis of R Function Usage')

original.data.set <- read.csv('token_data/function_usage_report.csv', header = TRUE, sep = ',')

new.data.set <- read.csv('token_data/new_function_usage_report.csv', header = TRUE, sep = '\t')

functions <- with(new.data.set, unique(Function.Name))

packages.using.function <- c()

for (f in functions)
{
  p.count <- with(subset(new.data.set, Function.Name == f), length(unique(Package.Name)))
  packages.using.function <- c(packages.using.function, p.count)
}

package.data.set <- data.frame(Function = functions, Packages = packages.using.function)

merged.data.set <- merge(original.data.set, package.data.set,
                         by.x = 'Function.Name', by.y = 'Function')

png('graphs/package_function_frequencies.png')
print(qplot(log(merged.data.set$Call.Count), merged.data.set$Packages,
            data = merged.data.set, 
            xlab = 'Log Number of Times Function Called',
            ylab = 'Number of Packages using Function',
            main = 'R Functions across Packages and Within Packages'))
dev.off()

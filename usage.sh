#!/bin/bash

# To use, you'll have to edit cran_DATE references here and in Ruby scripts.
# For example, I have cran_11_19_2009 as my source data set.

mkdir cran_DATE
cd cran_DATE
perl ../spider_cran.pl
cd ..

mkdir token_data
ruby extract_overall_token_counts.rb
ruby extract_package_level_token_counts.rb

mkdir graphs
Rscript first_analysis.R
Rscript second_analysis.R

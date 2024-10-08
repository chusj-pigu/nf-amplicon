#!/usr/bin/env Rscript
library(tidyverse)
library(writexl)

options(width = 400)
options(warn=-1)

summariseReads <- . %>% 
    group_by(`#'chr'`) %>% 
    select(-c("'start'", "'end'")) %>% 
    summarise_all( . %>% mean() )

list.files(pattern = "*.tab") %>% 
    enframe() %>% 
    mutate( data = map(value, . %>%  read_delim()  %>% summariseReads() ))  %>% 
    select(value, data) %>% 
    mutate(value = paste0(value, ".summary")) %>% 
    deframe() %>% write.csv("readCounts_summary.csv")

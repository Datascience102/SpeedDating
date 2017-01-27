library(readr)
Speed_Dating_Data <- read_csv("data/SpeedDatingData_clean.csv")

print(colnames(Speed_Dating_Data))

paste("nrows: ", length(rownames(Speed_Dating_Data)))
paste("ncols: ", length(colnames(Speed_Dating_Data)))

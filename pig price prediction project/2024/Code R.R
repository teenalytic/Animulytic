# Load necessary libraries
library(tidyverse)
library(glue)

# Set the working directory to the location of your CSV files
path = '/data/workspace_files/'
setwd(path)

# List of files to process
files <- c("bone_poultry2024.csv", "bovine_tenderlion2024.csv",
           "cabbage2024.csv", "catfish2024.csv","corn2024.csv",
           "cucumber2024.csv", "doc_hen2024.csv", "doc-broiler.csv",
           "egg2024.csv", "finished_pig2024.csv", "piglet2024.csv",
           "pork_belly2024.csv","Pork_hip2024.csv","Pork_loin2024.csv",
           "pork_shoulder2024.csv","Pork_tenderloin2024.csv","SBM47_2024.csv",
           "tilapia2024.csv","wingstick2024.csv")

# Define a function to clean and join data from multiple CSV files
clean_join_df <- function(files) {
  # Initialize an empty list to store processed data
  data <- list()
  
  # Loop through each file in the files vector
  for (file in files) {
    # Read the CSV file
    csv_file <- read_csv(file)
    
    # Extract the nametag from the CSV file
    nametag <- csv_file[1, 3]
    
    # Rename the columns using glue to include the nametag
    colnames(csv_file) <- c("date", "type", "item", "unit",
                            glue("min_price_{nametag}"),
                            glue("max_price_{nametag}"),
                            glue("avg_{nametag}"))
    
    # Process the date and create a new_date column
    full_df <- csv_file %>%
      separate(col = date, into = c("day", "month", "year"), sep = " ") %>%
      mutate(month_new = case_when(
        month == "ม.ค." ~ 1,
        month == "ก.พ." ~ 2,
        month == "มี.ค." ~ 3,
        month == "เม.ย." ~ 4,
        month == "พ.ค." ~ 5, 
        month == "มิ.ย." ~ 6,
        month == "ก.ค." ~ 7,
        month == "ส.ค." ~ 8,
        month == "ก.ย." ~ 9,
        month == "ต.ค." ~ 10,
        month == "พ.ย." ~ 11,
        month == "ธ.ค." ~ 12
      ),
      year_new = as.numeric(year) - 543) %>%
      unite(new_date_chr, year_new, month_new, day, sep = "-", remove = FALSE) %>%
      mutate(new_date = ymd(new_date_chr)) %>%
      select(13, 6, 8, 9, 10) 
    
    # Append the processed data to the data list
    data <- append(data, list(full_df))
  }
  
  # Reduce the list of data frames to a single data frame by performing inner join
  data <- data %>% reduce(inner_join, by = "new_date")
  
  # Return the final joined and cleaned data
  return(data)
}

# Call the clean_join_df function to process the files and join the data
processed_data <- clean_join_df(files)

#Write CSV
write_csv(processed_data, "livestockprice.csv", col_names = T)
#End


library(caret)
livestockprice

df <- livestockprice %>%
      select(contains('avg')) %>%
      select(bone_poultry = 1,
             bovine_tenderlion = 2,
             cabbage = 3,
             catfish = 4,
             corn = 5,
             cucumber = 6,
             Doc_hen = 7,
             Doc_poultry = 8,
             egg = 9,
             livepig = 10,
             piglet = 11,
             pork_belly = 12,
             pork_hip = 13,
             pork_tenderloin = 14,
             pork_shoulder = 15,
             pork_loin = 16,
             sbm = 17,
             tilapia = 18,
             )
      


#split
set.seed(42)
n <- nrow(df)
id <- sample(n, size = n*0.70)
train_df <- df[id,]
test_df <- df[-id,]

#train linear regession model 1 : 
set.seed(42)
ctrl <- trainControl(method = "cv",
                     number = 5,
                     verboseIter = TRUE)

lm_model_egg <- train(livepig ~ egg,
                             data = train_df,
                             method = "lm",
                             trControl = ctrl)

#test linear regession model 1 : 
p_lm <- predict(lm_model_egg, newdata = test_df)

#evaluated linear regession model 1 : pork_belly
RMSE(p_lm, test_df$livepig)
summary(lm_model_egg)

ggplot(data = df, aes(df$livepig,df$egg))+
          geom_point()

# Import necessary libraries
import pandas as pd
import os
from functools import reduce
from datetime import datetime

# Set the working directory to the location of your CSV files
path = '/data/workspace_files/'
os.chdir(path)

# List of files to process
files = ["bone_poultry.csv", "egg.csv", "finished_pig.csv", "piglet.csv",
         "pork_belly.csv", "pork_shoulder.csv"]

# Define a function to clean and join data from multiple CSV files
def clean_join_df(files):
    # Initialize an empty list to store processed data
    data = []

    # Loop through each file in the files list
    for file in files:
        # Read the CSV file
        csv_file = pd.read_csv(file)

        # Extract the nametag from the CSV file
        nametag = csv_file.iloc[0, 2]

        # Rename the columns using f-strings to include the nametag
        csv_file.columns = ["date", "type", "item", "unit",
                            f"min_price_{nametag}",
                            f"max_price_{nametag}",
                            f"avg_{nametag}"]

        # Process the date and create a new_date column
        csv_file[['day', 'month', 'year']] = csv_file['date'].str.split(' ', expand=True)
        csv_file['month_new'] = csv_file['month'].replace({
            "ม.ค.": 1, "ก.พ.": 2, "มี.ค.": 3, "เม.ย.": 4,
            "พ.ค.": 5, "มิ.ย.": 6, "ก.ค.": 7, "ส.ค.": 8,
            "ก.ย.": 9, "ต.ค.": 10, "พ.ย.": 11, "ธ.ค.": 12
        })
        csv_file['year_new'] = csv_file['year'].astype(int) - 543
        csv_file['new_date'] = pd.to_datetime(
            csv_file['year_new'].astype(str) + '-' +
            csv_file['month_new'].astype(str) + '-' +
            csv_file['day'].astype(str)
        )

        # Select necessary columns
        full_df = csv_file[['new_date', f"min_price_{nametag}", f"max_price_{nametag}", f"avg_{nametag}"]]

        # Append the processed data to the data list
        data.append(full_df)

    # Reduce the list of DataFrames to a single DataFrame by performing an inner join
    data = reduce(lambda left, right: pd.merge(left, right, on='new_date', how='inner'), data)

    # Return the final joined and cleaned data
    return data

# Call the clean_join_df function to process the files and join the data
processed_data = clean_join_df(files)

# Write CSV
processed_data.to_csv("livestockprice.csv", index=False)

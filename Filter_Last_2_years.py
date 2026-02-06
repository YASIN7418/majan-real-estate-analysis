import pandas as pd
from datetime import datetime, timedelta

# 1. Load CSV with proper encoding
file_path = file_path = r"C:\Users\moham\Downloads\Transactions.csv"
 # replace with your CSV file path
df = pd.read_csv(file_path, encoding='utf-8-sig')  # try 'utf-8' if this gives error

# 2. Convert 'instance_date' to datetime format
df['instance_date'] = pd.to_datetime(df['instance_date'], format='%d-%m-%Y')

# 3. Define date range for last 2 years
end_date = datetime(2026, 2, 3)
start_date = end_date - timedelta(days=2*365)

# 4. Filter data
filtered_df = df[(df['instance_date'] >= start_date) & (df['instance_date'] <= end_date)]

# 5. Save filtered data to a new CSV with encoding
filtered_df.to_csv('filtered_last_2_years.csv', index=False, encoding='utf-8-sig')

print("Filtered data saved! Rows:", len(filtered_df))

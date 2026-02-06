import pandas as pd

# Load CSV with UTF-8 encoding for Arabic support
df = pd.read_csv(r"C:\Users\moham\OneDrive\Documents\HR - PROJECT\filtered_last_2_years.csv", encoding='utf-8')

# Filter rows where 'master_project_en' contains 'majan' (case-insensitive)
filtered_df = df[df['master_project_en'].str.contains('majan', case=False, na=False)]

# Display filtered data
print("Filtered Majan rows:")
print(filtered_df)
print(f"\nTotal Majan rows found: {len(filtered_df)}")

# SAVE SECTION - Creates majan_filtered.csv in same folder as your script
filtered_df.to_csv('majan_filtered.csv', index=False, encoding='utf-8')
print("\n✅ Saved to 'majan_filtered.csv' (check your script folder)")

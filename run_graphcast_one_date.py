import datetime
from earth2mip.networks import get_model
from earth2mip.initial_conditions import cds
from earth2mip.inference_ensemble import run_basic_inference
import os

# Initialize the model
time_loop = get_model("e2mip://graphcast_operational", device="cuda:0")
data_source = cds.DataSource(time_loop.in_channel_names)

# Function to delete cache
def delete_cache():
    os.system('rm -rf /home1/08105/ms86336/.cache/*')
    
# Loop through each day of 2021
start_date = datetime.datetime(1982, 9, 22)
end_date = datetime.datetime(2011, 12, 31)
current_date = start_date

while current_date <= end_date:
    # Run inference
    ds = run_basic_inference(time_loop, n=60, data_source=data_source, time=current_date)
    ds = ds.to_dataset('channel')
            
    # Save the NetCDF file with the date stamp
    date_str = current_date.strftime('%Y_%m_%d')
    file_name = f'graphcast_{date_str}.nc'
    ds.to_netcdf(file_name)
                                
    # Delete the cache
    delete_cache()
                                            
    # Move to the next day
    current_date += datetime.timedelta(days=1)

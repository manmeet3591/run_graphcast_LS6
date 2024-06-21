import datetime
from earth2mip.networks import get_model
from earth2mip.initial_conditions import cds
from earth2mip.inference_ensemble import run_basic_inference
import os
import shutil
import torch
import sys

year=int(sys.argv[1])
device_index=int(sys.argv[2])


def task(year,device_index):
    # Get the model and specify the device
    time_loop  = get_model("e2mip://graphcast_operational", device=f'cuda:{device_index}')

    # Create the data source
    data_source = cds.DataSource(time_loop.in_channel_names)

    # Loop through the months and days of the year
    for month in range(1, 13):
        for day in range(1, 32):
            try:
                time = datetime.datetime(year, month, day)
                print(f"Running inference for {time.strftime('%Y-%m-%d')}")

                # Run the inference
                ds = run_basic_inference(
                    time_loop,
                    n=60,
                    data_source=data_source,
                    time=time,
                )
                torch.cuda.empty_cache()
                # Convert the output to a dataset and save it to a NetCDF file
                name = f"graphcast_{year}_{month:02d}_{day:02d}.nc"
                ds = ds.to_dataset('channel')
                ds.to_netcdf(name)
                print(f"Saved dataset to {name}")

            except ValueError:
                # Skip invalid dates
                continue

task(year=year,device_index=device_index)

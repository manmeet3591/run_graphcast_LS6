#!/bin/bash

# Ensure the script exits on any error
set -e

# Load the Singularity module
echo "Loading Singularity module..."
module load tacc-singularity

if [ -e modulus_23.11.sif ]
then
    echo "container exists"
else
    echo "Downloading the container modulus 23.11..."
    singularity pull docker://nvcr.io/nvidia/modulus/modulus:23.11
fi

# Run the Singularity container with NVIDIA GPU support
echo "Running Singularity container..."
singularity run --nv modulus_23.11.sif <<EOF
#!/bin/bash

# Activate the Conda environment

echo "Activating Conda environment..."

source ~/.bashrc

conda activate earth2mip

# Launch the Python script
echo "Launching Python script..."

python run_graphcast.py 2016 0 & #change the year
PID1=$!

python run_graphcast.py 2017 1 & #change the year and if there is only one gpu, comment this and the next 3 lines
PID2=$!

wait $PID1
wait $PID2
EOF

# Inform the user that the script has completed successfully
echo "Script has completed successfully."
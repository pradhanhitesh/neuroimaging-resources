import subprocess
import os
import time
from concurrent.futures import ProcessPoolExecutor
import argparse

# Define the directory containing the T1 and FLAIR images
t1_images_dir = "/absolute/path/to/your/t1/image/folder"
flair_images_dir = "/absolute/path/to/your/flair/image/folder"
output_dir = "/absolute/path/to/your/output/folder"
temp_dir = "/absolute/path/to/your/temp/folder"

# Argument parser
parser = argparse.ArgumentParser(description="Run lst command in parallel for multiple T1 and FLAIR images.")
parser.add_argument("--max_workers", type=int, default=os.cpu_count(), help="Maximum number of parallel processes to run.")
args = parser.parse_args()

# List all T1 and FLAIR images in their respective directories
# LST-AI requires ".nii.gz" files as input for T1 and T2F images
t1_images = [f for f in os.listdir(t1_images_dir) if f.endswith('.nii.gz')]
flair_images = [f for f in os.listdir(flair_images_dir) if f.endswith('.nii.gz')]

# Sort the lists to ensure pairs are matched correctly
t1_images.sort()
flair_images.sort()

# Ensure that the number of T1 and FLAIR images match
if len(t1_images) != len(flair_images):
    raise ValueError("The number of T1 images does not match the number of FLAIR images.")

# Function to process a pair of images
def process_images(t1_image, flair_image):
    t1_image_path = os.path.join(t1_images_dir, t1_image)
    flair_image_path = os.path.join(flair_images_dir, flair_image)
    subject_name = t1_image_path.split("_t1")[0].split("/")[-1]
    device_type = 'cpu'
    threads = '1'

    command = [
        'lst',
        '--t1', t1_image_path,
        '--flair', flair_image_path,
        '--output', os.path.join(output_dir, subject_name),
        '--temp', os.path.join(temp_dir, subject_name),
        '--device', device_type,
        '--threads', threads
    ]

    print(f"Running command: {' '.join(command)}")
    start_time = time.time()
    result = subprocess.run(command, capture_output=True, text=True)
    end_time = time.time()

    # Check if the command was successful
    if result.returncode == 0:
        print(f"Successfully processed T1: {t1_image} and FLAIR: {flair_image}")
    else:
        print(f"Error processing T1: {t1_image} and FLAIR: {flair_image}: {result.stderr}")

    # Calculate and print the time taken
    time_taken = end_time - start_time
    print(f"Time taken to process: {time_taken:.2f} seconds")

# Number of parallel processes to run
max_workers = args.max_workers

# Use ProcessPoolExecutor to run processes in parallel
with ProcessPoolExecutor(max_workers=max_workers) as executor:
    executor.map(process_images, t1_images, flair_images)

print("Processing complete.")

# Enhancing Seismic Cross-Correlation Workflows with a Double-Streaming Approach using Dispel4py and CAPIO

This repository provides a modified version of the seismic cross-correlation workflow (originally available [here](https://github.com/StreamingFlow/d4py_workflows/tree/main/tc_cross_correlation)) with added support for streaming input via [CAPIO](https://github.com/High-Performance-IO/capio/).  
You can find the updated workflow in the `workflow/` directory.

## Contents

- `capio-cross-corr.json`: CAPIO-CL configuration file required to execute the workflow.
- `workflow/`: Modified Dispel4py-based cross-correlation workflow supporting CAPIO-based streaming.
- `workflow/run_with_capio.sh`: Sample SLURM job script to run the workflow (note: this must be adapted to your specific machine or cluster environment).

---

## How to Run the Workflow

1. **Install CAPIO**
   - Clone and build the latest version of CAPIO from the `capio-v2` branch.

2. **Install Dispel4py**
   - Follow the installation instructions from the [Dispel4py repository](https://github.com/StreamingFlow/d4py).

3. **Configure the Workflow**
   - Set up the workflow as described in the original [dispel4py_workflows repository](https://github.com/StreamingFlow/d4py_workflows).

4. **Execute the Workflow**
   - Configure the template ```workflow/run_with_capio.sh``` SLURM script 
   - Submit the configured file to the queue manager.
 > [!NOTE]
 > The provided SLURM script (`run_with_capio.sh`) is a template. Make sure to modify it according to the specifics of your HPC system (e.g., modules, paths, job parameters). Refer to the [CAPIO documentation](https://capio.hpc4ai.it/docs/middleware/) for guidance on  how to change the CAPIO parameters.


# Density Estimation Network Application

## Description

This application showcases a density estimation neural network (DENN) applied to a mathematical simulator using MATLAB and Python. The simulated dynamic system is the Rosenzweig-MacArthur oscillation under a CIR stochastic process, which describes the population dynamics between predators and prey. The DENN aims to estimate the conditional density of model parameters given observable dynamics, facilitating a deeper understanding of ecological interactions.

## Installation and Usage

To utilize the network:

- **Python Setup and Utilities:** 
  - **Key Package:** The `sbi` package is crucial for network training; details can be found on the [sbi authors' website](https://github.com/sbi-dev/sbi). 
  - **Utility Functions:** Use `DENN_utils.py` for specialized functions related to the Rosenzweig-MacArthur oscillation model, which aid in data preprocessing and analysis.
  - **Setup Instructions:** Download `DENN_Training.ipynb` and follow the instructions within the notebook to replicate the model.
- **MATLAB Simulation:** MATLAB is employed to simulate data due to the complexity of the dynamic system. This separation ensures clarity and manageability in data handling and network training.


## History

**Version 1.0.0 (2023-11-29)**
- **Fixed:** Addressed a bug in `DENN_utils.py` affecting function outputs.

**Version 2.0.0 (2024-07-05)**
- **Revised:** Updated all MATLAB script in the `DENN_MATLAB` folder with extensive comments to enhance readability.

**Version 2.0.1 (2024-07-16)**
- **Streamlined:** Refined the workflow in `DENN_Training.ipynb` to improve ease of replication.


## Credits

- **Mentor:** Jonathan E. Rubin, Department of Mathematics, University of Pittsburgh

## License

All source code is available under a BSD 3-clause license. You may freely use and modify the code, without warranty, provided that attribution to the authors is maintained. See the LICENSE.md file for the full license text.


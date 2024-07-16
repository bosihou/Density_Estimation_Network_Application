# Density Estimation Network Application

## Description

This is an application example of density estimation neural network (DENN) on a mathematical simulator, with the help of MATLAB and Python. The dynamic system presented in the code is Rosenzweig-Macarthur oscillation under CIR stochastic process, which described the population dynamics between predator and prey. The goal of using DENN is to estimate the conditional density of model parameters given observable predator-prey dynamics in real-life, which helps us better understand the interactions within ecological systems. 

## Installation and Usage

The `sbi` package in Python is the key toward network training and building. Details of this package can be found on the 
[sbi authors' website](https://github.com/sbi-dev/sbi). Users who wish to replicate the model can download `DENN_Training.ipynb` and follow the instructions in the notebook. `DENN_utils` serves as the utility package for the project, which contains built-in functions specifically designed for Rosenzweig-Macarthur oscillation model.

MATLAB is used for data simulation. As the dynamic system of the study is complex, we have separate the data generation process from the network training. Users can also load and decode `network_self.pickle` to directly test and use the network.



## History

#### Version 1.0.0 (2023-11-29)
- **Fixed:** Addressed a bug in `DENN_utils.py` affecting function outputs.

#### Version 2.0.0 (2024-07-05)
- **Revised:** Updated all MATLAB script in the 'DENN_MATLAB' folder with extensive comments to enhance readability.

#### Version 2.0.1 (2024-07-16)
- **Streamlined:** Refined the workflow in `DENN_Training.ipynb` to improve ease of replication.


## Credits

Mentor - Jonathan Rubin, Department of Mathematics, University of Pittsburgh

## License

All source code is made available under a BSD 3-clause license. You can freely use and modify the code, without warranty, so long as you provide attribution to the authors. See LICENSE.md for the full license text.

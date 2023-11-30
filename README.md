# Density Estimation Network Application

## Description

This is an application example of density estimation neural network (DENN) on a mathematical simulator, with the help of MATLAB and Python. The dynamic system presented in the code is Rosenzweig-Macarthur oscillation under CIR stochastic process, which described the population dynamics between predator and prey. The goal of using DENN is to estimate the conditional density of model parameters given observable predator-prey dynamics in real-life, which helps us better understand the interactions within ecological systems. 

## Installation and Usage

The `sbi` package in Python is the key toward network training and building. Details of this package can be found on the 
[sbi authors' website](https://github.com/sbi-dev/sbi). Users who wish to replicate the model can download `DENN_training.ipynb` and follow the instructions in the notebook. 

MATLAB is used for data simulation. As the dynamic system of the study is complex, we have separate the data generation process from the network training. Users can also load and decode `network_self.pickle` to directly test and use the network.

## History

Version 1.0 (2023-11-29) - Revised `DENN_utils.py`

## Credits

Mentor - Jonathan Rubin, Department of Mathematics, University of Pittsburgh

## License
 
The MIT License (MIT)

Copyright (c) 2023 Bosi Hou

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

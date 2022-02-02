# Identification-SFs-TBs
[![standard-readme compliant](https://img.shields.io/badge/readme%20style-standard-brightgreen.svg?style=flat-square)](https://github.com/RichardLitt/standard-readme)

This program is an algorithm to identify SFs and TBs in FCC crystal in molecular dynamics. It can cooperate with `Ovito` to realize post-processing.
This program performs the neighborhood-based distinguishing algorithm (ANBDA) for a particle system. The ANBDA is used to identify the defect structure in the FCC phase by analyzing the local structural environment of the atoms and their neighbors and display the results through color-coded particles to show the SFs, TBs, or other structures in the FCC.
## Install
1. Download source code. 
2. Installed `Matlab`.
This program is written in the environment of MATLAB 2017, which does not mean that this version or higher must be used to run this program. Earlier versions are still compatible.
3. Installed `Ovito`.
This program realizes the interaction with ovito through `data` files, so `Ovito` needs to be installed.
  
## Quick Start
If you downloaded the source code，open a terminal in current directory and run: "main.m". There is already an example [test.data](test.data)  to test the program. The program will output a [copy_test.data](copy_test.data) to overwrite the [copy_test.data](copy_test.data) in the current directory.
## Usage


## License
Apache © Zhiwen Bai

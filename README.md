# Identification-SFs-TBs
[![standard-readme compliant](https://img.shields.io/badge/readme%20style-standard-brightgreen.svg?style=flat-square)](https://github.com/RichardLitt/standard-readme)

This program is an algorithm to identify SFs and TBs in FCC crystal in molecular dynamics. It can cooperate with `Ovito` to realize post-processing.

This program performs the Atomic Neighborhood-Based Distinguishing Algorithm (ANBDA) for a particle system. The ANBDA is used to identify the defect structure in the FCC phase by analyzing the local structural environment of the atoms and their neighbors and display the results through color-coded particles to show the SFs, TBs, or other structures in the FCC.

## Install
1. Download source code.
2. Installed `MATLAB`.
This program is written in the environment of MATLAB 2017, which does not mean that this version or higher must be used to run this program. Earlier versions are still compatible.
3. Installed `OVITO`.
This program realizes the interaction with ovito through `data` files, so `OVITO` needs to be installed.
  
## Quick Start
If you downloaded the source code，open a terminal in current directory and run: [main.m](main.m). There is already an example [test.data](test.data)  to test the program. The program will output a [copy_test.data](copy_test.data) to overwrite the [copy_test.data](copy_test.data) in the current directory.
## Usage
1. Inputs

(1) Fixed Cutoff

Here, a threshold distance criterion is used to determine whether a pair of atoms are neighbors or not. The cutoff distance must be chosen according to the crystal structure at hand. For face-centered cubic (FCC) the cutoff radius must lie midway between the first and the second shell of neighbors. We choose a fixed cutoff distance equal to the average of the first and second disttance as the "default" value. OVITO also provides a list of optimal cutoff distances for FCC crystal structures formed by common pure elements. These optimal radii can be found in the Presets drop-down list of the Common Neighbor Analysis (CNA) modifier.

(2) Lattice Constant

Lattice constant is the lattice constant of FCC crystal structures formed by common pure elements or the average lattice constant of multicomponent alloy.The lattice constant determines the default value of the cutoff distance.
Default value：LC = 3.6; % lattice constant of Cu

(3) Data File

Atomic coordinates and structural type are stored in the data file. The format of the file is "LAMMPS Dump File", which could be written by Ovito. 

① Add File and add modification. ② Select analysis modifier "Dislocation analysis (DXA)", "Ackland-Jones analysis" or "Common neighbor analysis"

![image](https://github.com/White-Charles/Identification-SFs-TBs/blob/main/Readme_picture.png)

2. Outputs



## License
Apache © Zhiwen Bai

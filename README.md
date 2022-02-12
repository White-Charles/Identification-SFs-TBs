# Identification-SFs-TBs
[![standard-readme compliant](https://img.shields.io/badge/readme%20style-standard-brightgreen.svg?style=flat-square)](https://github.com/RichardLitt/standard-readme)

This program is an algorithm to identify stacking faults and twin boundaries defects in FCC crystal in molecular dynamics. It can cooperate with `Ovito` to realize post-processing.

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

Atomic coordinates and structural type are stored in the data file. The format of the file is "LAMMPS Dump File", which could be written by Ovito. The steps are shown in Figure 1.

![image](https://github.com/White-Charles/Identification-SFs-TBs/blob/main/Readme_picture.png)
Figure.1

① Laod File and add modification. ② Select analysis modifier "Dislocation analysis (DXA)", "Ackland-Jones analysis" or "Common neighbor analysis". The modifier outputs the classification results as a new particle property named Structure Type. The structural type determined by the algorithm is encoded as an integer value:

- 0 = Other, unknown coordination structure
- 1 = FCC, face-centered cubic
- 2 = HCP, hexagonal close-packed
- 3 = BCC, body-centered cubic
- 4 = ICO, icosahedral coordination

③ Export File and select the format "LAMMPS Dump File". ④ Notice the order of particle properties to export. ⑤ All done.

2. Outputs

You will get a file in "LAMMPS Dump File" format, but the "Particle Type" represents the defect type rather than the atomic type. 

- 0 = Other, unknown coordination structure
- 1 = TBs, twin boundaries
- 2 = SFs, stacking faults
- 3 = HCP, hexagonal close-packed
 
![image](https://github.com/White-Charles/Identification-SFs-TBs/blob/main/Readme_picture2.png)
Figure.2 (a) The CoCrNi film, colored by structure types. (b) Non-HCP atoms are hidden. (c) HCP atoms are colored defects types.

3. Clustering algorithm

Through the clustering algorithm, you can get more information about the crystal structure and defects, such as the number of TBs or SFs, the number of atoms in the TBs or SFs region, and how large the areas are. You can implementation the interactive process with Matlab software through the  and command line.
![image](https://github.com/White-Charles/Identification-SFs-TBs/blob/main/Readme_picture3.png)
Figure.3 The output picture after the user starts the [main3.m](main3.m), the coordinates are cursor click position. (a) Defect structural clustering analysis (b) The TB is selected (c) The SF is selected (d) The HCP phase is selected.

## Suggestion
The detailed ideas and implementation methods of this project can be seen in the paper. This algorithm is programmed in matlab language. If there are developers with similar ideas, I recommend programming in python language, because ovito provides python interfaces, if you call these interfaces, the workload will be greatly reduced, and the project will be more convenient and beautiful.

If developers still want to use matlab to implement their ideas, this project may provide a reference for ideas and functions on how to deal with box periodicity and how to build adjacent atom tables.

If there are developers who want to further improve this project or want to realize their own ideas on the basis of this project, I would like to express my thanks and welcome. Since this is my first open source project, there may be imperfections. If you have any questions, you can email to baizhiwen@stu.xjtu.edu.cn.

## License
Apache © Zhiwen Bai

---------------------------------------------------
Simple MIMO simulator (v0.2)
(c) Christoph Studer 2014 (studer@cornell.edu)
---------------------------------------------------

# How to start a simulation:

Simply run 

>> simpleMIMOsim

which starts a simulation in a 4x4 MIMO system with 16-QAM using various simple detectors (including linear detectors and a hard-output sphere decoder that achieves ML performance). The simulator runs with default parameters. You can provide your own parameters by passing your own par-structure (see the simulator for an example). 

We highly recommend you to execute the code step-by-step (using Matlab's debug mode) in order to get a very detailed understanding of the simulator. 

# Version 0.1 (June 14, 2014) - initial version for public access
# Version 0.2 (June 16, 2014) - hard-output sphere decoder added

# An Underwater Experience
### Code used to create an underwater themed multi-agent flocking simulation.

## Summary
Using a Boids-based flocking approach, the code included in this repo can is used to create an underwater multi-agent flocking simulation consisting of fish. In addition, a user-controlled shark is implemented which can be controlled with various keyboard controls and acts as an obstacle for the fish.

## Dependecies and Usage
Processing is needed to run this code.

Once Processing has been downloaded, the simulation can be started by running `UnderwaterExperience_BOIDS_.pde`. <br>
**Note:** Fish and shark models are included in a 'data' folder as .obj/.mtl files.

### Vector Operation Library
In addition to the main simulation files, a vector operation class is included for all vector related calculations performed.

## Shark Interaction
A shark is included as an obstacle in the simulation. The fish will actively move away from the shark if they get within a certain distance of it. 

Once the simulation is running, the user can move the shark throughout the scene using the space bar to move the shark forward, and the arrow keys to move it up/down/left/right. Once the shark goes out of the frame, the user can "reset" the shark to the center or lower left/right corners of the frame using 'c', 'l', and 'r' respectively.

SOFTWARE AND DATA FOR PAPER TITLED
Camera-based Online Torque Estimation of a Multi-link Pendulum via Extended Kalman Filtering
To be published in IECON2025 Proceedings

Data is under "Torque computations" and "Discretization comparisons" folders. 

The main files are:
frame.avi - Recording of system captured with high speed camera
NPDD.m - Direct Dynamics function 
NPNE.m - Newton Euler function
NPLoadParameters.m - Load parameters of N link Pendulum
NPStateTransitionFunction - State transition function for EKF
NPMeasurementFunction.m - Measurement Function for EKF
NP_online.slx - Simulink model for online estimation using either hardware or provided video "frame.avi"
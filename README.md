# HeatFDM
a basic code for solving 1D heat transfer equation in MATLAB

There are several methods for solving ODEs and PDEs. Most famous numerical methods for solving ODEs are Runge-Kutta methods. Same story for PDEs are packed into FEM, FVM and FDM.
FDM stands for Finite Difference Method. It is based on discretizing derivatives over some Nodes. Main property or independent variable, will be evaluated over these nodes.
Compared to FEM and FVM, it is not suitable for complex geometries or physics but easier and more understandable. In fact it is the first step if you want to solve PDEs via computer.

This work is based on 1D Steady-State heat transfer equation with convection and source/consume terms.
As mentioned above, this method is very easy, but here we tried to develope a code that could be easily used by students to develope or for understanding concepts of this course.
If you found something interesting do not forget to "pull request".
Our future works will be covering 2D or transient heat transfer.

Best regards

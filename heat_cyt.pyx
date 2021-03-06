#cython: language_level=3

import numpy as np
cimport numpy as array_def
import cython
import time

import matplotlib
matplotlib.use('Agg')
import matplotlib.pyplot as plt

# Set the colormap
plt.rcParams['image.cmap'] = 'BrBG'

@cython.cdivision(True)
cdef evolve(array_def.ndarray[array_def.double_t, ndim=2] u, 
            array_def.ndarray[array_def.double_t, ndim=2] u_previous,		
            double a, double dt, double dx2, double dy2):
    """Explicit time evolution.
       u:            new temperature field
       u_previous:   previous field
       a:            diffusion constant
       dt:           time step. """

    cdef int n = u.shape[0]
    cdef int m = u.shape[1]

    cdef int i,j


    cdef double inver_dx_2 = 1. / dx2
    cdef double inver_dy_2 = 1. / dy2

    for i in range(1, n-1):
        for j in range(1, m-1):
            u[i, j] = u_previous[i, j] + a * dt * ( \
             (u_previous[i+1, j] - 2*u_previous[i, j] + \
              u_previous[i-1, j]) * inver_dx_2 + \
             (u_previous[i, j+1] - 2*u_previous[i, j] + \
                 u_previous[i, j-1]) * inver_dy_2 )
    u_previous[:] = u[:]

def iterate(field, field0, a, dx, dy, timesteps, image_interval):
    """Run fixed number of time steps of heat equation"""

    dx2 = dx**2
    dy2 = dy**2

    dt = dx2*dy2 / ( 2*a*(dx2+dy2) )    

    for m in range(1, timesteps+1):
        evolve(field, field0, a, dt, dx2, dy2)
        if m % image_interval == 0:
            write_field(field, m)

def init_fields(filename):
    # Read the initial temperature field from file
    field = np.loadtxt(filename)
    field0 = field.copy() # Array for field of previous time step
    return field, field0

def write_field(field, step):
    plt.gca().clear()
    plt.imshow(field)
    plt.axis('off')
    plt.savefig('heat_{0:03d}.png'.format(step))
